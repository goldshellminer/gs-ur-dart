import 'package:gs_ur_dart/src/bc_ur/bc_ur_dart.dart';
import 'package:gs_ur_dart/src/chain/chain_list.dart';
import 'package:gs_ur_dart/src/registry/crypto_hd_key.dart';
import 'package:gs_ur_dart/src/registry/registry_type.dart';
import 'package:gs_ur_dart/src/utils/format.dart';

Map<String, dynamic> parseHDKey(UR ur) {
  if (ur.type != RegistryType.CRYPTO_HDKEY.type) {
    throw Exception("type not match");
  }

  final hdKey = CryptoHDKey.fromCBOR(ur.cbor);

  return parseCryptoHDKey(hdKey);
}

Map<String, dynamic> parseCryptoHDKey(CryptoHDKey hdKey) {
  final chainCode = hdKey.chainCode != null ? toHex(hdKey.chainCode!) : null;
  final parentFingerprint = hdKey.parentFingerprint != null ? toHex(hdKey.parentFingerprint!) : null;
  final origin = hdKey.origin;

  if (origin?.sourceFingerprint == null) {
    throw Exception("HDKey is invalid");
  }
  final xfp = toHex(origin!.sourceFingerprint!);

  String? extendedPublicKey;
  if (chainCode != null && parentFingerprint != null) {
    extendedPublicKey = hdKey.getBip32Key();
  }

  final coinType = origin.components[1].index ?? 0;
  return {
    'chain': getChainConfByCoinType(coinType)?.symbol,
    'path': 'm/${origin.getPath()}',
    'publicKey': toHex(hdKey.keyData!),
    'name': hdKey.name,
    'xfp': xfp,
    'chainCode': chainCode,
    'extendedPublicKey': extendedPublicKey,
    'note': hdKey.note,
  };
}
