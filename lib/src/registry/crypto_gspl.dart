
import 'dart:convert';
import 'dart:typed_data';
import 'package:cbor/cbor.dart';
import 'package:gs_ur_dart/src/utils/format.dart';
import 'package:gs_ur_dart/src/registry/crypto_tx_element.dart';
import 'package:gs_ur_dart/src/registry/data_item.dart';
import 'package:gs_ur_dart/src/registry/registry_item.dart';
import 'package:gs_ur_dart/src/registry/registry_type.dart';

enum GsbtKeys {
  zero,
  data,
  dataType,
  inputs,
  change,
}


enum GsplDataType {
  zero,
  transaction,
  message,
}

class CryptoGspl extends RegistryItem{
  Uint8List data;
  GsplDataType dataType;
  List<CryptoTxElement>? inputs;
  CryptoTxElement? change;

  CryptoGspl({required this.data, 
    required this.dataType,
    this.inputs,
    this.change,});

  @override
  RegistryType getRegistryType() {
    return ExtendedRegistryType.CRYPTO_GSPL;
  }

  @override
  CborValue toCborValue() {
    final map = {};
      map[GsbtKeys.data.index] = data;
      map[GsbtKeys.dataType.index] = dataType.index;
      if (inputs != null) {
        List<CborValue> inputsData = [];
        for(CryptoTxElement input in inputs!){
          CborValue inputDataItem = input.toCborValue();
          inputDataItem = cborValueSetTags(inputDataItem, [input.getRegistryType().tag]);
          inputsData.add(inputDataItem);
        }
        map[GsbtKeys.inputs.index] = inputsData;
      }
      if (change != null) {
        CborValue changeDataItem = change!.toCborValue();
        changeDataItem = cborValueSetTags(changeDataItem, [change!.getRegistryType().tag]);
        map[GsbtKeys.change.index] = changeDataItem;
      }
    return CborValue(map);
  }

  static CryptoGspl fromDataItem(dynamic jsonData) {
    final map = jsonData is String ? jsonDecode(jsonData) : jsonData is Map? jsonData : null;
    if(map == null){
      throw "Param for fromDataItem is neither String nor Map, please check it!";
    }

    final data = map[GsbtKeys.data.index.toString()];
    final dataType = GsplDataType.values[map[GsbtKeys.dataType.index.toString()]];
    final List<CryptoTxElement>? inputs = map[GsbtKeys.inputs.index.toString()]?.map((e)=>CryptoTxElement.fromDataItem(e)).toList().cast<CryptoTxElement>();
    final CryptoTxElement? change = map[GsbtKeys.change.index.toString()] != null ? CryptoTxElement.fromDataItem(map[GsbtKeys.change.index.toString()]) : null;

    return CryptoGspl(
      data: fromHex(data),
      dataType: dataType,
      inputs: inputs,
      change: change,
    );
  }

  static CryptoGspl fromCBOR(Uint8List cborPayload) {
    CborValue cborValue = cbor.decode(cborPayload);
    String jsonData = const CborJsonEncoder().convert(cborValue);
    return fromDataItem(jsonData);
  }
}
