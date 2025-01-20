import 'dart:typed_data';

import 'package:gs_ur_dart/src/bc_ur/bc_ur_dart.dart';
import 'package:gs_ur_dart/src/registry/btc/btc_sign_request.dart';
import 'package:gs_ur_dart/src/registry/btc/btc_signature.dart';
import 'package:gs_ur_dart/src/registry/crypto_gspl.dart';
import 'package:gs_ur_dart/src/registry/crypto_key_path.dart';
import 'package:gs_ur_dart/src/registry/crypto_tx_element.dart';
import 'package:gs_ur_dart/src/registry/registry_type.dart';
import 'package:gs_ur_dart/src/utils/format.dart';
import 'package:gs_ur_dart/src/utils/uuid.dart';

class GsWalletBTCSDK{
  static Map<String, dynamic> parseSignature(UR ur) {
    if (ur.type != ExtendedRegistryType.BTC_SIGNATURE.type) {
      throw ArgumentError('type not match');
    }
    final sig = BtcSignature.fromCBOR(ur.cbor);
    final uuid = sig.getRequestId();
    return {
      'uuid': uuid, // == null ? null : uuidStringify(uuid),
      'gspl': sig.getGspl(),
      'origin': sig.getOrigin(),
    };
  }

  static UR generateSignRequest({
    String? uuid,
    required String hexData,
    required GsplDataType dataType,
    List<Map<String, dynamic>>? inputs,
    Map<String, dynamic>? change,
    required String path,
    required String xfp,
    String? origin,
  }) {
    return BtcSignRequest(
      uuid: uuid != null ? Uint8List.fromList(uuidParse(uuid)) : null,
      gspl: CryptoGspl(data: fromHex(hexData), dataType: dataType, 
      inputs: inputs?.map((e) => parseTxElement(e)).toList(),
      change: change != null ? parseTxElement(change): null,
      ),
      derivationPath: CryptoKeypath(
        components: parsePath(path).map((e) => PathComponent(index:e["index"], hardened: e["hardened"])).toList(),
        sourceFingerprint: fromHex(xfp),
      ),
      origin: origin,
    ).toUR();
  }
}