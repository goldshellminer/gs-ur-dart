import 'dart:convert';
import 'dart:typed_data';
import 'package:cbor/cbor.dart';
import 'package:gs_ur_dart/src/registry/registry_item.dart';
import 'package:gs_ur_dart/src/registry/registry_type.dart';
import 'package:gs_ur_dart/src/utils/format.dart';


enum PsbtSignatureKeys {
  zero,
  uuid,
  signature,
  origin,
}

class PsbtSignature extends RegistryItem {
  final Uint8List uuid;
  final String? origin;
  final Uint8List signature;

  PsbtSignature({
    required this.signature,
    required this.uuid,
    this.origin,
  });

  @override
  RegistryType getRegistryType() {
    return ExtendedRegistryType.PSBT_SIGNATURE;
  }

  Uint8List getRequestId() => uuid;
  Uint8List getSignature() => signature;
  String? getOrigin() => origin;

  @override
  CborValue toCborValue() {
    final Map map = {};
    map[PsbtSignatureKeys.uuid.index] = CborBytes(uuid, tags: [RegistryType.UUID.tag]);
    if (origin != null) {
      map[PsbtSignatureKeys.origin.index] = origin;
    }
    map[PsbtSignatureKeys.signature.index] = CborBytes(signature, tags: [RegistryType.CRYPTO_PSBT.tag]);
    return CborValue(map);
  }

  static PsbtSignature fromDataItem(dynamic jsonData) {
    final map = jsonData is String ? jsonDecode(jsonData) : jsonData is Map? jsonData : null;
    if(map == null){
      throw "Param for fromDataItem is neither String nor Map, please check it!";
    }
    final signature = map[PsbtSignatureKeys.signature.index.toString()];
    final uuid = map[PsbtSignatureKeys.uuid.index.toString()];
    final origin = map[PsbtSignatureKeys.origin.index.toString()];

    return PsbtSignature(
      signature: fromHex(signature),
      uuid: fromHex(uuid), 
      origin: origin,
    );
  }

  static PsbtSignature fromCBOR(Uint8List cborPayload) {
    CborValue cborValue = cbor.decode(cborPayload);
    String jsonData = const CborJsonEncoder().convert(cborValue);
    return fromDataItem(jsonData);
  }
}
