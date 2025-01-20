import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:gs_ur_dart/src/bc_ur/crc32.dart';

Uint8List sha256Hash(dynamic data) {
  if (data is String) {
    return Uint8List.fromList(sha256.convert(Uint8List.fromList(data.codeUnits)).bytes);
  } else if (data is Uint8List) {
    return Uint8List.fromList(sha256.convert(data).bytes);
  } else {
    throw ArgumentError("Invalid data type. Must be String or Uint8List.");
  }
}

List<String> partition(String s, int n) {
  return RegExp('.{1,$n}').allMatches(s).map((m) => m.group(0)!).toList();
}

List<Uint8List> split(Uint8List s, int length) {
  return [s.sublist(0, s.length - length), s.sublist(s.length - length)];
}

int getCRC(Uint8List message) {
  return CRC32.compute(message);
}

String getCRCHex(Uint8List message) {
  return getCRC(message).toRadixString(16).padLeft(8, '0');
}

int toUint32(int number) {
  return number & 0xFFFFFFFF;
}

Uint8List intToBytes(int num) {
  var byteData = ByteData(4);
  byteData.setUint32(0, num, Endian.big);  // byteOffset = 0; litteEndian = false
  return byteData.buffer.asUint8List();
}

bool isURType(String type) {
  return type.codeUnits.every((c) {
    return (c >= 'a'.codeUnitAt(0) && c <= 'z'.codeUnitAt(0)) ||
        (c >= '0'.codeUnitAt(0) && c <= '9'.codeUnitAt(0)) ||
        c == '-'.codeUnitAt(0);
  });
}

bool hasPrefix(String s, String prefix) {
  return s.startsWith(prefix);
}

bool arraysEqual(List<dynamic> ar1, List<dynamic> ar2) {
  if (ar1.length != ar2.length) {
    return false;
  }
  for (var el in ar1) {
    if (!ar2.contains(el)) {
      return false;
    }
  }
  return true;
}

/// Checks if ar1 contains all elements of ar2
/// @param ar1 the outer array
/// @param ar2 the array to be contained in ar1
bool arrayContains(List<dynamic> ar1, List<dynamic> ar2) {
  for (var el in ar2) {
    if (!ar1.contains(el)) {
      return false;
    }
  }
  return true;
}

/// Returns the difference array of  `ar1` - `ar2`
List<T> setDifference<T>(List<T> ar1, List<T> ar2) {
  return ar1.where((x) => !ar2.contains(x)).toList();
}

Uint8List bufferXOR(Uint8List a, Uint8List b) {
  var length = a.length > b.length ? a.length : b.length;
  var buffer = Uint8List(length);
  for (var i = 0; i < length; ++i) {
    buffer[i] = a[i] ^ b[i];
  }
  return buffer;
}

Uint8List bigIntListToUint8List(List<BigInt> bigIntList) {
  // 创建一个空的字节列表来存储所有的字节
  List<int> bytes = [];

  for (BigInt bigInt in bigIntList) {
    // 将 BigInt 转换为无符号的 64 位整数
    BigInt unsignedBigInt = bigInt.toUnsigned(64);

    // 将无符号的 BigInt 转换为字节列表
    List<int> byteList = unsignedBigInt.toRadixString(16).padLeft(16, '0').codeUnits;

    // 将每个字符转换为对应的字节
    for (int i = 0; i < byteList.length; i += 2) {
      int byte = int.parse(String.fromCharCode(byteList[i]) + String.fromCharCode(byteList[i + 1]), radix: 16);
      bytes.add(byte);
    }
  }

  return Uint8List.fromList(bytes);
}