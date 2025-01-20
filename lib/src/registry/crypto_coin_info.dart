import 'dart:convert';
import 'dart:typed_data';
import 'package:cbor/cbor.dart';
import 'package:gs_ur_dart/src/chain/chain_conf.dart';
import 'package:gs_ur_dart/src/chain/chain_list.dart';
import 'package:gs_ur_dart/src/registry/registry_item.dart';
import 'package:gs_ur_dart/src/registry/registry_type.dart';

enum CoinInfoKeys {
  zero,
  type,
  network,
}

enum Network {
  zero,
  mainnet,
  testnet,
}

class CryptoCoinInfo extends RegistryItem {
  int? type;
  Network? network;

  CryptoCoinInfo(this.type, this.network);

  @override
  RegistryType getRegistryType() {
    return RegistryType.CRYPTO_COIN_INFO;
  }

  int getType() {
    return type ?? 0;
  }

  Network getNetwork() {
    return network ?? Network.mainnet;
  }

  ChainConf? chainConf() => getChainConfByChainId(type ?? 0);

  @override
  CborValue toCborValue() {
    final map = {};
    if (type != null) {
      map[CoinInfoKeys.type.index] = type!;
    }
    if (network != null) {
      map[CoinInfoKeys.network.index] = network!.index;
    }
    return CborValue(map);
  }

  static CryptoCoinInfo fromDataItem(dynamic jsonData) {
    final map = jsonData is String ? jsonDecode(jsonData) : jsonData is Map? jsonData : null;
    if(map == null){
      throw "Param for fromDataItem is neither String nor Map, please check it!";
    }
    final int? type;
    final Network? network;
    if(map.containsKey(CoinInfoKeys.type.index.toString())){
      type = map[CoinInfoKeys.type.index.toString()];
    }else{
      type = null;
    }
    if(map.containsKey(CoinInfoKeys.network.index.toString())){
      network = Network.values[map[CoinInfoKeys.network.index.toString()]];
    }else{
      network = null;
    }
    return CryptoCoinInfo(type, network);
  }

  static CryptoCoinInfo fromCBOR(Uint8List cborPayload) {
    CborValue cborValue = cbor.decode(cborPayload);
    String jsonData = const CborJsonEncoder().convert(cborValue);
    return fromDataItem(jsonData);
  }
}
