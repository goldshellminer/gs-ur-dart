import 'dart:convert';
import 'dart:typed_data';
import 'package:cbor/cbor.dart';
import 'package:gs_ur_dart/src/registry/crypto_key_path.dart';
import 'package:gs_ur_dart/src/registry/data_item.dart';
import 'package:gs_ur_dart/src/registry/registry_item.dart';
import 'package:gs_ur_dart/src/registry/registry_type.dart';
import 'package:gs_ur_dart/src/utils/format.dart';
import 'package:gs_ur_dart/src/utils/uuid.dart';


enum EthSignRequestKeys {
  zero,
  uuid,
  signData,
  dataType,
  chainId,
  derivationPath,
  address,
  origin,
}

enum EthDataType {
  zero,
  transaction,
  typedData,
  personalMessage,
  typedTransaction,
}

class EthSignRequest extends RegistryItem {
  Uint8List? uuid;
  final Uint8List signData;
  final EthDataType dataType;
  final int? chainId;
  final CryptoKeypath derivationPath;
  final Uint8List? address;
  final String? origin;

  EthSignRequest({
    this.uuid,
    required this.signData,
    required this.dataType,
    this.chainId,
    required this.derivationPath,
    this.address,
    this.origin,
  });

  @override
  RegistryType getRegistryType() {
    return ExtendedRegistryType.ETH_SIGN_REQUEST;
  }

  Uint8List getRequestId() => uuid ??= generateUuid();
  Uint8List getSignData() => signData;
  EthDataType getEthDataType() => dataType;
  int? getChainId() => chainId;
  String? getDerivationPath() => derivationPath.getPath();
  Uint8List? getSourceFingerprint() => derivationPath.sourceFingerprint;
  Uint8List? getSignRequestAddress() => address;
  String? getOrigin() => origin;

  @override
  CborValue toCborValue() {
    final Map map = {};
    map[EthSignRequestKeys.uuid.index] = CborBytes(getRequestId(), tags: [RegistryType.UUID.tag]);
    map[EthSignRequestKeys.signData.index] = signData;
    map[EthSignRequestKeys.dataType.index] = dataType.index;
    if (chainId != null) {
      map[EthSignRequestKeys.chainId.index] = chainId;
    }
    CborValue keyPath = derivationPath.toCborValue();
    keyPath = cborValueSetTags(keyPath, [derivationPath.getRegistryType().tag]);
    map[EthSignRequestKeys.derivationPath.index] = keyPath;
    if (address != null) {
      map[EthSignRequestKeys.address.index] = address;
    }
    if (origin != null) {
      map[EthSignRequestKeys.origin.index] = origin;
    }
    return CborValue(map);
  }

  static EthSignRequest fromDataItem(dynamic jsonData) {
    final map = jsonData is String ? jsonDecode(jsonData) : jsonData is Map? jsonData : null;
    if(map == null){
      throw "Param for fromDataItem is neither String nor Map, please check it!";
    }
    final signData = map[EthSignRequestKeys.signData.index.toString()];
    final dataType = EthDataType.values[map[EthSignRequestKeys.dataType.index.toString()]];
    final derivationPath = CryptoKeypath.fromDataItem(map[EthSignRequestKeys.derivationPath.index.toString()]);
    final chainId = map[EthSignRequestKeys.chainId.index.toString()];
    final address = map[EthSignRequestKeys.address.index.toString()];
    final uuid = map[EthSignRequestKeys.uuid.index.toString()];
    final origin = map[EthSignRequestKeys.origin.index.toString()];

    return EthSignRequest(
      uuid: fromHex(uuid), 
      signData: fromHex(signData),
      dataType: dataType,
      chainId: chainId,
      derivationPath: derivationPath,
      address: address,
      origin: origin,
    );
  }

  static EthSignRequest fromCBOR(Uint8List cborPayload) {
    CborValue cborValue = cbor.decode(cborPayload);
    String jsonData = const CborJsonEncoder().convert(cborValue);
    return fromDataItem(jsonData);
  }
}