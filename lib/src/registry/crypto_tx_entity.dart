import 'dart:convert';
import 'dart:typed_data';
import 'package:cbor/cbor.dart';
import 'package:gs_ur_dart/src/registry/registry_item.dart';
import 'package:gs_ur_dart/src/registry/registry_type.dart';
import 'package:gs_ur_dart/src/utils/data_handle.dart';
import 'package:gs_ur_dart/src/utils/format.dart';

enum TxEntityKeys {
  zero,
  address,
  amount,
}

class CryptoTxEntity extends RegistryItem {
  final String? address;
  final Uint8List? amount;

  CryptoTxEntity({
    this.address,
    this.amount,
  });

  @override
  RegistryType getRegistryType() {
    return ExtendedRegistryType.CRYPTO_TXENTITY;
  }

  Uint8List? getAmount() => amount;
  String? getAddress() => address;

  @override
  CborValue toCborValue() {
    final map = {};
    if (amount != null) {
      map[TxEntityKeys.amount.index] = amount;
    }
    if (address != null) {
      map[TxEntityKeys.address.index] = address;
    }
    return CborValue(map);
  }

  static CryptoTxEntity fromDataItem(dynamic jsonData) {
    final map = jsonData is String ? jsonDecode(jsonData) : jsonData is Map? jsonData : null;
    if(map == null){
      throw "Param for fromDataItem is neither String nor Map, please check it!";
    }
    final address = map[TxEntityKeys.address.index.toString()];
    final amount = map[TxEntityKeys.amount.index.toString()];
    return CryptoTxEntity(
      address: address,
      amount: fromHex(amount.toString()),
    );
  }

  static CryptoTxEntity fromCBOR(Uint8List cborPayload) {
    CborValue cborValue = cbor.decode(cborPayload);
    String jsonData = const CborJsonEncoder().convert(cborValue);
    return fromDataItem(jsonData);
  }
}

CryptoTxEntity parseTxEntity(Map<String, dynamic> txEntityMap){
  final address = txEntityMap["address"];
  final Uint8List? amount = txEntityMap["amount"] != null ? bigIntToBytes(txEntityMap["amount"]) : null;

  return CryptoTxEntity(address: address,
  amount: amount,
  );
}
