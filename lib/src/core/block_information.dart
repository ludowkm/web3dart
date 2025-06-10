import 'package:web3dart_avacus/src/crypto/formatting.dart';
import 'package:web3dart_avacus/web3dart_avacus.dart';

class BlockInformation {
  final EtherAmount? baseFeePerGas;
  final DateTime timestamp;
  final BigInt? number;

  BlockInformation(
      {required this.baseFeePerGas, required this.timestamp, this.number});

  factory BlockInformation.fromJson(Map<String, dynamic> json) {
    return BlockInformation(
        baseFeePerGas: json.containsKey('baseFeePerGas')
            ? EtherAmount.fromUnitAndValue(
                EtherUnit.wei, hexToInt(json['baseFeePerGas'] as String))
            : null,
        timestamp: DateTime.fromMillisecondsSinceEpoch(
          hexToDartInt(json['timestamp'] as String) * 1000,
          isUtc: true,
        ),
        number: json['number'] != null && json['number'] is String
            ? BigInt.tryParse(json['number'] as String)
            : null);
  }

  bool get isSupportEIP1559 => baseFeePerGas != null;
}
