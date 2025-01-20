import 'package:flutter_bitcoin/flutter_bitcoin.dart' as bitcoin;
import 'package:gs_ur_dart/src/chain/chain_conf.dart';

ChainConf trxConf = ChainConf(
  name: 'Tron',
  coin: "TRX",
  symbol: 'TRX',
  coinType: 195,
  decimal: 6,
  minAmount: 0.0001,
  mainnet: NetConf(
      ethChainConf: EthChainConf(id: -1, type: TxType.tron),
      networkType: bitcoin.NetworkType(
          messagePrefix: '\u0018Bitcoin Signed Message:\n',
          bech32: 'bc',
          wif: 128,
          pubKeyHash: 0,
          scriptHash: 5,
          bip32: bitcoin.Bip32Type(public: 76067358, private: 76066276))),
  testnet: NetConf(
      ethChainConf: EthChainConf(id: -1, type: TxType.tron),
      networkType: bitcoin.NetworkType(
          messagePrefix: '\u0018Bitcoin Signed Message:\n',
          bech32: 'tb',
          wif: 239,
          pubKeyHash: 111,
          scriptHash: 196,
          bip32: bitcoin.Bip32Type(public: 70617039, private: 70615956))),
);
