import 'dart:typed_data';

import 'package:gs_ur_dart/src/bc_ur/bc_ur_dart.dart';
import 'package:gs_ur_dart/src/registry/cosmos/cosmos_sign_request.dart';
import 'package:gs_ur_dart/src/registry/cosmos/cosmos_signature.dart';
import 'package:gs_ur_dart/src/registry/crypto_key_path.dart';
import 'package:gs_ur_dart/src/registry/registry_type.dart';
import 'package:gs_ur_dart/src/utils/format.dart';
import 'package:gs_ur_dart/src/utils/uuid.dart';

class GsWalletCosmosSDK{
  static Map<String, dynamic> parseSignature(UR ur) {
    if (ur.type != ExtendedRegistryType.COSMOS_SIGNATURE.type) {
      throw ArgumentError('type not match');
    }
    final sig = CosmosSignature.fromCBOR(ur.cbor);
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
    required String chain,
    required String xfp,
    String? origin,
    int? fee,
  }) {
    return CosmosSignRequest(
      uuid: uuid != null ? Uint8List.fromList(uuidParse(uuid)) : null,
      signData: fromHex(signData),   
      derivationPath: CryptoKeypath(
        components: parsePath(path).map((e) => PathComponent(index:e["index"], hardened: e["hardened"])).toList(),
        sourceFingerprint: fromHex(xfp),
      ),
      chain: chain,
      origin: origin,
      fee: fee,
    ).toUR();
  }
}