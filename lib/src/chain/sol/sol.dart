import 'package:flutter_bitcoin/flutter_bitcoin.dart' as bitcoin;
import 'package:gs_ur_dart/src/chain/chain_conf.dart';

ChainConf solConf = ChainConf(
  name: 'Solana',
  coin: "SOL",
  symbol: 'SOL',
  coinType: 501,
  decimal: 9,
  minAmount: 0.005,
  mainnet: NetConf(
      ethChainConf: EthChainConf(id: -1, type: TxType.legacy),
      networkType: bitcoin.NetworkType(
          messagePrefix: '\u0018Bitcoin Signed Message:\n',
          bech32: 'bc',
          wif: 128,
          pubKeyHash: 0,
          scriptHash: 5,
          bip32: bitcoin.Bip32Type(public: 76067358, private: 76066276))),
  testnet: NetConf(
      ethChainConf: EthChainConf(id: -1, type: TxType.legacy),
      networkType: bitcoin.NetworkType(
          messagePrefix: '\u0018Bitcoin Signed Message:\n',
          bech32: 'bc',
          wif: 128,
          pubKeyHash: 0,
          scriptHash: 5,
          bip32: bitcoin.Bip32Type(public: 76067358, private: 76066276))),
);

