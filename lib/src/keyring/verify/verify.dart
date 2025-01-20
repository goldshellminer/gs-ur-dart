// import 'package:gs_ur_dart/src/bc_ur/bc_ur_dart.dart';
// import 'package:gs_ur_dart/src/registry/registry_type.dart';
// import 'package:gs_ur_dart/src/registry/verify/gs_verify_request.dart';
// import 'package:gs_ur_dart/src/registry/verify/gs_verify_response.dart';

// class GsWalletVerifySDK{
//   static Map<String, dynamic> parseVerifyResponse(UR ur) {
//     if (ur.type != ExtendedRegistryType.GS_VERIFY_RESPONSE.type) {
//       throw ArgumentError('type not match');
//     }
//     final verifyResponse = GsVerifyResponse.fromCBOR(ur.cbor);
//     return {
//       'deviceid': verifyResponse.getDeviceid(),
//       'validation': verifyResponse.getValidation(),
//       'origin': verifyResponse.getOrigin(),
//     };
//   }

//   static UR generateVerifyRequest({
//     required String puzzle,
//   }) {
//     return GsVerifyRequest(
//       puzzle: puzzle
//       ).toUR();
//   }
// }