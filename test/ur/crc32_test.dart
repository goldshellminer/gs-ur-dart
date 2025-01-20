import 'dart:convert';
import 'dart:typed_data';

import 'package:gs_ur_dart/src/bc_ur/utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hex/hex.dart';


void main() {
  group('CRC32', () {
    test('crc32 results', () {
      expect(getCRCHex(Uint8List.fromList(utf8.encode('Hello, world!'))),'ebe6c6e6');
      expect(getCRCHex(Uint8List.fromList(utf8.encode('Wolf'))),'598c84dc');
      expect(getCRCHex(Uint8List.fromList(HEX.decode('d9012ca20150c7098580125e2ab0981253468b2dbc5202d8641947da'))),'d22c52b6');
    });
  });
}
