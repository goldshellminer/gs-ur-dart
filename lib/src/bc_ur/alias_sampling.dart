import 'dart:math';

class AliasData {
  List<double> prob;
  List<int> alias;

  AliasData(this.prob, this.alias);
}

AliasData precomputeAlias(List<double> p, int n) {
  double sum = p.reduce((acc, val) {
    if (val < 0) {
      throw ArgumentError('Probability must be a positive: p[${p.indexOf(val)}]=$val');
    }
    return acc + val;
  });

  if (sum == 0) {
    throw ArgumentError('Probability sum must be greater than zero.');
  }

  List<double> scaledProbabilities = p.map((prob) => (prob * n) / sum).toList();
  AliasData aliasData = AliasData(List.filled(n, 0.0), List.filled(n, 0));
  List<int> small = [];
  List<int> large = [];

  for (int i = n - 1; i >= 0; i--) {
    if (scaledProbabilities[i] < 1) {
      small.add(i);
    } else {
      large.add(i);
    }
  }

  while (small.isNotEmpty && large.isNotEmpty) {
    int less = small.removeLast();
    int more = large.removeLast();
    aliasData.prob[less] = scaledProbabilities[less];
    aliasData.alias[less] = more;
    scaledProbabilities[more] = (scaledProbabilities[more] + scaledProbabilities[less]) - 1;
    if (scaledProbabilities[more] < 1) {
      small.add(more);
    } else {
      large.add(more);
    }
  }

  while (large.isNotEmpty) {
    aliasData.prob[large.removeLast()] = 1.0;
  }

  while (small.isNotEmpty) {
    aliasData.prob[small.removeLast()] = 1.0;
  }

  return aliasData;
}

T draw<T>(AliasData aliasData, List<T> outcomes, dynamic rng) {
  int c = (rng.nextDouble() * aliasData.prob.length).floor();
  return outcomes[(rng.nextDouble() < aliasData.prob[c]) ? c : aliasData.alias[c]];
}

dynamic nextSample<T>(AliasData aliasData, List<T> outcomes, dynamic rng, int? numOfSamples) {
  if (numOfSamples == null || numOfSamples == 1) {
    return draw(aliasData, outcomes, rng);
  }

  List<T> samples = [];
  for (int i = 0; i < numOfSamples; i++) {
    samples.add(draw(aliasData, outcomes, rng));
  }

  return samples;
}

class Sampler<T> {
  final AliasData aliasData;
  final List<T> outcomes;
  final dynamic rng;

  Sampler(List<double> probabilities, List<T>? outcomes, [dynamic rng])
      : aliasData = precomputeAlias(probabilities, probabilities.length),
        outcomes = outcomes ?? List.generate(probabilities.length, (i) => i as T),
        rng = rng ?? Random();

  dynamic next([int numOfSamples = 1]) {
    return nextSample(aliasData, outcomes, rng, numOfSamples);
  }
}

Sampler<T> sample<T>(List<double> probabilities, List<T>? outcomes, [dynamic rng]) {
  if (probabilities.isEmpty) {
    throw ArgumentError('Probabilities array must not be empty.');
  }

  return Sampler(probabilities, outcomes, rng);
}
