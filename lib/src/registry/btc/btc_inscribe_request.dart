import 'dart:convert';
import 'dart:typed_data';
import 'package:cbor/cbor.dart';
import 'package:gs_ur_dart/src/registry/registry_item.dart';
import 'package:gs_ur_dart/src/registry/registry_type.dart';
import 'package:gs_ur_dart/src/utils/format.dart';
import 'package:gs_ur_dart/src/utils/uuid.dart';


enum BtcInscribeRequestKeys {
  zero,
  uuid,
  commitData,
  revealData,
  origin,
}

class BtcInscribeRequest extends RegistryItem {
  Uint8List? uuid;
  final Uint8List commitData;
  final Uint8List revealData;
  final String? origin;

  BtcInscribeRequest({
    this.uuid,
    required this.commitData,
    required this.revealData,
    this.origin,
  });

  @override
  RegistryType getRegistryType() {
    return ExtendedRegistryType.BTC_INSCRIBE_REQUEST;
  }

  Uint8List getRequestId() => uuid ??= generateUuid();
  Uint8List getCommitData() => commitData;
  Uint8List getRevealData() => revealData;
  String? getOrigin() => origin;

  @override
  CborValue toCborValue() {
    final Map map = {};
    if (uuid != null) {
      map[BtcInscribeRequestKeys.uuid.index] = CborBytes(getRequestId(), tags: [RegistryType.UUID.tag]);
    }
    map[BtcInscribeRequestKeys.commitData.index] =  CborBytes(commitData, tags: [RegistryType.CRYPTO_PSBT.tag]);
    map[BtcInscribeRequestKeys.revealData.index] =  CborBytes(revealData, tags: [RegistryType.CRYPTO_PSBT.tag]);
    if (origin != null) {
      map[BtcInscribeRequestKeys.origin.index] = origin;
    }
    return CborValue(map);
  }

  static BtcInscribeRequest fromDataItem(dynamic jsonData) {
    final map = jsonData is String ? jsonDecode(jsonData) : jsonData is Map? jsonData : null;
    if(map == null){
      throw "Param for fromDataItem is neither String nor Map, please check it!";
    }
    final commitData = map[BtcInscribeRequestKeys.commitData.index.toString()];
    final revealData = map[BtcInscribeRequestKeys.revealData.index.toString()];
    final uuid = map[BtcInscribeRequestKeys.uuid.index.toString()]?.bytes;
    final origin = map[BtcInscribeRequestKeys.origin.index.toString()];

    return BtcInscribeRequest(
      uuid: uuid != null ? fromHex(uuid) : null , 
      commitData: fromHex(commitData),
      revealData: fromHex(revealData),
      origin: origin,
    );
  }

  static BtcInscribeRequest fromCBOR(Uint8List cborPayload) {
    CborValue cborValue = cbor.decode(cborPayload);
    String jsonData = const CborJsonEncoder().convert(cborValue);
    return fromDataItem(jsonData);
  }
}