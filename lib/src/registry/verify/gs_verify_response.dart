// import 'dart:convert';
// import 'dart:typed_data';
// import 'package:cbor/cbor.dart';
// import 'package:gs_ur_dart/src/registry/registry_item.dart';
// import 'package:gs_ur_dart/src/registry/registry_type.dart';

// enum GsVerifyResponseKeys {
//   zero,
//   deviceid,
//   validation,
//   origin,
// }

// class GsVerifyResponse extends RegistryItem {
//   final String deviceid;
//   final String validation;
//   final String? origin;

//   GsVerifyResponse({
//     required this.deviceid,
//     required this.validation,
//     this.origin,
//   });

//   @override
//   RegistryType getRegistryType() {
//     return ExtendedRegistryType.GS_VERIFY_RESPONSE;
//   }

//   String getDeviceid() => deviceid;
//   String getValidation() => validation;
//   String? getOrigin() => origin;
//   @override
//   CborValue toCborValue() {
//     final Map map = {};
//     map[GsVerifyResponseKeys.deviceid.index] = deviceid;
//     map[GsVerifyResponseKeys.validation.index] = validation;
//     if(origin != null) map[GsVerifyResponseKeys.origin.index] = origin;
//     return CborValue(map);
//   }

//   static GsVerifyResponse fromDataItem(dynamic jsonData) {
//     final map = jsonData is String ? jsonDecode(jsonData) : jsonData is Map? jsonData : null;
//     if(map == null){
//       throw "Param for fromDataItem is neither String nor Map, please check it!";
//     }
//     final deviceid = map[GsVerifyResponseKeys.deviceid.index.toString()];
//     final validation = map[GsVerifyResponseKeys.validation.index.toString()];
//     final origin = map[GsVerifyResponseKeys.origin.index.toString()];

//     return GsVerifyResponse(
//       deviceid: deviceid,
//       validation: validation,
//       origin: origin,
//     );
//   }

//   static GsVerifyResponse fromCBOR(Uint8List cborPayload) {
//     CborValue cborValue = cbor.decode(cborPayload);
//     String jsonData = const CborJsonEncoder().convert(cborValue);
//     return fromDataItem(jsonData);
//   }
// }
