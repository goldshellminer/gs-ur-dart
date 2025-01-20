import 'dart:typed_data';

import 'ur.dart';
import 'package:hex/hex.dart';
import 'fountain_encoder.dart';
import 'bytewords.dart' as bytewords;

class UREncoder {
  final UR ur;
  final FountainEncoder fountainEncoder;

  UREncoder(
    this.ur, {
    int? maxFragmentLength,
    int? firstSeqNum,
    int? minFragmentLength,
  }) : fountainEncoder = FountainEncoder(
          message: ur.cbor,
          maxFragmentLength: maxFragmentLength ?? 100,
          firstSeqNum: firstSeqNum ?? 0,
          minFragmentLength: minFragmentLength ?? 10,
        );

  int get fragmentsLength => fountainEncoder.fragmentsLength;
  List<Uint8List> get fragments => fountainEncoder.fragments;
  int get messageLength => fountainEncoder.messageLength;
  Uint8List get cbor => ur.cbor;

  List<String> encodeWhole() {
    return List.generate(fragmentsLength, (_) => nextPart());
  }

  String nextPart() {
    final part = fountainEncoder.nextPart();

    if (fountainEncoder.isSinglePart()) {
      return encodeSinglePart(ur);
    } else {
      return encodePart(ur.type, part);
    }
  }

  static String encodeUri(String scheme, List<String> pathComponents) {
    final path = pathComponents.join('/');
    return '$scheme:$path';
  }

  static String encodeUR(List<String> pathComponents) {
    return encodeUri('ur', pathComponents);
  }

  static String encodePart(String type, FountainEncoderPart part) {
    final seq = '${part.seqNum}-${part.seqLength}';
    final body = bytewords.encode(
        HEX.encode(part.cbor()), style: bytewords.Styles.minimal);

    return encodeUR([type, seq, body]);
  }

  static String encodeSinglePart(UR ur) {
    final body =
        bytewords.encode(HEX.encode(ur.cbor), style: bytewords.Styles.minimal);

    return encodeUR([ur.type, body]);
  }
}
