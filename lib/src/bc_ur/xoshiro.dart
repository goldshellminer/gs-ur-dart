import 'dart:core';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:rational/rational.dart';

BigInt maxUint64 = BigInt.from(0xFFFFFFFFFFFFFFFF);
// BigInt maxUint64 = BigInt.parse("18446744073709551616");

BigInt rotl(BigInt x, int k) {
  return ((x << k).toUnsigned(64))  ^ ((x >> (BigInt.from(64) - BigInt.from(k)).toInt()).toUnsigned(64));
}

class Xoshiro{
  late List<BigInt> s;

  Xoshiro(Uint8List seed) {
    final digest = sha256.convert(seed).bytes;
    s = List.generate(4, (_) => BigInt.from(0));
    setS(Uint8List.fromList(digest));
  }

  void setS(Uint8List digest) {
    for (var i = 0; i < 4; i++) {
      var o = i * 8;
      var v = BigInt.from(0);
      for (var n = 0; n < 8; n++) {
        v = (v << 8).toUnsigned(64);
        v = v | BigInt.from(digest[o + n]);
      }
      s[i] = v.toUnsigned(64);
    }
  }

  BigInt roll() {
    final result = (rotl((s[1] * BigInt.from(5)).toUnsigned(64), 7) * BigInt.from(9)).toUnsigned(64);
    // print("roll 111 $result");

    final t = (s[1] << 17).toUnsigned(64);

    s[2] ^= s[0];
    s[3] ^= s[1];
    s[1] ^= s[2];
    s[0] ^= s[3];

    s[2] ^= t;

    s[3] = rotl(s[3], 45);

    return result;
  }

  BigInt next() {
    return roll();
  }

  double nextDouble() {
    return (Rational(roll(),BigInt.parse("18446744073709551617"))).toDouble();
  }

  int nextInt(int low, int high) {
    // return ((roll() * BigInt.from(high - low + 1)) / (maxUint64 + BigInt.from(1))).floor() + low;
    return (nextDouble() * (high - low + 1)).floor() + low;
  }

  int nextByte() {
    return nextInt(0, 255);
  }

  List<int> nextData(int count) {
    return List.generate(count, (_) => nextByte());
  }
}
