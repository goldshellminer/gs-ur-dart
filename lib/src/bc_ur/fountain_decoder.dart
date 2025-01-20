import 'dart:typed_data';

import 'package:gs_ur_dart/src/bc_ur/errors.dart';
import 'package:gs_ur_dart/src/bc_ur/fountain_encoder.dart';
import 'package:gs_ur_dart/src/bc_ur/fountain_utils.dart';
import 'package:gs_ur_dart/src/bc_ur/utils.dart';

class FountainDecoderPart {
  final List<int> _indexes;
  final Uint8List _fragment;

  FountainDecoderPart(this._indexes, this._fragment);

  List<int> get indexes => _indexes;
  Uint8List get fragment => _fragment;

  static FountainDecoderPart fromEncoderPart(FountainEncoderPart encoderPart) {
    final indexes = chooseFragments(encoderPart.seqNum, encoderPart.seqLength, encoderPart.checksum);
    final fragment = encoderPart.fragment;
    return FountainDecoderPart(indexes, fragment);
  }

  bool isSimple() {
    return indexes.length == 1;
  }
}

typedef PartIndexes = List<int>;

class PartDict {
  final PartIndexes key;
  final FountainDecoderPart value;

  PartDict(this.key, this.value);
}

class FountainDecoder {
  Error? error;
  Uint8List? result;
  int expectedMessageLength = 0;
  int expectedChecksum = 0;
  int expectedFragmentLength = 0;
  int processedPartsCount = 0;
  PartIndexes expectedPartIndexes = [];
  PartIndexes lastPartIndexes = [];
  List<FountainDecoderPart> queuedParts = [];
  PartIndexes receivedPartIndexes = [];
  List<PartDict> mixedParts = [];
  List<PartDict> simpleParts = [];

  bool validatePart(FountainEncoderPart part) {
    if (expectedPartIndexes.isEmpty) {
      expectedPartIndexes = List.generate(part.seqLength, (index) => index);
      expectedMessageLength = part.messageLength;
      expectedChecksum = part.checksum;
      expectedFragmentLength = part.fragment.length;
    } else {
      if (expectedPartIndexes.length != part.seqLength ||
          expectedMessageLength != part.messageLength ||
          expectedChecksum != part.checksum ||
          expectedFragmentLength != part.fragment.length) {
        return false;
      }
    }
    return true;
  }

  FountainDecoderPart reducePartByPart(FountainDecoderPart a, FountainDecoderPart b) {
    if (arrayContains(a.indexes, b.indexes)) {
      final newIndexes = setDifference(a.indexes, b.indexes);
      final newFragment = bufferXOR(a.fragment, b.fragment);
      return FountainDecoderPart(newIndexes, newFragment);
    } else {
      return a;
    }
  }

  void reduceMixedBy(FountainDecoderPart part) {
    final newMixed = <PartDict>[];

    for (var mixedPart in mixedParts) {
      final reducedPart = reducePartByPart(mixedPart.value, part);
      if (reducedPart.isSimple()) {
        queuedParts.add(reducedPart);
      } else {
        newMixed.add(PartDict(reducedPart.indexes, reducedPart));
      }
    }

    mixedParts = newMixed;
  }

  void processSimplePart(FountainDecoderPart part) {
    final fragmentIndex = part.indexes[0];

    if (receivedPartIndexes.contains(fragmentIndex)) {
      return;
    }

    simpleParts.add(PartDict(part.indexes, part));
    receivedPartIndexes.add(fragmentIndex);

    if (arraysEqual(receivedPartIndexes, expectedPartIndexes)) {
      final sortedParts = simpleParts.map((e) => e.value).toList()
        ..sort((a, b) => a.indexes[0].compareTo(b.indexes[0]));
      final message = joinFragments(sortedParts.map((e) => e.fragment).toList(), expectedMessageLength);
      final checksum = getCRC(message);

      if (checksum == expectedChecksum) {
        result = message;
      } else {
        error = InvalidChecksumError();
      }
    } else {
      reduceMixedBy(part);
    }
  }

  void processMixedPart(FountainDecoderPart part) {
    if (mixedParts.any((e) => arraysEqual(e.key, part.indexes))) {
      return;
    }

    var p2 = simpleParts.fold(part, (acc, e) => reducePartByPart(acc, e.value));
    p2 = mixedParts.fold(p2, (acc, e) => reducePartByPart(acc, e.value));

    if (p2.isSimple()) {
      queuedParts.add(p2);
    } else {
      reduceMixedBy(p2);
      mixedParts.add(PartDict(p2.indexes, p2));
    }
  }

  void processQueuedItem() {
    if (queuedParts.isEmpty) {
      return;
    }

    final part = queuedParts.removeAt(0);

    if (part.isSimple()) {
      processSimplePart(part);
    } else {
      processMixedPart(part);
    }
  }

  static Uint8List joinFragments(List<Uint8List> fragments, int messageLength) {
    return Uint8List.fromList(fragments.expand((x) => x).toList()).sublist(0, messageLength);
  }

  bool receivePart(FountainEncoderPart encoderPart) {
    if (isComplete()) {
      return false;
    }

    if (!validatePart(encoderPart)) {
      return false;
    }

    final decoderPart = FountainDecoderPart.fromEncoderPart(encoderPart);
    lastPartIndexes = decoderPart.indexes;
    queuedParts.add(decoderPart);

    while (!isComplete() && queuedParts.isNotEmpty) {
      processQueuedItem();
    }

    processedPartsCount += 1;
    return true;
  }

  bool isComplete() {
    return result != null && result!.isNotEmpty;
  }

  bool isSuccess() {
    return error == null && isComplete();
  }

  Uint8List resultMessage() {
    return isSuccess() ? result! : Uint8List(0);
  }

  bool isFailure() {
    return error != null;
  }

  String resultError() {
    return error?.toString() ?? '';
  }

  int expectedPartCount() {
    return expectedPartIndexes.length;
  }

  PartIndexes getExpectedPartIndexes() {
    return List.from(expectedPartIndexes);
  }

  PartIndexes getReceivedPartIndexes() {
    return List.from(receivedPartIndexes);
  }

  PartIndexes getLastPartIndexes() {
    return List.from(lastPartIndexes);
  }

  double estimatedPercentComplete() {
    if (isComplete()) {
      return 1;
    }

    final expectedPartCount = this.expectedPartCount();

    if (expectedPartCount == 0) {
      return 0;
    }

    return (processedPartsCount / (expectedPartCount * 1.75)).clamp(0.0, 0.99);
  }

  double getProgress() {
    if (isComplete()) {
      return 1;
    }

    final expectedPartCount = this.expectedPartCount();

    if (expectedPartCount == 0) {
      return 0;
    }

    return receivedPartIndexes.length / expectedPartCount;
  }
}
