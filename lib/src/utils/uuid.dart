import 'dart:typed_data';
import 'package:uuid/uuid.dart';

Uint8List generateUuid() => const Uuid().v1obj().toBytes();
String generateUuidStr() => uuidStringify(generateUuid());

String uuidStringify(List<int> uuid, {int offset = 0}) => Uuid.unparse(uuid, offset: offset);

List<int> uuidParse(String uuid) => Uuid.parse(uuid);

List<Map<String, dynamic>> parsePath(String path) {
  final chunks = path.replaceAll(RegExp(r'^m/'), '').split('/');
  return chunks.map((chunk) {
    final hardened = chunk.endsWith("'");
    final index = int.parse(hardened ? chunk.substring(0, chunk.length - 1) : chunk);
    return {
      'index': index,
      'hardened': hardened
    };
  }).toList();
}
