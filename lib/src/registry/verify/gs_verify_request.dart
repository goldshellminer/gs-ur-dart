// import 'dart:convert';
// import 'dart:typed_data';
// import 'package:cbor/cbor.dart';
// import 'package:gs_ur_dart/src/registry/registry_item.dart';
// import 'package:gs_ur_dart/src/registry/registry_type.dart';

// enum GsVerifyRequestKeys {
//   zero,
//   puzzle,
// }

// class GsVerifyRequest extends RegistryItem {
//   final String puzzle;

//   GsVerifyRequest({
//     required this.puzzle,
//   });

//   @override
//   RegistryType getRegistryType() {
//     return ExtendedRegistryType.GS_VERIFY_REQUEST;
//   }

//   String getPuzzle() => puzzle;

//   @override
//   CborValue toCborValue() {
//     final Map map = {};
//     map[GsVerifyRequestKeys.puzzle.index] =  puzzle;
//     return CborValue(map);
//   }

//   static GsVerifyRequest fromDataItem(dynamic jsonData) {
//     final map = jsonData is String ? jsonDecode(jsonData) : jsonData is Map? jsonData : null;
//     if(map == null){
//       throw "Param for fromDataItem is neither String nor Map, please check it!";
//     }
//     final puzzle = map[GsVerifyRequestKeys.puzzle.index.toString()];
//     return GsVerifyRequest(
//       puzzle: puzzle,
//     );
//   }

//   static GsVerifyRequest fromCBOR(Uint8List cborPayload) {
//     CborValue cborValue = cbor.decode(cborPayload);
//     String jsonData = const CborJsonEncoder().convert(cborValue);
//     return fromDataItem(jsonData);
//   }
// }