import 'dart:typed_data';
import 'package:cbor/cbor.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gs_ur_dart/gs_ur_dart.dart';
import 'package:gs_ur_dart/src/registry/crypto_coin_info.dart';
import 'package:gs_ur_dart/src/registry/crypto_key_path.dart';
import 'package:gs_ur_dart/src/registry/data_item.dart';


void main() {
  group('CoinInfo', () {
    test('CoinInfo encode', () {
      // CryptoCoinInfo cryptoCoinInfo = CryptoCoinInfo(0, Network.mainnet);
      // expect(cryptoCoinInfo.toCBOR(), [162, 1, 0, 2, 1]);
      UR ur = UR.from({1: 0, 2:1});
      expect(ur.cbor, [133, 24, 162, 1, 0, 2, 1]); // [162, 1, 0, 2, 1]);
    });
    test('CoinInfo decode', () {
      // expect(CryptoCoinInfo.fromCBOR(Uint8List.fromList( [162, 1, 0, 2, 1])).type, 0);
      UR ur = UR.from({1: 0, 2:1});

      expect(ur.decodeCBOR(), '{"1":0,"2":1}');
      expect(UR.from('{"1":0,"2":1}').decodeCBOR(), '{"1":0,"2":1}');
      expect(UR(Uint8List.fromList( [162, 1, 0, 2, 1])).cbor, [162, 1, 0, 2, 1]);
      expect(CryptoCoinInfo.fromCBOR(Uint8List.fromList( [162, 1, 0, 2, 1])).network, Network.mainnet);
    });
    test('CryptoKeypath, cborValueSetTags',(){
      CryptoKeypath cryptoKeyPath = CryptoKeypath(
      components: [PathComponent(index: 12, hardened: true), PathComponent(index: 12, hardened: true)],
      sourceFingerprint: Uint8List.fromList([12,34,56,78]),
      depth: 0,
    );
    CborValue  aa = cryptoKeyPath.toCborValue();
    CborValue bb = cborValueSetTags(aa, [24]);
    // ignore: avoid_print
    print("bb: $bb, tag: ${bb.tags}");
    });
  });
}
