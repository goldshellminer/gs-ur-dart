import 'dart:typed_data';

import 'package:gs_ur_dart/src/bc_ur/bc_ur_dart.dart';
import 'package:gs_ur_dart/src/registry/crypto_key_path.dart';
import 'package:gs_ur_dart/src/registry/eth/eth_sign_request.dart';
import 'package:gs_ur_dart/src/registry/eth/eth_signature.dart';
import 'package:gs_ur_dart/src/registry/registry_type.dart';
import 'package:gs_ur_dart/src/utils/format.dart';
import 'package:gs_ur_dart/src/utils/uuid.dart';

class GsWalletEthereumSDK{
  static Map<String, dynamic> parseSignature(UR ur) {
    if (ur.type != ExtendedRegistryType.ETH_SIGNATURE.type) {
      throw ArgumentError('type not match');
    }
    final sig = EthSignature.fromCBOR(ur.cbor);
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
    required EthDataType dataType,
    required String path,
    required String xfp,
    required int chainId,
    String? address,
    String? origin,
  }) {
    return EthSignRequest(
      uuid: uuid != null ? Uint8List.fromList(uuidParse(uuid)) : null,
      signData: fromHex(signData),   
      dataType: dataType,
      derivationPath: CryptoKeypath(
        components: parsePath(path).map((e) => PathComponent(index:e["index"], hardened: e["hardened"])).toList(),
        sourceFingerprint: fromHex(xfp),
      ),
      chainId: chainId,
      address: address != null ? fromHex(address) : null,
      origin: origin,
    ).toUR();
  }
}