// ignore_for_file: non_constant_identifier_names

class ExtendedRegistryType extends RegistryType{
  ExtendedRegistryType(super._type,super._tag);

  static RegistryType CRYPTO_MULTI_ACCOUNTS= RegistryType("crypto-multi-accounts", 1103);
  static RegistryType QR_HARDWARE_CALL= RegistryType("qr-hardware-call", 1201);
  static RegistryType KEY_DERIVATION_CALL= RegistryType("key-derivation-call", 1301);
  static RegistryType KEY_DERIVATION_SCHEMA= RegistryType("key-derivation-schema", 1302);

  static RegistryType GS_SIGN_REQUEST = RegistryType("gs-sign-request", 6101);
  static RegistryType GS_SIGNATURE = RegistryType("gs-signature", 6102);
  static RegistryType GS_VERIFY_REQUEST = RegistryType("gs-verify-request", 6107);
  static RegistryType GS_VERIFY_RESPONSE = RegistryType("gs-verify-response", 6108);
  static RegistryType CRYPTO_TXELEMENT = RegistryType("crypto-txelement", 6110);
  static RegistryType CRYPTO_GSPL= RegistryType("gspl", 6111);
  static RegistryType CRYPTO_TXENTITY = RegistryType("crypto-txentity", 6112);

  static RegistryType ETH_SIGN_REQUEST = RegistryType("eth-sign-request", 401);
  static RegistryType ETH_SIGNATURE = RegistryType("eth-signature", 402);
  static RegistryType ETH_NFT_ITEM = RegistryType("eth-nft-item", 403);

  static RegistryType PSBT_SIGN_REQUEST = RegistryType("psbt-sign-request", 8101);
  static RegistryType PSBT_SIGNATURE = RegistryType("psbt-signature", 8102);
  static RegistryType BTC_SIGN_REQUEST = RegistryType("btc-sign-request", 8103);
  static RegistryType BTC_SIGNATURE = RegistryType("btc-signature", 8104);
  static RegistryType ALPH_SIGN_REQUEST = RegistryType("alph-sign-request", 8110);
  static RegistryType ALPH_SIGNATURE = RegistryType("alph-signature", 8111);
  // DELETE
  static RegistryType BTC_INSCRIBE_REQUEST = RegistryType("btc-inscribe-request", 8105);
  static RegistryType BTC_INSCRIBE_SIGNATURE = RegistryType("btc-inscribe-signature", 8106);

  static RegistryType SOL_SIGN_REQUEST = RegistryType("sol-sign-request", 1101);
  static RegistryType SOL_SIGNATURE = RegistryType("sol-signature", 1102);
  static RegistryType SOL_NFT_ITEM = RegistryType("sol-nft-item", 1104);

  static RegistryType COSMOS_SIGN_REQUEST = RegistryType("cosmos-sign-request", 1201);
  static RegistryType COSMOS_SIGNATURE = RegistryType("cosmos-signature", 1202);

  static RegistryType TRON_SIGN_REQUEST = RegistryType("tron-sign-request", 1301);
  static RegistryType TRON_SIGNATURE = RegistryType("tron-signature", 1302);

}
class RegistryType {
  final String _type;
  final int? _tag;

  get type => _type;
  get tag => _tag;
  RegistryType(this._type,this._tag);
  @override
  String toString(){
    return "type: $type, tag: $tag";
  }

  static RegistryType UUID = RegistryType('uuid', 37);
  static RegistryType BYTES= RegistryType('bytes', null);
  static RegistryType CRYPTO_HDKEY= RegistryType('crypto-hdkey', 40303);
  static RegistryType CRYPTO_KEYPATH= RegistryType('crypto-keypath', 40304);
  static RegistryType CRYPTO_COIN_INFO= RegistryType('crypto-coin-info', 40305);
  static RegistryType CRYPTO_ECKEY= RegistryType('crypto-eckey', 40306);
  static RegistryType CRYPTO_ADDRESS= RegistryType('crypto-address', 40307);
  static RegistryType CRYPTO_OUTPUT= RegistryType('crypto-output', 40308);
  static RegistryType CRYPTO_PSBT= RegistryType('crypto-psbt', 40310);
  static RegistryType CRYPTO_ACCOUNT= RegistryType('crypto-account', 40311);

}
