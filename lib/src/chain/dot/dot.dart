import 'package:flutter_bitcoin/flutter_bitcoin.dart' as bitcoin;
import 'package:gs_ur_dart/src/chain/chain_conf.dart';

ChainConf dotConf = ChainConf(
      name: 'Polkadot',
      coin: 'DOT',
      symbol: 'DOT',
      coinType: 354,
      decimal: 8,
  mainnet: NetConf(
      networkType: bitcoin.NetworkType(
          messagePrefix: '\u0018Bitcoin Signed Message:\n',
          bech32: 'bitcoincash',
          wif: 128,
          pubKeyHash: 0,
          scriptHash: 5,
          bip32: bitcoin.Bip32Type(public: 76067358, private: 76066276))),
  testnet: NetConf(
      networkType: bitcoin.NetworkType(
          messagePrefix: '\u0018Bitcoin Signed Message:\n',
          bech32: 'bitcoincash',
          wif: 128,
          pubKeyHash: 0,
          scriptHash: 5,
          bip32: bitcoin.Bip32Type(public: 76067358, private: 76066276))),
);

// class DotAccount extends DotType {
//   DotAccount(super.chain,
//       {super.net,
//       super.xpubkey,
//       super.path,
//       super.addresses,
//       super.tokens,
//       super.inited});
// }
