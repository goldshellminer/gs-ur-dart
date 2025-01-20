import 'package:flutter_bitcoin/flutter_bitcoin.dart' as bitcoin;
import 'package:gs_ur_dart/src/chain/chain_conf.dart';

ChainConf hnsConf = ChainConf(
  name: 'Handshake',
  coin: "HNS",
  symbol: 'HNS',
  coinType: 5353,
  blockTime: 10,
  interval: 36,
  decimal: 6,
  minAmount: 0.1,
  mainnet: NetConf(
      networkType: bitcoin.NetworkType(
          messagePrefix: '',
          bech32: 'hs',
          wif: 0x80,
          pubKeyHash: 0,
          scriptHash: 5,
          bip32: bitcoin.Bip32Type(public: 0x0488b21e, private: 0x0488ade4))),
  testnet: NetConf(
      networkType: bitcoin.NetworkType(
          messagePrefix: '',
          bech32: 'rs',
          wif: 0x5a,
          pubKeyHash: 0,
          scriptHash: 5,
          bip32: bitcoin.Bip32Type(public: 0xeab4fa05, private: 0xeab404c7))),
);
