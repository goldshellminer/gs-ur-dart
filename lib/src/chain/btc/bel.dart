import 'package:flutter_bitcoin/flutter_bitcoin.dart' as bitcoin;
import 'package:gs_ur_dart/src/chain/chain_conf.dart';

ChainConf belConf = ChainConf(
  name: 'Bells',
  coin: 'bells',
  symbol: 'BEL',
  coinType: -1,
  decimal: 8,
  mainnet: NetConf(
      networkType: bitcoin.NetworkType(
          messagePrefix: '\u0018Bitcoin Signed Message:\n',
          bech32: 'bc',
          pubKeyHash: 0x19,
          scriptHash: 0x24,
          wif: 0x99,
          bip32: bitcoin.Bip32Type(
            public: 0x0488b21e,
            private: 0x0488ade4,
          ))),
  testnet: NetConf(
      networkType: bitcoin.NetworkType(
          messagePrefix: '\u0018Bitcoin Signed Message:\n',
          bech32: 'bc',
          pubKeyHash: 0x19,
          scriptHash: 0x24,
          wif: 0x99,
          bip32: bitcoin.Bip32Type(
            public: 0x0488b21e,
            private: 0x0488ade4,
          ))),
);
