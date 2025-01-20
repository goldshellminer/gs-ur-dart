import 'dart:convert';
import 'dart:typed_data';

import 'package:gs_ur_dart/src/bc_ur/alias_sampling.dart';
import 'package:gs_ur_dart/src/bc_ur/fountain_encoder.dart';
import 'package:gs_ur_dart/src/bc_ur/fountain_utils.dart';
import 'package:gs_ur_dart/src/bc_ur/utils.dart';
import 'package:gs_ur_dart/src/bc_ur/xoshiro.dart';
import 'package:flutter_test/flutter_test.dart';


import 'utils.dart';


void main() {
  group('Xoshiro rng', () {
    test('1', () {
      final rng = Xoshiro(Uint8List.fromList(utf8.encode('Wolf')));
      final numbers = List.generate(100, (_) => (rng.next() % BigInt.from(100)).toInt());
      final expectedNumbers = [42, 81, 85, 8, 82, 84, 76, 73, 70, 88, 2, 74, 40, 48, 77, 54, 88, 7, 5, 88, 37, 25, 82, 13, 69, 59, 30, 39, 11, 82, 19, 99, 45, 87, 30, 15, 32, 22, 89, 44, 92, 77, 29, 78, 4, 92, 44, 68, 92, 69, 1, 42, 89, 50, 37, 84, 63, 34, 32, 3, 17, 62, 40, 98, 82, 89, 24, 43, 85, 39, 15, 3, 99, 29, 20, 42, 27, 10, 85, 66, 50, 35, 69, 70, 70, 74, 30, 13, 72, 54, 11, 5, 70, 55, 91, 52, 10, 43, 43, 52];

      expect(numbers, equals(expectedNumbers));
    });

    test('2', () {
      final checksum = intToBytes(getCRC(Uint8List.fromList(utf8.encode('Wolf'))));
      final rng = Xoshiro(checksum);
      final numbers = List.generate(100, (_) => (rng.next() % BigInt.from(100)).toInt());
      final expectedNumbers = [88, 44, 94, 74, 0, 99, 7, 77, 68, 35, 47, 78, 19, 21, 50, 15, 42, 36, 91, 11, 85, 39, 64, 22, 57, 11, 25, 12, 1, 91, 17, 75, 29, 47, 88, 11, 68, 58, 27, 65, 21, 54, 47, 54, 73, 83, 23, 58, 75, 27, 26, 15, 60, 36, 30, 21, 55, 57, 77, 76, 75, 47, 53, 76, 9, 91, 14, 69, 3, 95, 11, 73, 20, 99, 68, 61, 3, 98, 36, 98, 56, 65, 14, 80, 74, 57, 63, 68, 51, 56, 24, 39, 53, 80, 57, 51, 81, 3, 1, 30];

      expect(numbers, equals(expectedNumbers));
    });

    test('3', () {
      final rng = Xoshiro(Uint8List.fromList(utf8.encode('Wolf')));
      final numbers = List.generate(100, (_) => rng.nextInt(1, 10));
      final expectedNumbers = [6, 5, 8, 4, 10, 5, 7, 10, 4, 9, 10, 9, 7, 7, 1, 1, 2, 9, 9, 2, 6, 4, 5, 7, 8, 5, 4, 2, 3, 8, 7, 4, 5, 1, 10, 9, 3, 10, 2, 6, 8, 5, 7, 9, 3, 1, 5, 2, 7, 1, 4, 4, 4, 4, 9, 4, 5, 5, 6, 9, 5, 1, 2, 8, 3, 3, 2, 8, 4, 3, 2, 1, 10, 8, 9, 3, 10, 8, 5, 5, 6, 7, 10, 5, 8, 9, 4, 6, 4, 2, 10, 2, 1, 7, 9, 6, 7, 4, 2, 5];

      expect(numbers, equals(expectedNumbers));
    });
  });

  group('Shuffle', () {
    test('random shuffle', () {
      final rng = Xoshiro(Uint8List.fromList(utf8.encode('Wolf')));
      final values = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

      final result = List.generate(10, (_) => shuffle(values, rng));
      final expectedResult = [
        [6, 4, 9, 3, 10, 5, 7, 8, 1, 2],
        [10, 8, 6, 5, 1, 2, 3, 9, 7, 4],
        [6, 4, 5, 8, 9, 3, 2, 1, 7, 10],
        [7, 3, 5, 1, 10, 9, 4, 8, 2, 6],
        [8, 5, 7, 10, 2, 1, 4, 3, 9, 6],
        [4, 3, 5, 6, 10, 2, 7, 8, 9, 1],
        [5, 1, 3, 9, 4, 6, 2, 10, 7, 8],
        [2, 1, 10, 8, 9, 4, 7, 6, 3, 5],
        [6, 7, 10, 4, 8, 9, 2, 3, 1, 5],
        [10, 2, 1, 7, 9, 5, 6, 3, 4, 8]
      ];

      expect(result, equals(expectedResult));
    });
  });

  group('Random Sampler', () {
    test('random sampler', () {
      final rng = Xoshiro(Uint8List.fromList(utf8.encode('Wolf')));
      final sampler = Sampler([1, 2, 4, 8], null, rng);

      final samples = List.generate(500, (_) => sampler.next());
      final expectedSamples = [3, 3, 3, 3, 3, 3, 3, 0, 2, 3, 3, 3, 3, 1, 2, 2, 1, 3, 3, 2, 3, 3, 1, 1, 2, 1, 1, 3, 1, 3, 1, 2, 0, 2, 1, 0, 3, 3, 3, 1, 3, 3, 3, 3, 1, 3, 2, 3, 2, 2, 3, 3, 3, 3, 2, 3, 3, 0, 3, 3, 3, 3, 1, 2, 3, 3, 2, 2, 2, 1, 2, 2, 1, 2, 3, 1, 3, 0, 3, 2, 3, 3, 3, 3, 3, 3, 3, 3, 2, 3, 1, 3, 3, 2, 0, 2, 2, 3, 1, 1, 2, 3, 2, 3, 3, 3, 3, 2, 3, 3, 3, 3, 3, 2, 3, 1, 2, 1, 1, 3, 1, 3, 2, 2, 3, 3, 3, 1, 3, 3, 3, 3, 3, 3, 3, 3, 2, 3, 2, 3, 3, 1, 2, 3, 3, 1, 3, 2, 3, 3, 3, 2, 3, 1, 3, 0, 3, 2, 1, 1, 3, 1, 3, 2, 3, 3, 3, 3, 2, 0, 3, 3, 1, 3, 0, 2, 1, 3, 3, 1, 1, 3, 1, 2, 3, 3, 3, 0, 2, 3, 2, 0, 1, 3, 3, 3, 2, 2, 2, 3, 3, 3, 3, 3, 2, 3, 3, 3, 3, 2, 3, 3, 2, 0, 2, 3, 3, 3, 3, 2, 1, 1, 1, 2, 1, 3, 3, 3, 2, 2, 3, 3, 1, 2, 3, 0, 3, 2, 3, 3, 3, 3, 0, 2, 2, 3, 2, 2, 3, 3, 3, 3, 1, 3, 2, 3, 3, 3, 3, 3, 2, 2, 3, 1, 3, 0, 2, 1, 3, 3, 3, 3, 3, 3, 3, 3, 1, 3, 3, 3, 3, 2, 2, 2, 3, 1, 1, 3, 2, 2, 0, 3, 2, 1, 2, 1, 0, 3, 3, 3, 2, 2, 3, 2, 1, 2, 0, 0, 3, 3, 2, 3, 3, 2, 3, 3, 3, 3, 3, 2, 2, 2, 3, 3, 3, 3, 3, 1, 1, 3, 2, 2, 3, 1, 1, 0, 1, 3, 2, 3, 3, 2, 3, 3, 2, 3, 3, 2, 2, 2, 2, 3, 2, 2, 2, 2, 2, 1, 2, 3, 3, 2, 2, 2, 2, 3, 3, 2, 0, 2, 1, 3, 3, 3, 3, 0, 3, 3, 3, 3, 2, 2, 3, 1, 3, 3, 3, 2, 3, 3, 3, 2, 3, 3, 3, 3, 2, 3, 2, 1, 3, 3, 3, 3, 2, 2, 0, 1, 2, 3, 2, 0, 3, 3, 3, 3, 3, 3, 1, 3, 3, 2, 3, 2, 2, 3, 3, 3, 3, 3, 2, 2, 3, 3, 2, 2, 2, 1, 3, 3, 3, 3, 1, 2, 3, 2, 3, 3, 2, 3, 2, 3, 3, 3, 2, 3, 1, 2, 3, 2, 1, 1, 3, 3, 2, 3, 3, 2, 3, 3, 0, 0, 1, 3, 3, 2, 3, 3, 3, 3, 1, 3, 3, 0, 3, 2, 3, 3, 1, 3, 3, 3, 3, 3, 3, 3, 0, 3, 3, 2];

      expect(samples, equals(expectedSamples));
    });
  });

  group('Degree', () {
    test('choose degree', () {
      final message = makeMessage(1024);
      final fragmentLength = FountainEncoder.findNominalFragmentLength(message.length, 10, 100);
      final fragments = FountainEncoder.partitionMessage(message, fragmentLength);

      final degrees = List.generate(200, (index) {
        final rng = Xoshiro(Uint8List.fromList(utf8.encode('Wolf-${index + 1}')));
        return chooseDegree(fragments.length, rng);
      });
      final expectedDegrees = [11, 3, 6, 5, 2, 1, 2, 11, 1, 3, 9, 10, 10, 4, 2, 1, 1, 2, 1, 1, 5, 2, 4, 10, 3, 2, 1, 1, 3, 11, 2, 6, 2, 9, 9, 2, 6, 7, 2, 5, 2, 4, 3, 1, 6, 11, 2, 11, 3, 1, 6, 3, 1, 4, 5, 3, 6, 1, 1, 3, 1, 2, 2, 1, 4, 5, 1, 1, 9, 1, 1, 6, 4, 1, 5, 1, 2, 2, 3, 1, 1, 5, 2, 6, 1, 7, 11, 1, 8, 1, 5, 1, 1, 2, 2, 6, 4, 10, 1, 2, 5, 5, 5, 1, 1, 4, 1, 1, 1, 3, 5, 5, 5, 1, 4, 3, 3, 5, 1, 11, 3, 2, 8, 1, 2, 1, 1, 4, 5, 2, 1, 1, 1, 5, 6, 11, 10, 7, 4, 7, 1, 5, 3, 1, 1, 9, 1, 2, 5, 5, 2, 2, 3, 10, 1, 3, 2, 3, 3, 1, 1, 2, 1, 3, 2, 2, 1, 3, 8, 4, 1, 11, 6, 3, 1, 1, 1, 1, 1, 3, 1, 2, 1, 10, 1, 1, 8, 2, 7, 1, 2, 1, 9, 2, 10, 2, 1, 3, 4, 10];

      expect(degrees, equals(expectedDegrees));
    });
  });

   group('Fragments', () {
    test('choose fragments', () {
      final message = makeMessage(1024);
      final checksum = getCRC(message);
      final fragmentLength = FountainEncoder.findNominalFragmentLength(message.length, 10, 100);
      final fragments = FountainEncoder.partitionMessage(message, fragmentLength);

      final fragmentIndexes = List.generate(30, (index) {
        return chooseFragments(index + 1, fragments.length, checksum)..sort();
      });
      final expectedDegrees = [
        [0],
        [1],
        [2],
        [3],
        [4],
        [5],
        [6],
        [7],
        [8],
        [9],
        [10],
        [9],
        [2, 5, 6, 8, 9, 10],
        [8],
        [1, 5],
        [1],
        [0, 2, 4, 5, 8, 10],
        [5],
        [2],
        [2],
        [0, 1, 3, 4, 5, 7, 9, 10],
        [0, 1, 2, 3, 5, 6, 8, 9, 10],
        [0, 2, 4, 5, 7, 8, 9, 10],
        [3, 5],
        [4],
        [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
        [0, 1, 3, 4, 5, 6, 7, 9, 10],
        [6],
        [5, 6],
        [7]
      ];

      expect(fragmentIndexes, equals(expectedDegrees));
    });
  });

  group('XOR', () {
    test('test xor', () {
      final rng = Xoshiro(Uint8List.fromList(utf8.encode('Wolf')));
      final data1 = rng.nextData(10);

      expect(data1, equals(Uint8List.fromList([0x91, 0x6e, 0xc6, 0x5c, 0xf7, 0x7c, 0xad, 0xf5, 0x5c, 0xd7])));

      final data2 = rng.nextData(10);

      expect(data2, equals(Uint8List.fromList([0xf9, 0xcd, 0xa1, 0xa1, 0x03, 0x00, 0x26, 0xdd, 0xd4, 0x2e])));

      var data3 = Uint8List.fromList(data1);

      data3 = bufferXOR(data3, Uint8List.fromList(data2));

      expect(data3, equals(Uint8List.fromList([0x68, 0xa3, 0x67, 0xfd, 0xf4, 0x7c, 0x8b, 0x28, 0x88, 0xf9])));

      data3 = bufferXOR(data3, Uint8List.fromList(data1));

      expect(data3, equals(data2));
    });
  });
}