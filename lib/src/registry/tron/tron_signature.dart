import 'dart:convert';
import 'dart:typed_data';

import 'package:cbor/cbor.dart';
import 'package:gs_ur_dart/src/registry/registry_item.dart';
import 'package:gs_ur_dart/src/registry/registry_type.dart';
import 'package:gs_ur_dart/src/utils/format.dart';
import 'package:gs_ur_dart/src/utils/uuid.dart';

enum TronSignatureKeys {
  zero,
  uuid,
  signature,
  origin,
}

class TronSignature extends RegistryItem {
  Uint8List uuid;
  final String? origin;
  final Uint8List signature;

  TronSignature({
    required this.signature,
    required this.uuid,
    this.origin,
  });

  @override
  RegistryType getRegistryType() {
    return ExtendedRegistryType.TRON_SIGNATURE;
  }

  Uint8List getRequestId() => uuid;
  Uint8List getSignature() => signature;
  String? getOrigin() => origin;

  @override
  CborValue toCborValue() {
    final Map map = {};
    map[TronSignatureKeys.uuid.index] = CborBytes(uuid, tags: [RegistryType.UUID.tag]);
    if (origin != null) {
      map[TronSignatureKeys.origin.index] = origin;
    }
    map[TronSignatureKeys.signature.index] = signature;
    return CborValue(map);
  }

  static TronSignature fromDataItem(dynamic jsonData) {
    final map = jsonData is String ? jsonDecode(jsonData) : jsonData is Map? jsonData : null;
    if(map == null){
      throw "Param for fromDataItem is neither String nor Map, please check it!";
    }
    final signature = map[TronSignatureKeys.signature.index.toString()];
    final uuid = map[TronSignatureKeys.uuid.index.toString()];
    final origin = map[TronSignatureKeys.origin.index.toString()];
    return TronSignature(
      signature: fromHex(signature),
      uuid: fromHex(uuid), 
      origin: origin,
    );
  }

  static TronSignature fromCBOR(Uint8List cborPayload) {
    CborValue cborValue = cbor.decode(cborPayload);
    String jsonData = const CborJsonEncoder().convert(cborValue);
    return fromDataItem(jsonData);
  }
}
