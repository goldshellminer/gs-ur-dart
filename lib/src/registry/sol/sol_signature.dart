import 'dart:convert';
import 'dart:typed_data';

import 'package:cbor/cbor.dart';
import 'package:gs_ur_dart/src/registry/gs_basic_chain/gs_signature.dart';
import 'package:gs_ur_dart/src/registry/registry_type.dart';
import 'package:gs_ur_dart/src/utils/format.dart';

class SolSignature extends GsSignature {

  SolSignature({
    required super.signature,
    required super.uuid,
    super.origin,
  });

  @override
  RegistryType getRegistryType() {
    return ExtendedRegistryType.SOL_SIGNATURE;
  }

  static GsSignature fromDataItem(dynamic jsonData) {
    final map = jsonData is String ? jsonDecode(jsonData) : jsonData is Map? jsonData : null;
    if(map == null){
      throw "Param for fromDataItem is neither String nor Map, please check it!";
    }
    final signature = map[GsSignatureKeys.signature.index.toString()];
    final uuid = map[GsSignatureKeys.uuid.index.toString()];
    final origin = map[GsSignatureKeys.origin.index.toString()];

    return GsSignature(
      signature: fromHex(signature),
      uuid: fromHex(uuid), 
      origin: origin,
    );
  }

  static GsSignature fromCBOR(Uint8List cborPayload) {
    CborValue cborValue = cbor.decode(cborPayload);
    String jsonData = const CborJsonEncoder().convert(cborValue);
    return fromDataItem(jsonData);
  }
}
