import 'package:gs_ur_dart/src/chain/chain_conf.dart';
import 'package:gs_ur_dart/src/chain/alph/alph.dart';
import 'package:gs_ur_dart/src/chain/btc/kas.dart';
import 'package:gs_ur_dart/src/chain/chain.dart';

const coinSeparator = "|";

Map<String, ChainConf> chainConfList = {
  'btc': btcConf,
  'bch': bchConf,
  'ltc': ltcConf,
  'doge': dogeConf,
  'hns': hnsConf,
  'eth': ethConf,
  'arbitrum': arbitrumConf,
  'polygon': polygonConf,
  'avax': avaxConf,
  'bnb': bnbConf,
  'base': baseConf,
  'ftm': ftmConf,
  'optimism': optimismConf,
  'zksync_era': zksyncEraConf,
  'okt': oktConf,
  'cronos': cronosConf,
  'klaytn': klaytnConf,
  'linea': lineaConf,
  'metis': metisConf,
  'scroll': scrollConf,
  'sol': solConf,
  'trx': trxConf,
  'ton': tonConf,
  'atom': atomConf,
  'kava': kavaConf,
  'sei': seiConf,
  'alph': alphConf,
  'kaspa': kasConf,
  'kas': kasConf,
  'morph': morphConf,'ink': inkConf,'rari': rariConf,'gravity': gravityConf,'sonic mainnet': sonicMainnetConf,'bitlayer': bitlayerConf,'metal l2': metalL2Conf,'lisk': liskConf,'unichain testnet': unichainTestnetConf,'alienx': alienxConf,'ape': apeConf,'world chain': worldChainConf,'kroma': kromaConf,'fuse': fuseConf,'chiliz': chilizConf,'celo': celoConf,'gnosis': gnosisConf,'gm network': gmNetworkConf,'iota evm': iotaEvmConf,'conflux espace': confluxEspaceConf,'plume testnet': plumeTestnetConf,'imx': imxConf,'aurora': auroraConf,'zora': zoraConf,'bob': bobConf,'b2': b2Conf,'ethw': ethwConf,'ronin': roninConf,'boba': bobaConf,'moonriver': moonriverConf,'bevm': bevmConf,'merlin': merlinConf,'mode': modeConf,'berachain': berachainConf,'opbnb': opbnbConf,'taiko': taikoConf,'zeta': zetaConf,'zklink': zklinkConf,'mantle': mantleConf,'degen': degenConf,'blast': blastConf,'manta': mantaConf,
};

ChainConf? getChainConfByChainId(int chainId, {Net net = Net.main}){
  ChainConf? chainConf = chainConfList.values.firstWhereOrNull((e) => e.netConf.ethChainConf != null && e.netConf.ethChainConf!.id == chainId);
  chainConf?.setNet(net);
  return chainConf;
}


ChainConf? getChainConfByCoinType(int coinType, {Net net = Net.main}){
  ChainConf? chainConf = chainConfList.values.firstWhereOrNull((e) => e.coinType == coinType);
  chainConf?.setNet(net);
  return chainConf;
}

ChainConf getChainConf(String chain, {Net net = Net.main}){
  String chainName = classifyChain(chain).toLowerCase();
  if(chainConfList.keys.contains(chainName)){
    ChainConf chainConf = chainConfList[chainName]!;
    chainConf.setNet(net);
    return chainConf;
  }
  throw Exception('chain $chain not support');
}

extension FirstWhereOrNullExtension<E> on Iterable<E> {
  E? firstWhereOrNull(bool Function(E) test) {
    for (E element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}

/// Formated chain name, to lower case
String formatChainName(String chain) {
  chain = chain.toLowerCase();
  switch (chain.replaceAll('_', '').replaceAll(' ', '')) {
    case 'bitcoin':
      return 'btc';
    case 'bitcoincash':
      return 'bch';
    case 'litecoin':
      return 'ltc';
    case 'dogecoin':
      return 'doge';
    case 'handshake':
      return 'hns';
    case 'ethereum':
      return 'eth';
    case 'arbitrumone':
      return 'arbitrum';
    case 'avalanchec':
    case 'avalanche':
      return 'avax';
    case 'bnbsmartchain':
      return 'bnb';
    case 'fantom':
      return 'ftm';
    case 'zksyncera':
      return 'zksync_era';
    case 'solana':
      return 'sol';
    case 'tron':
      return 'trx';
    case 'toncoin':
      return 'ton';
    case 'cosmoshub':
      return 'atom';
    case 'alephium':
      return 'alph';
    case 'kas':
      return 'kaspa';
    default:
      return chain;
  }
}

/// Formated chain/token name, to lower case
String classifyChain(String chain) {
  if (chain.contains(coinSeparator)) {
    chain = chain.split(coinSeparator)[0];
  }
  return formatChainName(chain);
}