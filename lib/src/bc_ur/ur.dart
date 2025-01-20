import 'dart:convert';
import 'dart:typed_data';

import 'errors.dart';
import 'utils.dart';
import 'cbor.dart';

class UR {
  final Uint8List _cborPayload;
  final String _type;

  UR(this._cborPayload, [this._type = 'bytes']) {
    if (!isURType(_type)) {
      throw InvalidTypeError();
    }
  }


  // factory UR.fromBuffer(Object? buf) {
  //   return UR(cborEncode(buf));
  // }

  factory UR.from(dynamic value, {Function? encoding}) {
    if(value is String) return UR(cborEncode(jsonDecode(value)));
    if(encoding == null && value is Object) return UR(cborEncode(value));
    if(encoding != null) return UR(encoding(value));
    return UR(Uint8List.fromList(value.toString().codeUnits));
  }

  String decodeCBOR() {
    return cborDecode(_cborPayload);
  }

  String get type => _type;
  Uint8List get cbor => _cborPayload;

  bool equals(UR ur2) {
    return type == ur2.type &&
        arraysEqual(cbor, ur2.cbor);
  }

bool arraysEqual(List a, List b) {
  if (a.length != b.length) return false;
  return a.every((e) => b.contains(e));
}
}
