class InvalidSchemeError extends Error {
  final dynamic message;
  InvalidSchemeError([this.message]) : super();

  @override
  String toString() => 'InvalidSchemeError: $message';
}

class InvalidPathLengthError extends Error {
  final dynamic message;
  InvalidPathLengthError([this.message]) : super();

  @override
  String toString() => 'InvalidPathLengthError: $message';
}

class InvalidTypeError extends Error {
  final dynamic message;
  InvalidTypeError([this.message]) : super();

  @override
  String toString() => 'InvalidTypeError: $message';
}

class InvalidSequenceComponentError extends Error {
  final dynamic message;
  InvalidSequenceComponentError([this.message]) : super();

  @override
  String toString() => 'InvalidSequenceComponentError: $message';
}

class InvalidChecksumError extends Error {
  final dynamic message;
  InvalidChecksumError([this.message]) : super();

  @override
  String toString() => 'InvalidChecksumError: $message';
}
