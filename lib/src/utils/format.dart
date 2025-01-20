  
import 'dart:typed_data';

String toHex(Uint8List data, {bool addPrefix = false}) {
  final buffer = StringBuffer();
  if (addPrefix) {
    buffer.write('0x');
  }
  for (var byte in data) {
    buffer.write(byte.toRadixString(16).padLeft(2, '0'));
  }
  return buffer.toString();
}

Uint8List fromHex(String data) {
  if (data.startsWith("0x")) {
    data = data.substring(2);
  }

  if (data.length % 2 != 0) {
    throw ArgumentError("Invalid hex string: $data");
  }

  final result = Uint8List(data.length ~/ 2);

  for (int i = 0; i < data.length; i += 2) {
    result[i ~/ 2] = int.parse(data.substring(i, i + 2), radix: 16);
  }

  return result;
}