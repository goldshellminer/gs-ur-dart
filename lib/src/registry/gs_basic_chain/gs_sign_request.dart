import 'dart:convert';
import 'dart:typed_data';
import 'package:cbor/cbor.dart';
import 'package:gs_ur_dart/src/registry/crypto_key_path.dart';
import 'package:gs_ur_dart/src/registry/data_item.dart';
import 'package:gs_ur_dart/src/registry/registry_item.dart';
import 'package:gs_ur_dart/src/registry/registry_type.dart';
import 'package:gs_ur_dart/src/utils/format.dart';
import 'package:gs_ur_dart/src/utils/uuid.dart';


enum GsSignRequestKeys {
  zero,
  uuid,
  signData,
  derivationPath,
  chain,
  origin,
}

class GsSignRequest extends RegistryItem {
  Uint8List? uuid;
  final Uint8List signData;
  final String? origin;
  final String chain;
  final CryptoKeypath derivationPath;

  GsSignRequest({
    this.uuid,
    required this.signData,
    required this.chain,
    required this.derivationPath,
    this.origin,
  });

  @override
  RegistryType getRegistryType() {
    return ExtendedRegistryType.GS_SIGN_REQUEST;
  }

  Uint8List getRequestId() => uuid ??= generateUuid();
  Uint8List getSignData() => signData;
  String? getOrigin() => origin;
  String getChain() => chain;
  String? getDerivationPath() => derivationPath.getPath();
  Uint8List? getSourceFingerprint() => derivationPath.sourceFingerprint;

  @override
  CborValue toCborValue() {
    final Map map = {};
    map[GsSignRequestKeys.uuid.index] = CborBytes(getRequestId(), tags: [RegistryType.UUID.tag]);
    map[GsSignRequestKeys.signData.index] =  CborBytes(signData);
    CborValue keyPath = derivationPath.toCborValue();
    keyPath = cborValueSetTags(keyPath, [derivationPath.getRegistryType().tag]);
    map[GsSignRequestKeys.derivationPath.index] = keyPath;
    map[GsSignRequestKeys.chain.index] = chain;
    if (origin != null) {
      map[GsSignRequestKeys.origin.index] = origin;
    }
    return CborValue(map);
  }

  static GsSignRequest fromDataItem(dynamic jsonData) {
    final map = jsonData is String ? jsonDecode(jsonData) : jsonData is Map? jsonData : null;
    if(map == null){
      throw "Param for fromDataItem is neither String nor Map, please check it!";
    }
    final signData = map[GsSignRequestKeys.signData.index.toString()];
    final uuid = map[GsSignRequestKeys.uuid.index.toString()]?.bytes;
    final chain = map[GsSignRequestKeys.chain.index.toString()];
    final origin = map[GsSignRequestKeys.origin.index.toString()];
    final derivationPath = CryptoKeypath.fromDataItem(map[GsSignRequestKeys.derivationPath.index.toString()]);

    return GsSignRequest(
      uuid: uuid != null ? fromHex(uuid) : null , 
      signData: fromHex(signData),
      derivationPath: derivationPath,
      chain: chain,
      origin: origin,
    );
  }

  static GsSignRequest fromCBOR(Uint8List cborPayload) {
    CborValue cborValue = cbor.decode(cborPayload);
    String jsonData = const CborJsonEncoder().convert(cborValue);
    return fromDataItem(jsonData);
  }
}