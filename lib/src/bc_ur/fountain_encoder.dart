import 'dart:convert';
import 'dart:typed_data';
import 'package:hex/hex.dart';
import 'package:flutter/foundation.dart';
import 'utils.dart';
import 'fountain_utils.dart';
import 'cbor.dart';

class FountainEncoderPart {
  final int _seqNum;
  final int _seqLength;
  final int _messageLength;
  final int _checksum;
  final Uint8List _fragment;

  FountainEncoderPart(
      this._seqNum, this._seqLength, this._messageLength, this._checksum, this._fragment);

  int get messageLength => _messageLength;
  Uint8List get fragment => _fragment;
  int get seqNum => _seqNum;
  int get seqLength => _seqLength;
  int get checksum => _checksum;

  Uint8List cbor() {
    final result = cborEncode([
      _seqNum,
      _seqLength,
      _messageLength,
      _checksum,
      _fragment,
    ]);

    return result;
  }

  String description() {
    return 'seqNum:$_seqNum, seqLen:$_seqLength, messageLen:$_messageLength, checksum:$_checksum, data:${HEX.encode(_fragment)}';
  }

  static FountainEncoderPart fromCBOR(dynamic cborPayload) {
    final decoded = jsonDecode(cborDecode(cborPayload));
    final seqNum = decoded[0] as int;
    final seqLength = decoded[1] as int;
    final messageLength = decoded[2] as int;
    final checksum = decoded[3] as int;
    final fragment = Uint8List.fromList(HEX.decode(decoded[4]));

    assert(fragment.isNotEmpty);

    return FountainEncoderPart(
      seqNum,
      seqLength,
      messageLength,
      checksum,
      fragment,
    );
  }
}

class FountainEncoder {
  late int _messageLength;
  late List<Uint8List> _fragments;
  late int fragmentLength;
  late int seqNum;
  late int checksum;

  FountainEncoder({
    required Uint8List message,
    int maxFragmentLength = 100,
    int firstSeqNum = 0,
    int minFragmentLength = 10,
  }) {
    fragmentLength = FountainEncoder.findNominalFragmentLength(
        message.length, minFragmentLength, maxFragmentLength);

    _messageLength = message.length;
    _fragments = FountainEncoder.partitionMessage(message, fragmentLength);
    fragmentLength = fragmentLength;
    seqNum = toUint32(firstSeqNum);
    checksum = getCRC(message);
  }

  int get fragmentsLength => _fragments.length;
  List<Uint8List> get fragments => _fragments;
  int get messageLength => _messageLength;

  bool isComplete() {
    return seqNum >= _fragments.length;
  }

  bool isSinglePart() {
    return _fragments.length == 1;
  }

  int seqLength() {
    return _fragments.length;
  }

  Uint8List mix(List<int> indexes) {
    return indexes.fold(
        Uint8List(fragmentLength),
        (Uint8List result, int index) =>
            bufferXOR(result, _fragments[index]));
  }

  FountainEncoderPart nextPart() {
    seqNum = toUint32(seqNum + 1);

    final indexes = chooseFragments(seqNum, _fragments.length, checksum);
    final mixed = mix(indexes);

    return FountainEncoderPart(
      seqNum,
      _fragments.length,
      _messageLength,
      checksum,
      mixed,
    );
  }
    
  static int findNominalFragmentLength(
      int messageLength, int minFragmentLength, int maxFragmentLength) {
    assert(messageLength > 0);
    assert(minFragmentLength > 0);
    assert(maxFragmentLength >= minFragmentLength);

    final maxFragmentCount = (messageLength / minFragmentLength).ceil();
    var fragmentLength = 0;

    for (var fragmentCount = 1;
        fragmentCount <= maxFragmentCount;
        fragmentCount++) {
      fragmentLength = (messageLength / fragmentCount).ceil();

      if (fragmentLength <= maxFragmentLength) {
        break;
      }
    }

    return fragmentLength;
  }

  static List<Uint8List> partitionMessage(
      Uint8List message, int fragmentLength) {
    var remaining = Uint8List.fromList(message);
    Uint8List fragment;
    final List<Uint8List> fragments = [];

    while (remaining.isNotEmpty) {
      fragment = remaining.sublist(0, remaining.length < fragmentLength ? remaining.length : fragmentLength);
      remaining = remaining.sublist(fragment.length);
      fragments.add(
          Uint8List(fragmentLength)..setRange(0, fragment.length, fragment));
    }

    return fragments;
  }
}

