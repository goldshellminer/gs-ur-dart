import 'dart:convert';
import 'dart:typed_data';

import 'package:cbor/cbor.dart';
import 'package:gs_ur_dart/src/registry/registry_item.dart';
import 'package:gs_ur_dart/src/registry/registry_type.dart';


enum BtcInscribeSignatureKeys {
  zero,
  uuid,
  commitSignature,
  revealSignature,
  origin,
}

class BtcInscribeSignature extends RegistryItem {
  final Uint8List uuid;
  final String? origin;
  final Uint8List commitSignature;
  final Uint8List revealSignature;

  BtcInscribeSignature({
    required this.commitSignature,
    required this.revealSignature,
    required this.uuid,
    this.origin,
  });

  @override
  RegistryType getRegistryType() {
    return ExtendedRegistryType.BTC_INSCRIBE_SIGNATURE;
  }

  Uint8List getRequestId() => uuid;
  Uint8List getCommitSignature() => commitSignature;
  Uint8List getRevealSignature() => revealSignature;
  String? getOrigin() => origin;

  @override
  CborValue toCborValue() {
    final Map map = {};
    map[BtcInscribeSignatureKeys.uuid.index] = CborBytes(uuid, tags: [RegistryType.UUID.tag]);
    if (origin != null) {
      map[BtcInscribeSignatureKeys.origin.index] = origin;
    }
    map[BtcInscribeSignatureKeys.commitSignature.index] = CborBytes(commitSignature, tags: [RegistryType.CRYPTO_PSBT.tag]);
    map[BtcInscribeSignatureKeys.revealSignature.index] = CborBytes(revealSignature, tags: [RegistryType.CRYPTO_PSBT.tag]);
    return CborValue(map);
  }

  static BtcInscribeSignature fromDataItem(dynamic jsonData) {
    final map = jsonData is String ? jsonDecode(jsonData) : jsonData is Map? jsonData : null;
    if(map == null){
      throw "Param for fromDataItem is neither String nor Map, please check it!";
    }
    final commitSignature = map[BtcInscribeSignatureKeys.commitSignature.index.toString()];
    final revealSignature = map[BtcInscribeSignatureKeys.revealSignature.index.toString()];
    final uuid = map[BtcInscribeSignatureKeys.uuid.index.toString()]?.bytes;
    final origin = map[BtcInscribeSignatureKeys.origin.index.toString()];

    return BtcInscribeSignature(
      commitSignature: commitSignature,
      revealSignature: revealSignature,
      uuid: uuid,
      origin: origin,
    );
  }

  static BtcInscribeSignature fromCBOR(Uint8List cborPayload) {
    CborValue cborValue = cbor.decode(cborPayload);
    String jsonData = const CborJsonEncoder().convert(cborValue);
    return fromDataItem(jsonData);
  }
}
