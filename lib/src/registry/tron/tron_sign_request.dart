import 'dart:convert';
import 'dart:typed_data';
import 'package:cbor/cbor.dart';
import 'package:gs_ur_dart/src/registry/crypto_key_path.dart';
import 'package:gs_ur_dart/src/registry/data_item.dart';
import 'package:gs_ur_dart/src/registry/registry_item.dart';
import 'package:gs_ur_dart/src/registry/registry_type.dart';
import 'package:gs_ur_dart/src/utils/format.dart';
import 'package:gs_ur_dart/src/utils/uuid.dart';


enum TronSignRequestKeys {
  zero,
  uuid,
  signData,
  derivationPath,
  fee,
  origin,
}

class TronSignRequest extends RegistryItem {
  Uint8List? uuid;
  final Uint8List signData;
  final String? origin;
  final int? fee;
  final CryptoKeypath derivationPath;

  TronSignRequest({
     this.uuid,
    required this.signData,
    this.fee,
    required this.derivationPath,
    this.origin,
  });

  @override
  RegistryType getRegistryType() {
    return ExtendedRegistryType.TRON_SIGN_REQUEST;
  }

  Uint8List getRequestId() => uuid ??= generateUuid();
  Uint8List getSignData() => signData;
  String? getOrigin() => origin;
  int? getFee() => fee;
  String? getDerivationPath() => derivationPath.getPath();
  Uint8List? getSourceFingerprint() => derivationPath.sourceFingerprint;

  @override
  CborValue toCborValue() {
    final Map map = {};
    map[TronSignRequestKeys.uuid.index] = CborBytes(getRequestId(), tags: [RegistryType.UUID.tag]);
    map[TronSignRequestKeys.signData.index] =  CborBytes(signData);
    CborValue keyPath = derivationPath.toCborValue();
    keyPath = cborValueSetTags(keyPath, [derivationPath.getRegistryType().tag]);
    map[TronSignRequestKeys.derivationPath.index] = keyPath;
    map[TronSignRequestKeys.fee.index] = fee;
    if (origin != null) {
      map[TronSignRequestKeys.origin.index] = origin;
    }
    return CborValue(map);
  }

  static TronSignRequest fromDataItem(dynamic jsonData) {
    final map = jsonData is String ? jsonDecode(jsonData) : jsonData is Map? jsonData : null;
    if(map == null){
      throw "Param for fromDataItem is neither String nor Map, please check it!";
    }
    final signData = map[TronSignRequestKeys.signData.index.toString()];
    final uuid = map[TronSignRequestKeys.uuid.index.toString()]?.bytes;
    final fee = map[TronSignRequestKeys.fee.index.toString()];
    final origin = map[TronSignRequestKeys.origin.index.toString()];
    final derivationPath = CryptoKeypath.fromDataItem(map[TronSignRequestKeys.derivationPath.index.toString()]);

    return TronSignRequest(
      uuid: uuid != null ? fromHex(uuid) : null , 
      signData: fromHex(signData),
      derivationPath: derivationPath,
      fee: fee,
      origin: origin,
    );
  }

  static TronSignRequest fromCBOR(Uint8List cborPayload) {
    CborValue cborValue = cbor.decode(cborPayload);
    String jsonData = const CborJsonEncoder().convert(cborValue);
    return fromDataItem(jsonData);
  }
}