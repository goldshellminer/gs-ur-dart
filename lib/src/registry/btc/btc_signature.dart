import 'dart:convert';
import 'dart:typed_data';

import 'package:cbor/cbor.dart';
import 'package:gs_ur_dart/src/registry/crypto_gspl.dart';
import 'package:gs_ur_dart/src/registry/data_item.dart';
import 'package:gs_ur_dart/src/registry/registry_item.dart';
import 'package:gs_ur_dart/src/registry/registry_type.dart';
import 'package:gs_ur_dart/src/utils/format.dart';
import 'package:gs_ur_dart/src/utils/uuid.dart';


enum BtcSignatureKeys {
  zero,
  uuid,
  gspl,
  origin,
}

class BtcSignature extends RegistryItem {
  final Uint8List? uuid;
  final String? origin;
  final CryptoGspl gspl;

  BtcSignature({
    required this.gspl,
    this.uuid,
    this.origin,
  });

  @override
  RegistryType getRegistryType() {
    return ExtendedRegistryType.BTC_SIGNATURE;
  }

  Uint8List? getRequestId() => uuid;
  CryptoGspl getGspl() => gspl;
  String? getOrigin() => origin;

  @override
  CborValue toCborValue() {
    final Map map = {};
    if (uuid != null) {
      map[BtcSignatureKeys.uuid.index] = CborBytes(uuid!, tags: [RegistryType.UUID.tag]);
    }
    if (origin != null) {
      map[BtcSignatureKeys.origin.index] = origin;
    }
    CborValue gsplDataItem = gspl.toCborValue();
    map[BtcSignatureKeys.gspl.index] =  cborValueSetTags(gsplDataItem, [gspl.getRegistryType().tag]);
    return CborValue(map);
  }

  static BtcSignature fromDataItem(dynamic jsonData) {
    final map = jsonData is String ? jsonDecode(jsonData) : jsonData is Map? jsonData : null;
    if(map == null){
      throw "Param for fromDataItem is neither String nor Map, please check it!";
    }
    final gspl = map[BtcSignatureKeys.gspl.index.toString()] != null ? CryptoGspl.fromDataItem(map[BtcSignatureKeys.gspl.index.toString()]) : CryptoGspl(data: Uint8List(0), dataType: GsplDataType.message);
    final uuid = map[BtcSignatureKeys.uuid.index.toString()];
    final origin = map[BtcSignatureKeys.origin.index.toString()];
    return BtcSignature(
      gspl: gspl,
      uuid: uuid != null ? fromHex(uuid) : null , 
      origin: origin,
    );
  }

  static BtcSignature fromCBOR(Uint8List cborPayload) {
    CborValue cborValue = cbor.decode(cborPayload);
    String jsonData = const CborJsonEncoder().convert(cborValue);
    return fromDataItem(jsonData);
  }
}
