import 'dart:typed_data';
import 'utils.dart';
import 'xoshiro.dart';
import 'alias_sampling.dart';

int chooseDegree(int seqLength, Xoshiro rng) {
  final degreeProbabilities = List.generate(seqLength, (index) => 1 / (index + 1));
  final degreeChooser = Sampler(degreeProbabilities, null, rng);

  return degreeChooser.next() + 1;
}

List<T> shuffle<T>(List<T> items, Xoshiro rng) {
  final remaining = List<T>.from(items);
  final result = <T>[];

  while (remaining.isNotEmpty) {
    final index = rng.nextInt(0, remaining.length - 1);
    final item = remaining.removeAt(index.toInt());
    result.add(item);
  }

  return result;
}

List<int> chooseFragments(int seqNum, int seqLength, int checksum) {
  if (seqNum <= seqLength) {
    return [seqNum - 1];
  } else {
    final seed = Uint8List.fromList(intToBytes(seqNum) + intToBytes(checksum));
    final rng = Xoshiro(seed);
    final degree = chooseDegree(seqLength, rng);
    final indexes = List.generate(seqLength, (index) => index);
    final shuffledIndexes = shuffle(indexes, rng);

    return shuffledIndexes.sublist(0, degree);
  }
}
