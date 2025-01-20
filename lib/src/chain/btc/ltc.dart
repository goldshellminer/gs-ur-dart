import 'package:flutter_bitcoin/flutter_bitcoin.dart' as bitcoin;
import 'package:gs_ur_dart/src/chain/chain_conf.dart';

ChainConf ltcConf = ChainConf(
  name: 'Litecoin',
  coin: "LTC",
  symbol: 'LTC',
  coinType: 2,
  decimal: 8,
  minAmount: 0.001,
  mainnet: NetConf(
      networkType: bitcoin.NetworkType(
          messagePrefix: '\x19Litecoin Signed Message:\n',
          bech32: 'ltc',
          wif: 0xb0,
          pubKeyHash: 0x30,
          scriptHash: 0x32,
          bip32: bitcoin.Bip32Type(public: 0x019da462, private: 0x019d9cfe))),
  testnet: NetConf(
      networkType: bitcoin.NetworkType(
          messagePrefix: '\x19Litecoin Signed Message:\n',
          bech32: 'ltc',
          wif: 0xb0,
          pubKeyHash: 0x30,
          scriptHash: 0x32,
          bip32: bitcoin.Bip32Type(public: 0x019da462, private: 0x019d9cfe))),
);
