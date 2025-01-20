import 'dart:convert';
import 'dart:typed_data';

import 'package:cbor/cbor.dart';
import 'package:gs_ur_dart/src/registry/crypto_hd_key.dart';
import 'package:gs_ur_dart/src/registry/data_item.dart';
import 'package:gs_ur_dart/src/registry/registry_item.dart';
import 'package:gs_ur_dart/src/registry/registry_type.dart';

enum MultiAccountsKeys {
  zero,
  masterFingerprint,
  keys,
  device,
  deviceId,
  version,
  nickName,
}

class CryptoMultiAccounts extends RegistryItem {
  final Uint8List masterFingerprint;
  final List<CryptoHDKey> keys;
  final String device;
  final String deviceId;
  final String version;
  final String? nickName;

  CryptoMultiAccounts(
    this.masterFingerprint,
    this.keys,
    this.device,
    this.deviceId,
    this.version, this.nickName,
  );

  @override
  RegistryType getRegistryType() {
    return ExtendedRegistryType.CRYPTO_MULTI_ACCOUNTS;
  }

  Uint8List getMasterFingerprint() {
    return masterFingerprint;
  }

  List<CryptoHDKey> getKeys() {
    return keys;
  }

  String getDevice() {
    return device;
  }

  String getDeviceId() {
    return deviceId;
  }

  String getVersion() {
    return version;
  }

  @override
  CborValue toCborValue() {
    final map = {};
      map[MultiAccountsKeys.masterFingerprint.index] = masterFingerprint.buffer.asByteData().getUint32(0, Endian.little);
      map[MultiAccountsKeys.keys.index] = keys.map((item) {
        CborValue dataItem = item.toCborValue();
        dataItem = cborValueSetTags(dataItem, [item.getRegistryType().tag]);
        return dataItem;
      }).toList();
    map[MultiAccountsKeys.device.index] = device;
    map[MultiAccountsKeys.deviceId.index] = deviceId;
    map[MultiAccountsKeys.version.index] = version;
      if (nickName != null) {
      map[MultiAccountsKeys.nickName.index] = nickName;
    }
    return CborValue(map);
  }

  static CryptoMultiAccounts fromDataItem(dynamic jsonData) {
    final map = jsonData is String ? jsonDecode(jsonData) : jsonData is Map? jsonData : null;
    if(map == null){
      throw "Param for fromDataItem is neither String nor Map, please check it!";
    }
    final masterFingerprint = Uint8List(4);
    // ignore: no_leading_underscores_for_local_identifiers
    final _masterFingerprint = map[MultiAccountsKeys.masterFingerprint.index.toString()];
    if (_masterFingerprint != null) {
      ByteData.view(masterFingerprint.buffer).setUint32(0, _masterFingerprint, Endian.little);
    }
    final keys = map[MultiAccountsKeys.keys.index.toString()] as List;
    final cryptoHDKeys = keys.map((item) => CryptoHDKey.fromDataItem(item)).toList();
    final device = map[MultiAccountsKeys.device.index.toString()] as String;
    final deviceId = map[MultiAccountsKeys.deviceId.index.toString()] as String;
    final version = map[MultiAccountsKeys.version.index.toString()] as String;
    final nickName = map.containsKey(MultiAccountsKeys.nickName.index.toString()) ? map[MultiAccountsKeys.nickName.index.toString()] as String : null;
    return CryptoMultiAccounts(masterFingerprint, cryptoHDKeys, device, deviceId, version, nickName);
  }

  static CryptoMultiAccounts fromCBOR(Uint8List cborPayload) {
    CborValue cborValue = cbor.decode(cborPayload);
    String jsonData = const CborJsonEncoder().convert(cborValue);
    return fromDataItem(jsonData);
  }
}
