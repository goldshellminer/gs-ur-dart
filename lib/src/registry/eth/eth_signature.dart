import 'dart:convert';
import 'dart:typed_data';

import 'package:cbor/cbor.dart';
import 'package:gs_ur_dart/src/registry/registry_item.dart';
import 'package:gs_ur_dart/src/registry/registry_type.dart';
import 'package:gs_ur_dart/src/utils/format.dart';

enum EthSignatureKeys {
  zero,
  uuid,
  signature,
  origin,
}

class EthSignature extends RegistryItem {
  final Uint8List uuid;
  final String? origin;
  final Uint8List signature;

  EthSignature({
    required this.signature,
    required this.uuid,
    this.origin,
  });

  @override
  RegistryType getRegistryType() {
    return ExtendedRegistryType.ETH_SIGNATURE;
  }

  Uint8List getRequestId() => uuid;
  Uint8List getSignature() => signature;
  String? getOrigin() => origin;

  @override
  CborValue toCborValue() {
    final map = {};
    map[EthSignatureKeys.uuid.index] = CborBytes(uuid, tags: [RegistryType.UUID.tag]);
    if (origin != null) {
      map[EthSignatureKeys.origin.index] = origin;
    }
    map[EthSignatureKeys.signature.index] = signature;
    return CborValue(map);
  }

  static EthSignature fromDataItem(dynamic jsonData) {
    final map = jsonData is String ? jsonDecode(jsonData) : jsonData is Map? jsonData : null;
    if(map == null){
      throw "Param for fromDataItem is neither String nor Map, please check it!";
    }
    final signature = map[EthSignatureKeys.signature.index.toString()];
    final uuid = map[EthSignatureKeys.uuid.index.toString()];
    final origin = map[EthSignatureKeys.origin.index.toString()];

    return EthSignature(
      signature: fromHex(signature),
      uuid: fromHex(uuid),  // Uint8List.fromList(uuidParse(uuid)),
      origin: origin,
    );
  }

  static EthSignature fromCBOR(Uint8List cborPayload) {
    CborValue cborValue = cbor.decode(cborPayload);
    String jsonData = const CborJsonEncoder().convert(cborValue);
    return fromDataItem(jsonData);
  }
}
