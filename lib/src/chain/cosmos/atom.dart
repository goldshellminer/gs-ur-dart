import 'package:flutter_bitcoin/flutter_bitcoin.dart' as bitcoin;
import 'package:gs_ur_dart/src/chain/chain_conf.dart';

ChainConf atomConf = ChainConf(
  name: 'Cosmos Hub',
  coin: "ATOM",
  symbol: 'ATOM',
  coinType: 118,
  decimal: 6,
  minAmount: 0.0001,
  mainnet: NetConf(
      networkType: bitcoin.NetworkType(
          messagePrefix: '\u0018Bitcoin Signed Message:\n',
          bech32: 'cosmos',
          wif: 128,
          pubKeyHash: 0,
          scriptHash: 5,
          bip32: bitcoin.Bip32Type(public: 76067358, private: 76066276))),
  testnet: NetConf(
      networkType: bitcoin.NetworkType(
          messagePrefix: '\u0018Bitcoin Signed Message:\n',
          bech32: 'cosmos',
          wif: 128,
          pubKeyHash: 0,
          scriptHash: 5,
          bip32: bitcoin.Bip32Type(public: 76067358, private: 76066276))),
);