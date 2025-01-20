import 'package:flutter_bitcoin/flutter_bitcoin.dart' as bitcoin;
import 'package:gs_ur_dart/src/chain/chain_conf.dart';

ChainConf bchConf = ChainConf(
  name: 'Bitcoin Cash',
  coin: "BCH",
  symbol: 'BCH',
  coinType: 145,
  decimal: 8,
  minAmount: 0.0001,
  mainnet: NetConf(
      networkType: bitcoin.NetworkType(
          messagePrefix: '\u0019BitcoinCash Signed Message:\n',
          wif: 128,
          pubKeyHash: 0,
          scriptHash: 5,
          bech32: 'bitcoincash',
          bip32: bitcoin.Bip32Type(public: 76067358, private: 76066276))),
  testnet: NetConf(
      networkType: bitcoin.NetworkType(
          messagePrefix: '\u0019BitcoinCash Signed Message:\n',
          wif: 128,
          pubKeyHash: 0,
          scriptHash: 5,
          bech32: 'bitcoincash',
          bip32: bitcoin.Bip32Type(public: 76067358, private: 76066276))),
);
