import 'package:flutter_test/flutter_test.dart';
import 'package:gs_ur_dart/gs_ur_dart.dart';
import 'package:gs_ur_dart/src/utils/format.dart';

void main() {
  group('ltc', () {
    test('LTC generateSignRequest', () {
      UR ur = GsWalletBTCSDK.generateSignRequest(
          uuid: "cf55cae0-8d24-11ef-90ac-6dae386eaee6", hexData: "0200000002c4d65606a1cb6e6d4c225af6c632d0155765c997789fbcdf91376295d924c4780100000000ffffffff538ee4444e981be55b49836f982813d771ff4cfc66cb0c587d3f8be1a7529ce40100000000ffffffff0109444304000000001976a914e274b8b609ea3d6ef60c90d84fb8f2e8445cdb5788ac00000000", 
          dataType: GsplDataType.transaction, 
          path: "m/44'/2'/0'/0/0", 
          inputs: [{"path": "m/44'/2'/0'/0/0", "amount": 63517873, "signature": null, "signhashType": 1}, 
          {"path": "m/44'/2'/0'/0/0", "amount": 8006507, "signature": null, "signhashType": 1}], 
          change: null, 
          xfp: '27c3831f', origin: null);
      expect(toHex(ur.cbor),
          "a301d82550cf55cae08d2411ef90ac6dae386eaee602d917dfa301587e0200000002c4d65606a1cb6e6d4c225af6c632d0155765c997789fbcdf91376295d924c4780100000000ffffffff538ee4444e981be55b49836f982813d771ff4cfc66cb0c587d3f8be1a7529ce40100000000ffffffff0109444304000000001976a914e274b8b609ea3d6ef60c90d84fb8f2e8445cdb5788ac0000000002010382d917dea3018a182cf502f500f500f400f4021a03c934b10401d917dea3018a182cf502f500f500f400f4021a007a2b6b040103d99d70a2018a182cf502f500f500f400f4021a1f83c327");
    });
    test('LTC parseSignature', () {
      const cbor =
          "a301d82550cf55cae08d2411ef90ac6dae386eaee602d917dfa301587e0200000002c4d65606a1cb6e6d4c225af6c632d0155765c997789fbcdf91376295d924c4780100000000ffffffff538ee4444e981be55b49836f982813d771ff4cfc66cb0c587d3f8be1a7529ce40100000000ffffffff0109444304000000001976a914e274b8b609ea3d6ef60c90d84fb8f2e8445cdb5788ac0000000002010382d917dea4018a182cf500f402f500f400f5021a03c934b10358483045022100ad748f4b69e8edfd079979a4401ddca80df2f5740b9413956166de1761ddf25f02201d8eba814d9f8ef0677e7796cfc83cf1a2bc9880c70fea047ce71905b77c045b010401d917dea4018a182cf500f402f500f400f5021a007a2b6b0358483045022100c2e08faeaa574bd68cbdccc41fb94821a27ef392e7d9213d396a053da5cc437102200276e2335021da7e6dbdfe5e352bcb24ee0b8cbd14f04aec6bfe4b49e08e96fa0104010368475357414c4c4554";
      UR ur = UR(fromHex(cbor), "btc-signature");
      final ltcSigned = GsWalletBTCSDK.parseSignature(ur);
      expect(ltcSigned, {
            'uuid': [207, 85, 202, 224, 141, 36, 17, 239, 144, 172, 109, 174, 56, 110, 174, 230],
            'gspl': CryptoGspl,
            'origin': 'GSWALLET'
          });
    });
  });
}
