import 'dart:typed_data';

import 'package:gs_ur_dart/src/bc_ur/bc_ur_dart.dart';
import 'package:gs_ur_dart/src/registry/crypto_key_path.dart';
import 'package:gs_ur_dart/src/registry/registry_type.dart';
import 'package:gs_ur_dart/src/registry/tron/tron_sign_request.dart';
import 'package:gs_ur_dart/src/registry/tron/tron_signature.dart';
import 'package:gs_ur_dart/src/utils/format.dart';
import 'package:gs_ur_dart/src/utils/uuid.dart';

class GsWalletTronSDK{
  static Map<String, dynamic> parseSignature(UR ur) {
    if (ur.type != ExtendedRegistryType.TRON_SIGNATURE.type) {
      throw ArgumentError('type not match');
    }
    final sig = TronSignature.fromCBOR(ur.cbor);
    final uuid = sig.getRequestId();
    return {
      'uuid': uuid, // == null ? null : uuidStringify(uuid),
      'signature': toHex(sig.getSignature()),
      'origin': sig.getOrigin(),
    };
  }

  static UR generateSignRequest({
    String? uuid,
    required String signData,
    required String path,
    int? fee,
    required String xfp,
    String? origin,
  }) {
    return TronSignRequest(
      uuid: uuid != null ? Uint8List.fromList(uuidParse(uuid)) : null,
      signData: fromHex(signData),   
      derivationPath: CryptoKeypath(
        components: parsePath(path).map((e) => PathComponent(index:e["index"], hardened: e["hardened"])).toList(),
        sourceFingerprint: fromHex(xfp),
      ),
      fee: fee,
      origin: origin,
    ).toUR();
  }
}