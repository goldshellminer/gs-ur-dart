import 'dart:typed_data';

import 'package:gs_ur_dart/src/bc_ur/bc_ur_dart.dart';
import 'package:gs_ur_dart/src/registry/alph/alph_sign_request.dart';
import 'package:gs_ur_dart/src/registry/alph/alph_signature.dart';
import 'package:gs_ur_dart/src/registry/crypto_gspl.dart';
import 'package:gs_ur_dart/src/registry/crypto_key_path.dart';
import 'package:gs_ur_dart/src/registry/crypto_tx_entity.dart';
import 'package:gs_ur_dart/src/registry/registry_type.dart';
import 'package:gs_ur_dart/src/utils/format.dart';
import 'package:gs_ur_dart/src/utils/uuid.dart';


class GsWalletAlphSDK{
  static Map<String, dynamic> parseSignature(UR ur) {
    if (ur.type != ExtendedRegistryType.ALPH_SIGNATURE.type) {
      throw ArgumentError('type not match');
    }
    final sig = AlphSignature.fromCBOR(ur.cbor);
    final uuid = sig.getRequestId();
    return {
      'uuid': uuid, // == null ? null : uuidStringify(uuid),
      'signature': sig.getSignature(),
      'origin': sig.getOrigin(),
    };
  }

  static UR generateSignRequest({
    String? uuid,
    required String hexData,
    required GsplDataType dataType,
    List<Map<String, dynamic>>? outputs,
    required String path,
    required String xfp,
    String? origin,
  }) {
    return AlphSignRequest(
      uuid: uuid != null ? Uint8List.fromList(uuidParse(uuid)) : null,
      data: fromHex(hexData), 
      outputs: outputs?.map((e) => parseTxEntity(e)).toList(),
      derivationPath: CryptoKeypath(
        components: parsePath(path).map((e) => PathComponent(index:e["index"], hardened: e["hardened"])).toList(),
        sourceFingerprint: fromHex(xfp),
      ),
      origin: origin,
    ).toUR();
  }
}