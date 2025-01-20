import 'dart:typed_data';
import 'package:gs_ur_dart/src/bc_ur/errors.dart';
import 'package:gs_ur_dart/src/bc_ur/fountain_decoder.dart';
import 'package:gs_ur_dart/src/bc_ur/fountain_encoder.dart';
import 'package:gs_ur_dart/src/bc_ur/ur.dart';
import 'package:gs_ur_dart/src/bc_ur/utils.dart';
import 'package:hex/hex.dart';


import 'bytewords.dart' as bytewords;

// class InvalidSchemeError implements Exception {}

class URDecoder {
  late String expectedType;
  UR? result;
  Error? error;
  final FountainDecoder fountainDecoder;
  final String type;

  URDecoder({FountainDecoder? fountainDecoder, this.type = 'bytes'})
      : fountainDecoder = fountainDecoder ?? FountainDecoder() {
    assert(isURType(type), 'Invalid UR type');
    expectedType = '';
  }

  static UR decodeBody(String type, String message) {
    final cbor = bytewords.decode(message, style: bytewords.Styles.minimal);
    return UR(Uint8List.fromList(HEX.decode(cbor)), type);
  }

  bool validatePart(String type) {
    if (expectedType.isNotEmpty) {
      return expectedType == type;
    }

    if (!isURType(type)) {
      return false;
    }

    expectedType = type;
    return true;
  }

  static UR decode(String message) {
    final components = parse(message);
    if (components[1].isEmpty) {
      throw InvalidPathLengthError();
    }

    final body = components[1][0];
    return decodeBody(components[0], body);
  }

  static List parse(String message) {
    final lowercase = message.toLowerCase();
    final prefix = lowercase.substring(0, 3);

    if (prefix != 'ur:') {
      throw InvalidSchemeError();
    }

    final components = lowercase.substring(3).split('/');
    final type = components[0];

    if (components.length < 2) {
      throw InvalidPathLengthError();
    }

    if (!isURType(type)) {
      throw InvalidTypeError();
    }

    return [type, components.sublist(1)];
  }

  static List<int> parseSequenceComponent(String s) {
    final components = s.split('-');
    if (components.length != 2) {
      throw InvalidSequenceComponentError();
    }

    final seqNum = toUint32(int.parse(components[0]));
    final seqLength = int.parse(components[1]);

    if (seqNum < 1 || seqLength < 1) {
      throw InvalidSequenceComponentError();
    }

    return [seqNum, seqLength];
  }

  bool receivePart(String s) {
    if (result != null) {
      return false;
    }

    final components = parse(s);

    if (!validatePart(components[0])) {
      return false;
    }

    if (components[1].length == 1) {
      result = decodeBody(components[0], components[1][0]);
      return true;
    }

    if (components[1].length != 2) {
      throw InvalidPathLengthError();
    }

    final seq = components[1][0];
    final fragment = components[1][1];
    final seqComponents = parseSequenceComponent(seq);
    final cbor = bytewords.decode(fragment, style: bytewords.Styles.minimal);
    final part = FountainEncoderPart.fromCBOR(cbor);

    if (seqComponents[0] != part.seqNum || seqComponents[1] != part.seqLength) {
      return false;
    }

    if (!fountainDecoder.receivePart(part)) {
      return false;
    }

    if (fountainDecoder.isSuccess()) {
      result = UR(fountainDecoder.resultMessage(), components[0]);
    } else if (fountainDecoder.isFailure()) {
      error = InvalidSchemeError();
    }

    return true;
  }

  UR resultUR() => result ?? UR(Uint8List(0), type);

  bool isComplete() => result != null && result!.cbor.isNotEmpty;

  bool isSuccess() => error == null && isComplete();

  bool isError() => error != null;

  String resultError() => error?.toString() ?? '';

  int expectedPartCount() => fountainDecoder.expectedPartCount();

  List<int> expectedPartIndexes() => fountainDecoder.getExpectedPartIndexes();

  List<int> receivedPartIndexes() => fountainDecoder.getReceivedPartIndexes();

  List<int> lastPartIndexes() => fountainDecoder.getLastPartIndexes();

  double estimatedPercentComplete() => fountainDecoder.estimatedPercentComplete();

  double getProgress() => fountainDecoder.getProgress();
}
