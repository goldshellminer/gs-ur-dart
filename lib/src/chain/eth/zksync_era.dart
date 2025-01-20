import 'package:flutter_bitcoin/flutter_bitcoin.dart' as bitcoin;
import 'package:gs_ur_dart/src/chain/chain_conf.dart';


ChainConf zksyncEraConf = ChainConf(
  name: 'zkSync Era',
  coin: "zkSync_Era",
  symbol: 'ETH',
  coinType: 60,
  decimal: 6,
  minAmount: 0.0001,
  mainnet: NetConf(
      ethChainConf: EthChainConf(id: 324, type: TxType.eip1559),
      networkType: bitcoin.NetworkType(
          messagePrefix: '\u0018Bitcoin Signed Message:\n',
          bech32: 'bc',
          wif: 128,
          pubKeyHash: 0,
          scriptHash: 5,
          bip32: bitcoin.Bip32Type(public: 76067358, private: 76066276))),
  testnet: NetConf(
      ethChainConf: EthChainConf(id: 324, type: TxType.eip1559),
      networkType: bitcoin.NetworkType(
          messagePrefix: '\u0018Bitcoin Signed Message:\n',
          bech32: 'bc',
          wif: 128,
          pubKeyHash: 0,
          scriptHash: 5,
          bip32: bitcoin.Bip32Type(public: 76067358, private: 76066276))),
);
