import 'package:flutter_test/flutter_test.dart';
import 'package:gs_ur_dart/gs_ur_dart.dart';
import 'package:gs_ur_dart/src/utils/format.dart';

void main() {
  group('ETH', () {
    test('ETH generateSignRequest', () {
    UR ur = GsWalletEthereumSDK.generateSignRequest(uuid: "6c3633c0-02c0-4313-9cd7-e25f4f296729",
        signData: "337B718878426CA568BA103A5048A8D920945CE651C0A5360A79DA7E872E672D46C224866FEAF80F3D948682CCF31B683C1ACC29FA7D9BF6527BF627F545692A00",
        dataType: EthDataType.typedTransaction,
        path: "m/44'/60'/0'/0/0",
        xfp: "F23F9FD2",
        chainId: 1,
        origin: "GsWallet");
      expect(toHex(ur.cbor), "a601d825506c3633c002c043139cd7e25f4f296729025841337b718878426ca568ba103a5048a8d920945ce651c0a5360a79da7e872e672d46c224866feaf80f3d948682ccf31b683c1acc29fa7d9bf6527bf627f545692a000304040105d99d70a2018a182cf5183cf500f500f400f4021ad29f3ff207684d6574614d61736b"); 
    });
    test('ETH parseSignature', () {
      const cbor = "a301d8255093f074508d1a11ef9718cfc8ba00addb025841ad8d6c6047bcde2533f532775723acdf476de661bbd1f873971a59f0e735cf520f3266ef4bc8e8627e4dbf62a424c15ccc3feed076e162b86142d8987cabd566000368475357414c4c4554";
      UR ur = UR(fromHex(cbor), "eth-signature");
      final ethSigned = GsWalletEthereumSDK.parseSignature(ur);
      expect(ethSigned, {"uuid":[147,240,116,80,141,26,17,239,151,24,207,200,186,0,173,219],"signature":"ad8d6c6047bcde2533f532775723acdf476de661bbd1f873971a59f0e735cf520f3266ef4bc8e8627e4dbf62a424c15ccc3feed076e162b86142d8987cabd56600","origin":"GSWALLET"}); 
    });
  });
}