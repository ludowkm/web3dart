import 'dart:typed_data';

import 'package:test/test.dart';

import 'package:web3dart_avacus/contracts.dart';
import 'package:web3dart_avacus/crypto.dart';
import 'package:web3dart_avacus/src/utils/length_tracking_byte_sink.dart';

void expectEncodes<T>(AbiType<T> type, T data, String encoded) {
  final buffer = LengthTrackingByteSink();
  type.encode(data, buffer);

  expect(bytesToHex(buffer.asBytes(), include0x: false), encoded);
}

ByteBuffer bufferFromHex(String hex) {
  return hexToBytes(hex).buffer;
}
