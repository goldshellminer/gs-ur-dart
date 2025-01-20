
import 'dart:convert';
import 'dart:typed_data';
import 'package:cbor/cbor.dart';
import 'package:gs_ur_dart/src/chain/chain_list.dart';
import 'package:gs_ur_dart/src/utils/format.dart';
import 'package:gs_ur_dart/src/chain/chain_conf.dart';
import 'package:gs_ur_dart/src/registry/crypto_key_path.dart';
import 'package:gs_ur_dart/src/registry/data_item.dart';
import 'package:gs_ur_dart/src/registry/registry_item.dart';
import 'package:gs_ur_dart/src/registry/registry_type.dart';
import 'package:gs_ur_dart/src/utils/data_handle.dart';
import 'package:hex/hex.dart';

import 'package:gs_ur_dart/src/registry/crypto_coin_info.dart';

enum HDKeyKeys {
  zero,
  isMaster,
  isPrivate,
  keyData,
  chainCode,
  useInfo,
  origin,
  children,
  parentFingerprint,
  name,
  note,
}

class CryptoMasterHDKey extends CryptoHDKey{

  CryptoMasterHDKey({
    super.isMaster = true,
    required super.keyData,
    required super.chainCode,
    super.name,
    super.note,
  });
}

class CryptoDeriveHDKey  extends CryptoHDKey{

  CryptoDeriveHDKey({
    super.isMaster = false,
    super.isPrivateKey = false,
    required super.keyData,
    super.chainCode,
    super.useInfo,
    super.origin,
    super.children,
    super.parentFingerprint,
    super.name,
    super.note,
  });
}

class CryptoHDKey  extends RegistryItem{
  bool? isMaster;
  bool? isPrivateKey;
  Uint8List? keyData;
  Uint8List? chainCode;
  CryptoCoinInfo? useInfo;
  CryptoKeypath? origin;
  CryptoKeypath? children;
  Uint8List? parentFingerprint;
  String? name;
  String? note;

  CryptoHDKey({this.isMaster, 
    this.isPrivateKey,
    this.keyData,
    this.chainCode,
    this.useInfo,
    this.origin,
    this.children,
    this.parentFingerprint,
    this.name,
    this.note,});

  bool isECKey() {
    return false;
  }

  getBip32Key({String? chain}) {
    late Uint8List version;
    int depth;
    int index = 0;
    ChainConf chainType = getChainConf(chain ?? 'btc');

    if (isMaster != null && isMaster!) {
      version = Uint8List.fromList(HEX.decode('0488ADE4'));
      depth = 0;
      index = 0;
    } else {
      depth = origin?.getComponents().length ?? origin?.depth ?? 0;
      final paths = origin?.getComponents() ?? [];
      final lastPath = paths.isNotEmpty ? paths.last : null;

      if (lastPath != null) {
        index = lastPath.isHardened() ? lastPath.index! + 0x80000000 : lastPath.getIndex()!;
      }
      if(chain == null && paths.isNotEmpty){
        chainType = getChainConfByCoinType(paths[1].getIndex() ?? 0) ?? chainType;
      }
      version = isPrivateKey != null && isPrivateKey! ? intToUint8List(chainType.netConf.networkType.bip32.private) : intToUint8List(chainType.netConf.networkType.bip32.public);
    }

    final depthBuffer = Uint8List(1)..[0] = depth;
    final indexBuffer = Uint8List(4)..buffer.asByteData().setUint32(0, index);
    if (parentFingerprint == null || chainCode == null || keyData == null) {
      throw "Lack of enough info, parentFingerprint or chainCode or keyData!";
    }

    return listToBase58(Uint8List.fromList([
      ...version,
      ...depthBuffer,
      ...parentFingerprint!,
      ...indexBuffer,
      ...chainCode!,
      ...keyData!,
    ]));
  }

  @override
  RegistryType getRegistryType() {
    return RegistryType.CRYPTO_HDKEY;
  }

  String getOutputDescriptorContent() {
    var result = '';
    if (origin != null) {
      if (origin!.sourceFingerprint != null && origin!.getPath() != null) {
        result += '${origin!.sourceFingerprint!.toString()}/${origin!.getPath()}';
      }
    }

    result += HEX.encode(getBip32Key());

    if (children != null) {
      if (children!.getPath() != null) {
        result += '/${children!.getPath()}';
      }
    }

    return result;
  }

  @override
  CborValue toCborValue() {
    final map = {};
    if (isMaster == true) {
      map[HDKeyKeys.isMaster.index] = true;
      map[HDKeyKeys.keyData.index] = keyData;
      map[HDKeyKeys.chainCode.index] = chainCode;
    } else {
      if (isPrivateKey != null) {
        map[HDKeyKeys.isPrivate.index] = isPrivateKey;
      }
      map[HDKeyKeys.keyData.index] = keyData;
      if (chainCode != null) {
        map[HDKeyKeys.chainCode.index] = chainCode;
      }
      if (useInfo != null) {
        CborValue useInfoDataItem = useInfo!.toCborValue();
        useInfoDataItem = cborValueSetTags(useInfoDataItem, [useInfo!.getRegistryType().tag]);
        map[HDKeyKeys.useInfo.index] = useInfoDataItem;
      }
      if (origin != null) {
        CborValue originDataItem = origin!.toCborValue();
        originDataItem = cborValueSetTags(originDataItem, [origin!.getRegistryType().tag]);
        map[HDKeyKeys.origin.index] = originDataItem;
      }
      if (children != null) {
        CborValue childrenDataItem = children!.toCborValue();
        childrenDataItem = cborValueSetTags(childrenDataItem, [children!.getRegistryType().tag]);
        map[HDKeyKeys.children.index] = childrenDataItem;
      }
      if (parentFingerprint != null) {
        map[HDKeyKeys.parentFingerprint.index] = parentFingerprint!.buffer.asByteData().getUint32(0, Endian.little);
      }
      if (name != null) {
        map[HDKeyKeys.name.index] = name;
      }
      if (note != null) {
        map[HDKeyKeys.note.index] = note;
      }
    }
    return CborValue(map);
  }

  static CryptoHDKey fromDataItem(dynamic jsonData) {
    final map = jsonData is String ? jsonDecode(jsonData) : jsonData is Map? jsonData : null;
    if(map == null){
      throw "Param for fromDataItem is neither String nor Map, please check it!";
    }
    final isMaster = map[HDKeyKeys.isMaster.index.toString()] ?? false;
    final isPrivateKey = map[HDKeyKeys.isPrivate.index.toString()];
    final keyData = map[HDKeyKeys.keyData.index.toString()];
    final chainCode = map[HDKeyKeys.chainCode.index.toString()];
    final useInfo = map[HDKeyKeys.useInfo.index.toString()] != null ? CryptoCoinInfo.fromDataItem(map[HDKeyKeys.useInfo.index.toString()]) : null;
    final origin = map[HDKeyKeys.origin.index.toString()] != null ? CryptoKeypath.fromDataItem(map[HDKeyKeys.origin.index.toString()]) : null;
    final children = map[HDKeyKeys.children.index.toString()] != null ? CryptoKeypath.fromDataItem(map[HDKeyKeys.children.index.toString()]) : null;
    final parentFingerprintData = map[HDKeyKeys.parentFingerprint.index.toString()];
    Uint8List? parentFingerprint;
    if (parentFingerprintData != null) {
      parentFingerprint = Uint8List(4);
      parentFingerprint.buffer.asByteData().setUint32(0, parentFingerprintData);
    }
    final name = map[HDKeyKeys.name.index.toString()];
    final note = map[HDKeyKeys.note.index.toString()];

    return CryptoDeriveHDKey(
      isMaster: isMaster,
      isPrivateKey: isPrivateKey,
      keyData: keyData != null? fromHex(keyData): null,
      chainCode: chainCode != null? fromHex(chainCode): null,
      useInfo: useInfo,
      origin: origin,
      children: children,
      parentFingerprint: parentFingerprint,
      name: name,
      note: note,
    );
  }

  static CryptoHDKey fromCBOR(Uint8List cborPayload) {
    CborValue cborValue = cbor.decode(cborPayload);
    String jsonData = const CborJsonEncoder().convert(cborValue);
    return fromDataItem(jsonData);
  }
}
