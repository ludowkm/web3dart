library json_rpc;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:web3dart_plus/crypto.dart';
import 'package:web3dart_plus/web3dart_plus.dart';

// ignore: one_member_abstracts
abstract class RpcService {
  /// Performs an RPC request, asking the server to execute the function with
  /// the given name and the associated parameters, which need to be encodable
  /// with the [json] class of dart:convert.
  ///
  /// When the request is successful, an [RPCResponse] with the request id and
  /// the data from the server will be returned. If not, an RPCError will be
  /// thrown. Other errors might be thrown if an IO-Error occurs.
  Future<RPCResponse> call(String function,
      [List<dynamic>? params, String? overrideUrl]);
}

class JsonRPC extends RpcService {
  static const _requestTimeoutDuration = Duration(seconds: 30);

  JsonRPC(this.url, this.client);

  final String url;
  final Client client;

  int _currentRequestId = 1;

  /// Performs an RPC request, asking the server to execute the function with
  /// the given name and the associated parameters, which need to be encodable
  /// with the [json] class of dart:convert.
  ///
  /// When the request is successful, an [RPCResponse] with the request id and
  /// the data from the server will be returned. If not, an RPCError will be
  /// thrown. Other errors might be thrown if an IO-Error occurs.
  @override
  Future<RPCResponse> call(String function,
      [List<dynamic>? params, String? overrideUrl]) async {
    try {
      params ??= [];

      final requestPayload = {
        'jsonrpc': '2.0',
        'method': function,
        'params': params,
        'id': _currentRequestId++,
      };

      final response = await client
          .post(
            Uri.parse(overrideUrl ?? url),
            headers: {'Content-Type': 'application/json'},
            body: json.encode(requestPayload),
          )
          .timeout(_requestTimeoutDuration);

      if (RpcInterceptor.instance.onRpcUrlError != null &&
          ((response.statusCode >= 500 && response.statusCode <= 599) ||
              response.statusCode == 404)) {
        final overrideUrl =
            await RpcInterceptor.instance.onRpcUrlError!.call(url);
        if (overrideUrl != null) {
          return call(function, params, overrideUrl);
        }
      }

      final data = json.decode(response.body);
      if (data is String && params.length == 1) {
        final param = params.first?.toString();
        if (param != null &&
            param.length > 42 &&
            RegExp(r'^(0x|0X)?[a-fA-F0-9]+$').hasMatch(param)) {
          final txHash =
              bytesToHex(keccak256(hexToBytes(param)), include0x: true);
          final txInfo = await Future.delayed(const Duration(milliseconds: 500))
              .then((_) =>
                  Web3Client(url, Client()).getTransactionByHash(txHash));
          if (txInfo != null) {
            throw Exception('Transaction not found');
          }
          return RPCResponse(_currentRequestId, txHash);
        }
      }

      if (data is! Map) {
        throw const RPCError(
            -32700, 'Invalid response data was received by the server', null);
      }

      if (data.containsKey('error')) {
        final error = data['error'];

        final code = error['code'];
        final message = error['message'] ?? error['details'];

        if (RpcInterceptor.instance.onRpcUrlError != null &&
            ((code == -32603 &&
                    message?.toLowerCase().contains('internal error') ==
                        true) ||
                code == -32005 &&
                    message?.toLowerCase().contains('limit exceeded') ==
                        true)) {
          final overrideUrl =
              await RpcInterceptor.instance.onRpcUrlError!.call(url);
          if (overrideUrl != null) {
            return call(function, params, overrideUrl);
          }
        }

        final errorData = error['data'];

        throw RPCError(code as int?, message as String?, errorData);
      }

      final id = data['id'] as int;
      final result = data['result'];
      return RPCResponse(id, result);
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      if (RpcInterceptor.instance.onRpcUrlError != null &&
          (e is HandshakeException || e is TimeoutException)) {
        final overrideUrl =
            await RpcInterceptor.instance.onRpcUrlError!.call(url);
        if (overrideUrl != null) {
          return call(function, params, overrideUrl);
        } else {
          rethrow;
        }
      } else {
        rethrow;
      }
    }
  }
}

/// Response from the server to an rpc request. Contains the id of the request
/// and the corresponding result as sent by the server.
class RPCResponse {
  final int id;
  final dynamic result;

  const RPCResponse(this.id, this.result);
}

/// Exception thrown when an the server returns an error code to an rpc request.
class RPCError implements Exception {
  final int? errorCode;
  final String? message;
  final dynamic data;

  const RPCError(this.errorCode, this.message, this.data);

  @override
  String toString() {
    if (errorCode != null && message != null) {
      return 'RPCError: got code $errorCode with msg \"$message\".';
    }
    return 'RPCError: unknown code and message';
  }
}

class RpcInterceptor {
  static final RpcInterceptor _instance = RpcInterceptor._internal();

  static RpcInterceptor get instance => _instance;

  RpcInterceptor._internal();

  OnRpcUrlError? onRpcUrlError;
}

typedef OnRpcUrlError = Future<String?> Function(String currentUrl);
