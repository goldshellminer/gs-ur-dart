import 'dart:typed_data';
import 'package:bs58check/bs58check.dart' as bs58;

Uint8List bigIntToBytes(String bigIntStr) {
  BigInt bigIntValue = BigInt.parse(bigIntStr);
  
  int byteLength = (bigIntValue.bitLength + 7) ~/ 8;
  Uint8List bytes = Uint8List(byteLength);
  
  for (int i = 0; i < byteLength; i++) {
    bytes[byteLength - 1 - i] = (bigIntValue & BigInt.from(0xFF)).toInt();
    bigIntValue >>= 8;
  }
  
  return bytes;
}

Uint8List intToUint8List(int value) {
  var byteData = ByteData(4);
  byteData.setInt32(0, value, Endian.big);
  return byteData.buffer.asUint8List();
}

String listToBase58(List<int> list) {
  return bs58.encode(Uint8List.fromList(list));
}