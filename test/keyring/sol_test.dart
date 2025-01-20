import 'package:flutter_test/flutter_test.dart';
import 'package:gs_ur_dart/gs_ur_dart.dart';
import 'package:gs_ur_dart/src/utils/format.dart';

void main() {
  group('sol', () {
    test('sol generateSignRequest', () {
      UR ur = GsWalletSolSDK.generateSignRequest(
          uuid: "65781260-8d2c-11ef-806b-cf7f7ddae54a",
          signData:
              "01000203d9aa0cde2dd59caa4e04fe703439abba02d81391adb78dd1e67130e93684951200000000000000000000000000000000000000000000000000000000000000000306466fe5211732ffecadba72c39be7bc8ce5bbc5f7126b2c439b3a40000000d88b1bb92a7e915051f7287e53d1c6a2bd97a7a6c169a6ee00a912f793936e0c03010200000c02000000158d0b020000000002000502400d030002000903801a060000000000",
          signType: SignType.transaction,
          path: "m/44'/501'/0'/0'",
          xfp: "27c3831f",
          outputAddress: null,
          contractAddress: null,
          origin: null,
          fee: 100000);
      expect(toHex(ur.cbor),
          "a501d82550657812608d2c11ef806bcf7f7ddae54a0258aa01000203d9aa0cde2dd59caa4e04fe703439abba02d81391adb78dd1e67130e93684951200000000000000000000000000000000000000000000000000000000000000000306466fe5211732ffecadba72c39be7bc8ce5bbc5f7126b2c439b3a40000000d88b1bb92a7e915051f7287e53d1c6a2bd97a7a6c169a6ee00a912f793936e0c03010200000c02000000158d0b020000000002000502400d030002000903801a06000000000003d99d70a20188182cf51901f5f500f500f5021a1f83c3270601081a000186a0");
    });
    test('sol parseSignature', () {
      const cbor =
          "a301d82550657812608d2c11ef806bcf7f7ddae54a0258401cd95cbd3df72efe043ff50da43f03e6fed76a133a62f1b897de9ecc0ecd50e5d9a35ebf0340eb4368ee681b2387db3c053d69e09927e642ef8aa70b3502320b0368475357414c4c4554";
      UR ur = UR(fromHex(cbor), "sol-signature");
      final solSigned = GsWalletSolSDK.parseSignature(ur);
      expect(solSigned, {
        "uuid": [101,120,18,96,141,44,17,239,128,107,207,127,125,218,229,74],
        "signature":
            "1cd95cbd3df72efe043ff50da43f03e6fed76a133a62f1b897de9ecc0ecd50e5d9a35ebf0340eb4368ee681b2387db3c053d69e09927e642ef8aa70b3502320b",
        "origin": "GSWALLET"
      });
    });
  });
}
