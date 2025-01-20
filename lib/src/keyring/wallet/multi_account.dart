import 'package:gs_ur_dart/src/bc_ur/bc_ur_dart.dart';
import 'package:gs_ur_dart/src/registry/extended/crypto_multi_accounts.dart';
import 'package:gs_ur_dart/src/registry/registry_type.dart';
import 'package:gs_ur_dart/src/keyring/wallet/hdkey.dart';
import 'package:gs_ur_dart/src/utils/format.dart';

Map<String, dynamic> parseMultiAccounts(UR ur) {
  if (ur.type != ExtendedRegistryType.CRYPTO_MULTI_ACCOUNTS.type) {
    throw Exception('type not match');
  }

  final accounts = CryptoMultiAccounts.fromCBOR(ur.cbor);
  final masterFingerprint = toHex(accounts.masterFingerprint);

  return {
    'device': accounts.device,
    'masterFingerprint': masterFingerprint,
    'keys': accounts.keys.map((hdKey) =>parseCryptoHDKey(hdKey)).toList(),
    'deviceId': accounts.deviceId,
    'version': accounts.version,
    'nickName': accounts.nickName,
  };
}
