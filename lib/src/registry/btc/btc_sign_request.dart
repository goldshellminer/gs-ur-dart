import 'dart:convert';
import 'dart:typed_data';
import 'package:cbor/cbor.dart';
import 'package:gs_ur_dart/src/registry/crypto_gspl.dart';
import 'package:gs_ur_dart/src/registry/crypto_key_path.dart';
import 'package:gs_ur_dart/src/registry/data_item.dart';
import 'package:gs_ur_dart/src/registry/registry_item.dart';
import 'package:gs_ur_dart/src/registry/registry_type.dart';
import 'package:gs_ur_dart/src/utils/format.dart';
import 'package:gs_ur_dart/src/utils/uuid.dart';

enum BtcSignRequestKeys {
  zero,
  uuid,
  gspl,
  derivationPath,
  origin,
}

class BtcSignRequest extends RegistryItem {
  Uint8List? uuid;
  final CryptoGspl gspl;
  final CryptoKeypath? derivationPath;
  final String? origin;

  BtcSignRequest({
    this.uuid,
    required this.gspl,
    this.derivationPath,
    this.origin,
  });

  @override
  RegistryType getRegistryType() {
    return ExtendedRegistryType.BTC_SIGN_REQUEST;
  }

  Uint8List getRequestId() => uuid ??= generateUuid();
  CryptoGspl getSignData() => gspl;
  CryptoKeypath? getPath() => derivationPath;
  String? getOrigin() => origin;

  @override
  CborValue toCborValue() {
    final Map map = {};
    map[BtcSignRequestKeys.uuid.index] = CborBytes(getRequestId(), tags: [RegistryType.UUID.tag]);
    CborValue gsplDataItem = gspl.toCborValue();
    map[BtcSignRequestKeys.gspl.index] =  cborValueSetTags(gsplDataItem, [gspl.getRegistryType().tag]);
    if (derivationPath != null) {
      CborValue derivationPathDataItem = derivationPath!.toCborValue();
      derivationPathDataItem = cborValueSetTags(derivationPathDataItem, [derivationPath!.getRegistryType().tag]);
      map[BtcSignRequestKeys.derivationPath.index] = derivationPathDataItem;
    }
    if (origin != null) {
      map[BtcSignRequestKeys.origin.index] = origin;
    }
    return CborValue(map);
  }

  static BtcSignRequest fromDataItem(dynamic jsonData) {
    final map = jsonData is String ? jsonDecode(jsonData) : jsonData is Map? jsonData : null;
    if(map == null){
      throw "Param for fromDataItem is neither String nor Map, please check it!";
    }
    final gspl = map[BtcSignRequestKeys.gspl.index.toString()] != null ? CryptoGspl.fromDataItem(map[BtcSignRequestKeys.gspl.index.toString()]) : CryptoGspl(data: Uint8List(0), dataType: GsplDataType.message);
    final uuid = map[BtcSignRequestKeys.uuid.index.toString()];
    final derivationPath = map[BtcSignRequestKeys.derivationPath.index.toString()] != null ? CryptoKeypath.fromDataItem(map[BtcSignRequestKeys.derivationPath.index.toString()]) : null;
    final origin = map[BtcSignRequestKeys.origin.index.toString()];

    return BtcSignRequest(
      uuid: fromHex(uuid), 
      gspl: gspl,
      derivationPath: derivationPath,
      origin: origin,
    );
  }

  static BtcSignRequest fromCBOR(Uint8List cborPayload) {
    CborValue cborValue = cbor.decode(cborPayload);
    String jsonData = const CborJsonEncoder().convert(cborValue);
    return fromDataItem(jsonData);
  }
}