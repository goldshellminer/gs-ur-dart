import 'package:cbor/cbor.dart';
import 'dart:typed_data';

Uint8List cborEncode(Object? data) {
  return Uint8List.fromList(cbor.encode(CborValue(data)));
}

String cborDecode(dynamic data) {
  if (data is Uint8List) {
    CborValue cborValue = cbor.decode(data);
    return const CborJsonEncoder().convert(cborValue);
  } else if (data is String) {
    CborValue cborValue = cbor.decode(Uint8List.fromList(List<int>.generate(data.length ~/ 2, (i) => int.parse(data.substring(i * 2, i * 2 + 2), radix: 16))));
    return const CborJsonEncoder().convert(cborValue);
  } else {
    throw ArgumentError("Invalid data type. Must be Uint8List or String.");
  }
}