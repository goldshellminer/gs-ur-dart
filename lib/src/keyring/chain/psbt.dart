import 'dart:typed_data';

import 'package:gs_ur_dart/src/bc_ur/bc_ur_dart.dart';
import 'package:gs_ur_dart/src/registry/btc/btc_inscribe_request.dart';
import 'package:gs_ur_dart/src/registry/btc/btc_inscribe_signature.dart';
import 'package:gs_ur_dart/src/registry/btc/psbt_sign_request.dart';
import 'package:gs_ur_dart/src/registry/btc/psbt_signature.dart';
import 'package:gs_ur_dart/src/registry/crypto_key_path.dart';
import 'package:gs_ur_dart/src/registry/registry_type.dart';
import 'package:gs_ur_dart/src/utils/format.dart';
import 'package:gs_ur_dart/src/utils/uuid.dart';

class GsWalletPsbtSDK{
  static Map<String, dynamic> parseSignature(UR ur) {
    if (ur.type != ExtendedRegistryType.PSBT_SIGNATURE.type) {
      throw ArgumentError('type not match');
    }
    final sig = PsbtSignature.fromCBOR(ur.cbor);
    final uuid = sig.getRequestId();
    return {
      'uuid': uuid, // == null ? null : uuidStringify(uuid),
      'psbt': toHex(sig.getSignature()),
      'origin': sig.getOrigin(),
    };
  }

  static UR generateSignRequest({
    String? uuid,
    required String psbt,
    required String path,
    required String xfp,
    String? origin,
  }) {
    return PsbtSignRequest(
      uuid: uuid != null ? Uint8List.fromList(uuidParse(uuid)) : null,
      psbt: fromHex(psbt),   
      derivationPath: CryptoKeypath(
        components: parsePath(path).map((e) => PathComponent(index:e["index"], hardened: e["hardened"])).toList(),
        sourceFingerprint: fromHex(xfp),
      ),
      origin: origin,
    ).toUR();
  }

  static Map<String, dynamic> parseInscribeSignature(UR ur) {
    if (ur.type != ExtendedRegistryType.BTC_INSCRIBE_SIGNATURE.type) {
      throw ArgumentError('type not match');
    }
    final sig = BtcInscribeSignature.fromCBOR(ur.cbor);
    final uuid = sig.getRequestId();
    return {
      'uuid': uuid == null ? null : uuidStringify(uuid),
      'commitSignature': toHex(sig.getCommitSignature()),
      'revealSignature': toHex(sig.getRevealSignature()),
      'origin': sig.getOrigin(),
    };
  }

  static UR generateInscribeRequest({
    String? uuid,
    required String commitData,
    required String revealData,
    String? origin,
  }) {
    return BtcInscribeRequest(
      uuid: uuid != null ? Uint8List.fromList(uuidParse(uuid)): null,
      commitData: fromHex(commitData),   
      revealData: fromHex(revealData),   
      origin: origin,
    ).toUR();
  }
}