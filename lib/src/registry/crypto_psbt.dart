import 'dart:typed_data';
import 'package:cbor/cbor.dart';
import 'package:gs_ur_dart/src/registry/registry_item.dart';
import 'package:gs_ur_dart/src/registry/registry_type.dart';


class CryptoPsbt  extends RegistryItem{
  Uint8List data;

  CryptoPsbt({required this.data, });

  @override
  RegistryType getRegistryType() {
    return RegistryType.CRYPTO_PSBT;
  }

  @override
  CborValue toCborValue() {
    return CborBytes(data, tags: [RegistryType.CRYPTO_PSBT.tag]);
  }

  static CryptoPsbt fromCBOR(Uint8List cborPayload) {
    CborValue cborValue = cbor.decode(cborPayload);
    return CryptoPsbt(data: Uint8List.fromList((cborValue as CborBytes).bytes));
  }
}
