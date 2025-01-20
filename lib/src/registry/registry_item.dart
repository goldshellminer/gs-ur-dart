import 'dart:typed_data';

import 'package:cbor/cbor.dart';
import 'package:gs_ur_dart/src/bc_ur/bc_ur_dart.dart';
import 'package:gs_ur_dart/src/registry/registry_type.dart';

abstract class RegistryItem {
  RegistryType getRegistryType();
  CborValue? toCborValue();
  Uint8List toCBOR(){
    if (toCborValue() == null) {
      throw "#[ur-registry][RegistryItem][fn.toCBOR]: registry ${getRegistryType()}'s method toCborValue returns undefined";
    }
    return Uint8List.fromList(cbor.encode(toCborValue()!));
  }

  UR toUR(){
    return UR(toCBOR(), getRegistryType().type);
  }

  toUREncoder(
    int? maxFragmentLength,
    int? firstSeqNum,
    int? minFragmentLength,
  ){
    UR ur = toUR();
    UREncoder urEncoder = UREncoder(
      ur,
      maxFragmentLength: maxFragmentLength,
      firstSeqNum: firstSeqNum,
      minFragmentLength: minFragmentLength,
    );
    return urEncoder;
  }
}
