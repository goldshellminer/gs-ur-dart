import 'dart:typed_data';

import 'package:gs_ur_dart/src/bc_ur/bc_ur_dart.dart';
import 'package:gs_ur_dart/src/registry/crypto_key_path.dart';
import 'package:gs_ur_dart/src/registry/registry_type.dart';
import 'package:gs_ur_dart/src/registry/sol/sol_sign_request.dart';
import 'package:gs_ur_dart/src/registry/sol/sol_signature.dart';
import 'package:gs_ur_dart/src/utils/format.dart';
import 'package:gs_ur_dart/src/utils/uuid.dart';

class GsWalletSolSDK{
  static Map<String, dynamic> parseSignature(UR ur) {
    if (ur.type != ExtendedRegistryType.SOL_SIGNATURE.type) {
      throw ArgumentError('type not match');
    }
    final sig = SolSignature.fromCBOR(ur.cbor);
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
    required SignType signType,
    required String path,
    required String xfp,
    String? outputAddress,
    String? contractAddress,
    String? origin,
    int? fee,
  }) {
    return SolSignRequest(
      uuid: uuid != null ? Uint8List.fromList(uuidParse(uuid)) : null,
      signData: fromHex(signData),   
      signType: signType,
      derivationPath: CryptoKeypath(
        components: parsePath(path).map((e) => PathComponent(index:e["index"], hardened: e["hardened"])).toList(),
        sourceFingerprint: fromHex(xfp),
      ),
      outputAddress: outputAddress,
      contractAddress: contractAddress,
      origin: origin,
      fee: fee,
    ).toUR();
  }
}