import 'package:flutter_bitcoin/flutter_bitcoin.dart' as bitcoin;
import 'package:gs_ur_dart/src/chain/chain_conf.dart';

ChainConf xrpConf = ChainConf(
      name: 'Xrp',
      coin: 'xrp',
      symbol: 'XRP',
      coinType: 144,
      decimal: 6,
  mainnet: NetConf(
      networkType: bitcoin.NetworkType(
          messagePrefix: '\u0018Bitcoin Signed Message:\n',
          bech32: 'bc',
          wif: 128,
          pubKeyHash: 0,
          scriptHash: 5,
          bip32: bitcoin.Bip32Type(public: 76067358, private: 76066276))),
  testnet: NetConf(
      networkType: bitcoin.NetworkType(
          messagePrefix: '\u0018Bitcoin Signed Message:\n',
          bech32: 'bc',
          wif: 128,
          pubKeyHash: 0,
          scriptHash: 5,
          bip32: bitcoin.Bip32Type(public: 76067358, private: 76066276))),
);

// class XrpAccount extends XrpType {
//   XrpAccount(super.chain,
//       {super.net,
//       super.xpubkey,
//       super.path,
//       super.addresses,
//       super.tokens,
//       super.inited});
// }
