import 'dart:convert';
import 'dart:typed_data';
import 'package:cbor/cbor.dart';
import 'package:gs_ur_dart/src/registry/registry_item.dart';
import 'package:gs_ur_dart/src/registry/crypto_key_path.dart';
import 'package:gs_ur_dart/src/registry/crypto_tx_entity.dart';
import 'package:gs_ur_dart/src/registry/data_item.dart';
import 'package:gs_ur_dart/src/registry/registry_type.dart';
import 'package:gs_ur_dart/src/utils/format.dart';
import 'package:gs_ur_dart/src/utils/uuid.dart';


enum AlphSignRequestKeys {
  zero,
  uuid,
  data,
  derivationPath,
  outputs,
  origin,
}

class AlphSignRequest extends RegistryItem {
  Uint8List? uuid;
  final Uint8List data;
  final CryptoKeypath? derivationPath;
  final List<CryptoTxEntity>? outputs;
  final String? origin;

  AlphSignRequest({
    this.uuid,
    required this.data,
    this.derivationPath,
    this.outputs,
    this.origin,
  });

  @override
  RegistryType getRegistryType() {
    return ExtendedRegistryType.ALPH_SIGN_REQUEST;
  }

  Uint8List getRequestId() => uuid ??= generateUuid();
  Uint8List getData() => data;
  CryptoKeypath? getPath() => derivationPath;
  List<CryptoTxEntity>? getOutputs() => outputs;
  String? getOrigin() => origin;

  @override
  CborValue toCborValue() {
    final Map map = {};
    map[AlphSignRequestKeys.uuid.index] = CborBytes(getRequestId(), tags: [RegistryType.UUID.tag]);
    map[AlphSignRequestKeys.data.index] =  data;
    if (derivationPath != null) {
      CborValue derivationPathDataItem = derivationPath!.toCborValue();
      derivationPathDataItem = cborValueSetTags(derivationPathDataItem, [derivationPath!.getRegistryType().tag]);
      map[AlphSignRequestKeys.derivationPath.index] = derivationPathDataItem;
    }
    if (outputs != null && outputs!.isNotEmpty) {
        List<CborValue> outputsData = [];
        for(CryptoTxEntity output in outputs!){
          CborValue inputDataItem = output.toCborValue();
          inputDataItem = cborValueSetTags(inputDataItem, [output.getRegistryType().tag]);
          outputsData.add(inputDataItem);
        }
        map[AlphSignRequestKeys.outputs.index] = outputsData;
      }
    if (origin != null) {
      map[AlphSignRequestKeys.origin.index] = origin;
    }
    return CborValue(map);
  }

  static AlphSignRequest fromDataItem(dynamic jsonData) {
    final map = jsonData is String ? jsonDecode(jsonData) : jsonData is Map? jsonData : null;
    if(map == null){
      throw "Param for fromDataItem is neither String nor Map, please check it!";
    }
    final data = map[AlphSignRequestKeys.data.index.toString()];
    final uuid = map[AlphSignRequestKeys.uuid.index.toString()];
    final derivationPath = map[AlphSignRequestKeys.derivationPath.index.toString()] != null ? CryptoKeypath.fromDataItem(map[AlphSignRequestKeys.derivationPath.index.toString()]) : null;
    final outputs = ((map[AlphSignRequestKeys.outputs.index.toString()] ?? []) as List).map((e)=>CryptoTxEntity.fromDataItem(e)).toList();
    final origin = map[AlphSignRequestKeys.origin.index.toString()];

    return AlphSignRequest(
      uuid: fromHex(uuid), 
      data: fromHex(data),
      derivationPath: derivationPath,
      outputs: outputs,
      origin: origin,
    );
  }

  static AlphSignRequest fromCBOR(Uint8List cborPayload) {
    CborValue cborValue = cbor.decode(cborPayload);
    String jsonData = const CborJsonEncoder().convert(cborValue);
    return fromDataItem(jsonData);
  }
}