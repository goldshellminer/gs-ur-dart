import 'dart:convert';
import 'dart:typed_data';

import 'package:cbor/cbor.dart';
import 'package:gs_ur_dart/src/registry/crypto_key_path.dart';
import 'package:gs_ur_dart/src/registry/registry_item.dart';
import 'package:gs_ur_dart/src/registry/registry_type.dart';
import 'package:gs_ur_dart/src/utils/format.dart';
import 'package:gs_ur_dart/src/utils/uuid.dart';

enum TxElementKeys {
  zero,
  path,
  amount,
  signature,
  signhashType,
  address,
}

class CryptoTxElement extends RegistryItem {
  final List<PathComponent>? path;
  final String? address;
  final int? amount;
  final Uint8List? signature;
  final int? signhashType;

  CryptoTxElement({
    this.path,
    this.address,
    this.amount,
    this.signature,
    this.signhashType,
  });

  @override
  RegistryType getRegistryType() {
    return ExtendedRegistryType.CRYPTO_TXELEMENT;
  }

  String? getPath() {
    final pathComponents = path?.map((component) {
      return '${component.isWildcard() ? '*' : component.getIndex()}${component.isHardened() ? "'" : ''}';
    }).join('/');
    return pathComponents;
  }

  List<PathComponent>? getComponents() => path;
  int? getAmount() => amount;
  String? getAddress() => address;
  Uint8List? getSignature() => signature;
  int? getSignhashType() => signhashType;

  @override
  CborValue toCborValue() {
    final map = {};
    final List componentsData = [];
    if(path != null){
    for (var component in path!) {
      if (component.isWildcard()) {
        componentsData.add([]);
      } else {
        componentsData.add(component.getIndex());
      }
      componentsData.add(component.isHardened());
    }
    }
    map[TxElementKeys.path.index] = componentsData;
    if (amount != null) {
      map[TxElementKeys.amount.index] = amount;
    }
    if (signature != null) {
      map[TxElementKeys.signature.index] = signature;
    }
    if (signhashType != null) {
      map[TxElementKeys.signhashType.index] = signhashType;
    }
    if (address != null) {
      map[TxElementKeys.address.index] = address;
    }
    return CborValue(map);
  }

  static CryptoTxElement fromDataItem(dynamic jsonData) {
    final map = jsonData is String ? jsonDecode(jsonData) : jsonData is Map? jsonData : null;
    if(map == null){
      throw "Param for fromDataItem is neither String nor Map, please check it!";
    }
    final pathComponents = <PathComponent>[];
    final paths = map[TxElementKeys.path.index.toString()] as List<dynamic>? ?? [];

    for (var i = 0; i < paths.length; i += 2) {
      final isHardened = paths[i + 1] as bool;
      final path = paths[i];

      if (path is int) {
        pathComponents.add(PathComponent(index: path, hardened: isHardened));
      } else {
        pathComponents.add(PathComponent(hardened: isHardened));
      }
    }
    final address = map[TxElementKeys.address.index.toString()];
    final amount = map[TxElementKeys.amount.index.toString()];
    final signatureData = map[TxElementKeys.signature.index.toString()];
    final signhashTypeData = map[TxElementKeys.signhashType.index.toString()];
    return CryptoTxElement(
      path: pathComponents,
      address: address,
      amount: amount,
      signature: signatureData != null ? fromHex(signatureData): null,
      signhashType: signhashTypeData,
    );
  }

  static CryptoTxElement fromCBOR(Uint8List cborPayload) {
    CborValue cborValue = cbor.decode(cborPayload);
    String jsonData = const CborJsonEncoder().convert(cborValue);
    return fromDataItem(jsonData);
  }
}

CryptoTxElement parseTxElement(Map<String, dynamic> txElementMap){
  final address = txElementMap["address"];
  final path = txElementMap["path"];
  final amount = txElementMap["amount"];
  final signature = txElementMap["signature"];
  final signhashType = txElementMap["signhashType"];

  return CryptoTxElement(path: path != null ?parsePath(path).map((e) => PathComponent(index:e["index"], hardened: e["hardened"])).toList() : null,
  address: address,
  amount: amount,
  signature: signature,
  signhashType: signhashType,
  );
}
