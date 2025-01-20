import 'package:flutter_test/flutter_test.dart';
import 'package:gs_ur_dart/gs_ur_dart.dart';
import 'package:gs_ur_dart/src/utils/format.dart';

void main() {
  group('tron', () {
    test('tron generateSignRequest', () {
      UR ur = GsWalletTronSDK.generateSignRequest(
          uuid: "cf6645a0-8d24-11ef-90ac-6dae386eaee6",
          signData:
              "0a02c5fc2208a02f893e39e02b5840e8c38692ec315a68080112640a2d747970652e676f6f676c65617069732e636f6d2f70726f746f636f6c2e5472616e73666572436f6e747261637412330a1541ac28610814b8b72e308dbb822c388400ad4aa2ef12154128ff40a1e26781937ba6f700a20daa74e6ef548e1880dac40970b5888392ec31",
          path: "m/44'/195'/0'/0/0",
          xfp: "27c3831f",
          origin: null,
          fee: 0);
      expect(toHex(ur.cbor),
          "a401d82550cf6645a08d2411ef90ac6dae386eaee60258860a02c5fc2208a02f893e39e02b5840e8c38692ec315a68080112640a2d747970652e676f6f676c65617069732e636f6d2f70726f746f636f6c2e5472616e73666572436f6e747261637412330a1541ac28610814b8b72e308dbb822c388400ad4aa2ef12154128ff40a1e26781937ba6f700a20daa74e6ef548e1880dac40970b5888392ec3103d99d70a2018a182cf518c3f500f500f400f4021a1f83c3270400");
    });
    test('tron parseSignature', () {
      const cbor =
          "a301d82550cf6645a08d2411ef90ac6dae386eaee6025841e07b32499c85a312fd86a8c0f775a0bce723a14336f71e8f6596a28a15bbf79801338e57f3fb18ca75db58977682062c29853b390966baf9303680edf548e01f010368475357414c4c4554";
      UR ur = UR(fromHex(cbor), "tron-signature");
      final tronSigned = GsWalletTronSDK.parseSignature(ur);
      expect(tronSigned, {
        "uuid": [207,102,69,160,141,36,17,239,144,172,109,174,56,110,174,230],
        "signature":
            "e07b32499c85a312fd86a8c0f775a0bce723a14336f71e8f6596a28a15bbf79801338e57f3fb18ca75db58977682062c29853b390966baf9303680edf548e01f01",
        "origin": "GSWALLET"
      });
    });
  });
}
