import 'dart:convert';

import 'package:http/http.dart';
import 'package:test/test.dart';
import 'package:web3dart_avacus/crypto.dart';
import 'package:web3dart_avacus/src/utils/rlp.dart' as rlp;
import 'package:web3dart_avacus/src/utils/typed_data.dart';
import 'package:web3dart_avacus/web3dart_avacus.dart';

const rawJson = '''[
    {
       "nonce":819,
       "value":43203529,
       "gasLimit":35552,
       "maxPriorityFeePerGas":75853,
       "maxFeePerGas":121212,
       "to":"0x000000000000000000000000000000000000aaaa",
       "privateKey":"0x8f2a55949038a9610f50fb23b5883af3b4ecb3c3bb792cbcefbd1542c692be63",
       "signedTransactionRLP":"0xb87102f86e048203338301284d8301d97c828ae094000000000000000000000000000000000000aaaa8402933bc980c080a00f924cb68412c8f1cfd74d9b581c71eeaf94fff6abdde3e5b02ca6b2931dcf47a07dd1c50027c3e31f8b565e25ce68a5072110f61fce5eee81b195dd51273c2f83"
    },
    {
       "nonce":353,
       "value":61901619,
       "gasLimit":32593,
       "maxPriorityFeePerGas":38850,
       "maxFeePerGas":136295,
       "to":"0x000000000000000000000000000000000000aaaa",
       "privateKey":"0x8f2a55949038a9610f50fb23b5883af3b4ecb3c3bb792cbcefbd1542c692be63",
       "signedTransactionRLP":"0xb87002f86d048201618297c283021467827f5194000000000000000000000000000000000000aaaa8403b08b3380c080a08caf712f72489da6f1a634b651b4b1c7d9be7d1e8d05ea76c1eccee3bdfb86a5a06aecc106f588ce51e112f5e9ea7aba3e089dc7511718821d0e0cd52f52af4e45"
    },
    {
       "nonce":985,
       "value":32531825,
       "gasLimit":68541,
       "maxPriorityFeePerGas":66377,
       "maxFeePerGas":136097,
       "to":"0x000000000000000000000000000000000000aaaa",
       "privateKey":"0x8f2a55949038a9610f50fb23b5883af3b4ecb3c3bb792cbcefbd1542c692be63",
       "signedTransactionRLP":"0xb87202f86f048203d983010349830213a183010bbd94000000000000000000000000000000000000aaaa8401f0657180c001a08c03a86e85789ee9a1b42fa0a86d316fca262694f8c198df11f194678c2c2d35a028f8e7de02b35014a17b6d28ff8c7e7be6860e7265ac162fb721f1aeae75643c"
    },
    {
       "nonce":623,
       "value":21649799,
       "gasLimit":57725,
       "maxPriorityFeePerGas":74140,
       "maxFeePerGas":81173,
       "to":"0x000000000000000000000000000000000000aaaa",
       "privateKey":"0x8f2a55949038a9610f50fb23b5883af3b4ecb3c3bb792cbcefbd1542c692be63",
       "signedTransactionRLP":"0xb87102f86e0482026f8301219c83013d1582e17d94000000000000000000000000000000000000aaaa84014a598780c001a0b87c4c8c505d2d692ac77ba466547e79dd60fe7ecd303d520bf6e8c7085e3182a06dc7d00f5e68c3f3ebe8ae35a90d46051afde620ac12e43cae9560a29b13e7fb"
    },
    {
       "nonce":972,
       "value":94563383,
       "gasLimit":65254,
       "maxPriorityFeePerGas":42798,
       "maxFeePerGas":103466,
       "to":"0x000000000000000000000000000000000000aaaa",
       "privateKey":"0x8f2a55949038a9610f50fb23b5883af3b4ecb3c3bb792cbcefbd1542c692be63",
       "signedTransactionRLP":"0xb87002f86d048203cc82a72e8301942a82fee694000000000000000000000000000000000000aaaa8405a2ec3780c001a006cf07af78c187db104496c58d679f37fcd2d5790970cecf9a59fe4a5321b375a039f3faafc71479d283a5b1e66a86b19c4bdc516655d89dbe57d9747747c01dfe"
    },
    {
       "nonce":588,
       "value":99359647,
       "gasLimit":37274,
       "maxPriorityFeePerGas":87890,
       "maxFeePerGas":130273,
       "to":"0x000000000000000000000000000000000000aaaa",
       "privateKey":"0x8f2a55949038a9610f50fb23b5883af3b4ecb3c3bb792cbcefbd1542c692be63",
       "signedTransactionRLP":"0xb87102f86e0482024c830157528301fce182919a94000000000000000000000000000000000000aaaa8405ec1b9f80c080a03e2f59ac9ca852034c2c1da35a742ca19fdd910aa5d2ed49ab8ad27a2fcb2b10a03ac1c29c26723c58f91400fb6dfb5f5b837467b1c377541b47dae474dddbe469"
    },
    {
       "nonce":900,
       "value":30402257,
       "gasLimit":76053,
       "maxPriorityFeePerGas":8714,
       "maxFeePerGas":112705,
       "to":"0x000000000000000000000000000000000000aaaa",
       "privateKey":"0x8f2a55949038a9610f50fb23b5883af3b4ecb3c3bb792cbcefbd1542c692be63",
       "signedTransactionRLP":"0xb87102f86e0482038482220a8301b8418301291594000000000000000000000000000000000000aaaa8401cfe6d180c001a0f7ffc5bca2512860f8236360159bf303dcfab71546b6a0032df0306f3739d0c4a05d38fe2c4edebdc1edc157034f780c53a0e5ae089e57220745bd48bcb10cdf87"
    },
    {
       "nonce":709,
       "value":6478043,
       "gasLimit":28335,
       "maxPriorityFeePerGas":86252,
       "maxFeePerGas":94636,
       "to":"0x000000000000000000000000000000000000aaaa",
       "privateKey":"0x8f2a55949038a9610f50fb23b5883af3b4ecb3c3bb792cbcefbd1542c692be63",
       "signedTransactionRLP":"0xb87002f86d048202c5830150ec830171ac826eaf94000000000000000000000000000000000000aaaa8362d8db80c001a0a61a5710512f346c9996377f7b564ccb64c73a5fdb615499adb1250498f3e01aa002d10429572cecfaa911a58bbe05f2b26e4c3aee3402202153a93692849add11"
    },
    {
       "nonce":939,
       "value":2782905,
       "gasLimit":45047,
       "maxPriorityFeePerGas":45216,
       "maxFeePerGas":91648,
       "to":"0x000000000000000000000000000000000000aaaa",
       "privateKey":"0x8f2a55949038a9610f50fb23b5883af3b4ecb3c3bb792cbcefbd1542c692be63",
       "signedTransactionRLP":"0xb86f02f86c048203ab82b0a08301660082aff794000000000000000000000000000000000000aaaa832a76b980c001a0191f0f6667a20cefc0b454e344cc01108aafbdc4e4e5ed88fdd1b5d108495b31a020879042b0f8d3807609f18fe42a9820de53c8a0ea1d0a2d50f8f5e92a94f00d"
    },
    {
       "nonce":119,
       "value":65456115,
       "gasLimit":62341,
       "maxPriorityFeePerGas":24721,
       "maxFeePerGas":107729,
       "to":"0x000000000000000000000000000000000000aaaa",
       "privateKey":"0x8f2a55949038a9610f50fb23b5883af3b4ecb3c3bb792cbcefbd1542c692be63",
       "signedTransactionRLP":"0xb86e02f86b04778260918301a4d182f38594000000000000000000000000000000000000aaaa8403e6c7f380c001a05e40977f4064a2bc08785e422ed8a47b56aa219abe93251d2b3b4d0cf937b8c0a071e600cd15589c3607bd9627314b99e9b5976bd427b774aa685bd0d036b1771e"
    }
 ]''';

void main() {
  test('sign eip 1559 transaction', () async {
    final data = jsonDecode(rawJson) as List<dynamic>;

    await Future.forEach(data, (element) async {
      final tx = element as Map<String, dynamic>;
      final credentials =
          EthPrivateKey.fromHex(strip0x(tx['privateKey'] as String));
      final transaction = Transaction(
          from: await credentials.extractAddress(),
          to: EthereumAddress.fromHex(tx['to'] as String),
          nonce: tx['nonce'] as int,
          maxGas: tx['gasLimit'] as int,
          value: EtherAmount.inWei(BigInt.from(tx['value'] as int)),
          maxFeePerGas: EtherAmount.fromUnitAndValue(
              EtherUnit.wei, BigInt.from(tx['maxFeePerGas'] as int)),
          maxPriorityFeePerGas: EtherAmount.fromUnitAndValue(
              EtherUnit.wei, BigInt.from(tx['maxPriorityFeePerGas'] as int)));

      final client = Web3Client('', Client());
      final signature =
          await client.signTransaction(credentials, transaction, chainId: 4);

      expect(
          bytesToHex(uint8ListFromList(
              rlp.encode(prependTransactionType(0x02, signature)))),
          strip0x(tx['signedTransactionRLP'] as String));
    });
  });

  test('signs transactions', () async {
    final credentials = EthPrivateKey.fromHex(
        'a2fd51b96dc55aeb14b30d55a6b3121c7b9c599500c1beb92a389c3377adc86e');
    final transaction = Transaction(
      from: await credentials.extractAddress(),
      to: EthereumAddress.fromHex('0xC914Bb2ba888e3367bcecEb5C2d99DF7C7423706'),
      nonce: 0,
      gasPrice: EtherAmount.inWei(BigInt.one),
      maxGas: 10,
      value: EtherAmount.inWei(BigInt.from(10)),
    );

    final client = Web3Client('', Client());
    final signature = await client.signTransaction(credentials, transaction);

    expect(bytesToHex(signature),
        'f85d80010a94c914bb2ba888e3367bceceb5c2d99df7c74237060a8025a0a78c2f8b0f95c33636b2b1b91d3d23844fba2ec1b2168120ad64b84565b94bcda0365ecaff22197e3f21816cf9d428d695087ad3a8b7f93456cd48311d71402578');
  });

  // example from https://github.com/ethereum/EIPs/issues/155
  test('signs eip 155 transaction', () async {
    final credentials = EthPrivateKey.fromHex(
        '0x4646464646464646464646464646464646464646464646464646464646464646');

    final transaction = Transaction(
      nonce: 9,
      gasPrice: EtherAmount.inWei(BigInt.from(20000000000)),
      maxGas: 21000,
      to: EthereumAddress.fromHex('0x3535353535353535353535353535353535353535'),
      value: EtherAmount.inWei(BigInt.from(1000000000000000000)),
    );

    final client = Web3Client('', Client());
    final signature = await client.signTransaction(credentials, transaction);

    expect(
        bytesToHex(signature),
        'f86c098504a817c800825208943535353535353535353535353535353535353535880'
        'de0b6b3a76400008025a028ef61340bd939bc2195fe537567866003e1a15d'
        '3c71ff63e1590620aa636276a067cbe9d8997f761aecb703304b3800ccf55'
        '5c9f3dc64214b297fb1966a3b6d83');
  });
}
