import 'package:flutter_bitcoin/flutter_bitcoin.dart';

class ChainConf{
  final String name;
  final String coin;
  final String symbol;
  final int coinType;
  final int decimal;
  final NetConf mainnet;
  final NetConf testnet;
  double? minAmount;
  int? blockTime;
  int? interval;
  Net net = Net.main;

  ChainConf({required this.name, required this.coin, required this.symbol, required this.coinType, required this.decimal, this.minAmount, required this.mainnet, required this.testnet, this.net = Net.main, this.blockTime,this.interval});

  void setNet(Net net) => this.net = net;
  NetConf get netConf => net == Net.main ? mainnet : testnet;
}

class NetConf{
  NetworkType networkType;
  EthChainConf? ethChainConf;
  NetConf({required this.networkType, this.ethChainConf});
}

class EthChainConf {
  final int id;
  final TxType type;
  final bool custom;

  EthChainConf({
    required this.id,
    required this.type,
    this.custom = false
  });
}


enum Net {
  main,
  test
}


enum TxType {
  inscribe,
  brc20,
  taproot, // Commencing with "bc1p". Extremely nominal network expenses. BIP86,P2TR,Bech32m.
  nestedSegWit, // Commencing with "3". Moderate network expenses. BIP49,P2SH-P2WPKH,Base58.
  nativeSegWit, // Commencing with "bc1". Subdued network expenses. BIP84.P2WPKH, Bech32.
  legacy,
  eip1559,
  tron,
  hns,
  btc,
  sol,
  ton,
  atom,
  none
}