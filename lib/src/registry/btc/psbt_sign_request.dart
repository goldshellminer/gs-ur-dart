import 'dart:convert';
import 'dart:typed_data';
import 'package:cbor/cbor.dart';
import 'package:gs_ur_dart/src/registry/crypto_key_path.dart';
import 'package:gs_ur_dart/src/registry/data_item.dart';
import 'package:gs_ur_dart/src/registry/registry_item.dart';
import 'package:gs_ur_dart/src/registry/registry_type.dart';
import 'package:gs_ur_dart/src/utils/format.dart';
import 'package:gs_ur_dart/src/utils/uuid.dart';


enum PsbtSignRequestKeys {
  zero,
  uuid,
  psbt,
  derivationPath,
  origin,
}

class PsbtSignRequest extends RegistryItem {
  Uint8List? uuid;
  final Uint8List psbt;
  final CryptoKeypath? derivationPath;
  final String? origin;

  PsbtSignRequest({
    this.uuid,
    required this.psbt,
    this.derivationPath,
    this.origin,
  });

  @override
  RegistryType getRegistryType() {
    return ExtendedRegistryType.PSBT_SIGN_REQUEST;
  }

  Uint8List getRequestId() => uuid ??= generateUuid();
  Uint8List getSignData() => psbt;
  CryptoKeypath? getPath() => derivationPath;
  String? getOrigin() => origin;

  @override
  CborValue toCborValue() {
    final Map map = {};
    map[PsbtSignRequestKeys.uuid.index] = CborBytes(getRequestId(), tags: [RegistryType.UUID.tag]);
    map[PsbtSignRequestKeys.psbt.index] =  CborBytes(psbt, tags: [RegistryType.CRYPTO_PSBT.tag]);
    // map[PsbtSignRequestKeys.psbt.index] =  psbt;
    if (derivationPath != null) {
      CborValue derivationPathDataItem = derivationPath!.toCborValue();
      derivationPathDataItem = cborValueSetTags(derivationPathDataItem, [derivationPath!.getRegistryType().tag]);
      map[PsbtSignRequestKeys.derivationPath.index] = derivationPathDataItem;
    }
    if (origin != null) {
      map[PsbtSignRequestKeys.origin.index] = origin;
    }
    return CborValue(map);
  }

  static PsbtSignRequest fromDataItem(dynamic jsonData) {
    final map = jsonData is String ? jsonDecode(jsonData) : jsonData is Map? jsonData : null;
    if(map == null){
      throw "Param for fromDataItem is neither String nor Map, please check it!";
    }
    final psbt = map[PsbtSignRequestKeys.psbt.index.toString()];
    final uuid = map[PsbtSignRequestKeys.uuid.index.toString()];
    final derivationPath = map[PsbtSignRequestKeys.derivationPath.index.toString()] != null ? CryptoKeypath.fromDataItem(map[PsbtSignRequestKeys.derivationPath.index.toString()]) : null;
    final origin = map[PsbtSignRequestKeys.origin.index.toString()];

    return PsbtSignRequest(
      uuid: uuid != null ? fromHex(uuid) : null , 
      psbt: fromHex(psbt),
      derivationPath: derivationPath,
      origin: origin,
    );
  }

  static PsbtSignRequest fromCBOR(Uint8List cborPayload) {
    CborValue cborValue = cbor.decode(cborPayload);
    String jsonData = const CborJsonEncoder().convert(cborValue);
    return fromDataItem(jsonData);
  }
}