import 'package:flutter_bitcoin/flutter_bitcoin.dart' as bitcoin;
import 'package:gs_ur_dart/src/chain/chain_conf.dart';

ChainConf dogeConf = ChainConf(
  name: 'Dogecoin',
  coin: "DOGE",
  symbol: 'DOGE',
  coinType: 3,
  decimal: 8,
  minAmount: 5,
  mainnet: NetConf(
      networkType: bitcoin.NetworkType(
          messagePrefix: '\x19Dogecoin Signed Message:\n',
          wif: 0x9e,
          pubKeyHash: 0x1e,
          scriptHash: 0x16,
          bip32: bitcoin.Bip32Type(public: 0x02facafd, private: 0x02fac398))),
  testnet: NetConf(
      networkType: bitcoin.NetworkType(
          messagePrefix: '\x19Dogecoin Signed Message:\n',
          wif: 0x9e,
          pubKeyHash: 0x1e,
          scriptHash: 0x16,
          bip32: bitcoin.Bip32Type(public: 0x02facafd, private: 0x02fac398))),
);
