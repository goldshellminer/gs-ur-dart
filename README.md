# gs-ur-js

This repository contains the Flutter SDK for interacting with Goldshell's GSWallet. GSWallet is a hardware wallet that securely transmits information via QR codes.  This SDK allows developers to integrate GSWallet functionality into their applications.
GsWallet Official Website: [wallet.goldshell.com](wallet.goldshell.com) 

## Features

* **Secure QR Code Communication:** Enables secure communication with GSWallet using QR codes.
* **Multi-Currency Support:**  Supports various cryptocurrencies (currently under development, examples below show BTC and ETH).
* **Transaction Signing:**  Allows parsing signature of transactions from the GSWallet device.

## Getting Started

These instructions will guide you through setting up and using the `gs-ur-dart` SDK.


### Prerequisites

* Flutter SDK and Dart installed.


### Installation

Choose your preferred package manager:

```bash
// pubspec.yaml
dependencies:
  gs_ur_dart: ^1.0.0

// bash
flutter pub get

// In your Dart file, import library
import 'package:gs_ur_dart/gs_ur_dart.dart';
```

## QRcode Example

### Generating UR QR Codes

```dart
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gs_ur_dart/gs_ur_dart.dart';
import 'package:qr_flutter/qr_flutter.dart';

abstract class _State {}

class _InitialState extends _State {}

class _AnimatedQRDataState extends _State {
  final String data;
  _AnimatedQRDataState(this.data);
}

class _Cubit extends Cubit<_State> {
  final UREncoder urEncoder;
  final AnimatedQRCodeStyle style;

  late String _currentQR;
  late Timer timer;

  _Cubit(this.urEncoder, this.style) : super(_InitialState());

  void initial() {
    _currentQR = urEncoder.nextPart();
    emit(_AnimatedQRDataState(_currentQR));
    timer = Timer.periodic(const Duration(milliseconds: 250), (_) {
      _currentQR = urEncoder.nextPart();
      emit(_AnimatedQRDataState(_currentQR));
    });
  }

  @override
  Future<void> close() async {
    timer.cancel();
    super.close();
  }

  String get currentQR => _currentQR;
}

class AnimatedQRCodeStyle {
  final double size;

  AnimatedQRCodeStyle({
    this.size = 300,
  });

  const AnimatedQRCodeStyle.factory() : size = 300;
}

class AnimatedQRCode extends StatelessWidget {
  final UREncoder urEncoder;
  final AnimatedQRCodeStyle style;

  const AnimatedQRCode(
      {Key? key,
      required this.urEncoder,
      this.style = const AnimatedQRCodeStyle.factory()})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _Cubit(urEncoder, style),
      child: const _AnimatedQRCode(),
    );
  }
}

class _AnimatedQRCode extends StatefulWidget {
  const _AnimatedQRCode({Key? key}) : super(key: key);

  @override
  _AnimatedQRCodeState createState() => _AnimatedQRCodeState();
}

class _AnimatedQRCodeState extends State<_AnimatedQRCode> {
  _AnimatedQRCodeState();

  late _Cubit _cubit;

  @override
  void initState() {
    _cubit = BlocProvider.of(context);
    _cubit.initial();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<_Cubit, _State>(builder: (context, state) {
      if (state is _AnimatedQRDataState) {
        return QrImageView(
          data: state.data,
          size: _cubit.style.size,
          backgroundColor: const Color(0xFFFFFFFF),
        );
      }
      return QrImageView(
        data: _cubit.currentQR,
        size: _cubit.style.size,
        backgroundColor: const Color(0xFFFFFFFF),
      );
    });
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }
}


```


### Scanning QR Codes and Parsing UR Results

```dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:gs_ur_dart/gs_ur_dart.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

extension FxSize on num {
  /// Auto adjust width with system text size setting. It is for vertical space size to auto changed with setting.
  double get aw => Get.mediaQuery.textScaler.scale(w);
}

class _State {
  final String? code;
  final String process;
  final double progress;

  _State({this.code, this.process = "0", this.progress = 0});
}

class _InitialState extends _State {}

typedef SuccessCallback = void Function(UR);
typedef FailureCallback = void Function(String);
typedef OnProcessed = void Function(String, String);

class _Cubit extends Cubit<_State> {
  // late final RegistryType target;
  final SuccessCallback onSuccess;
  final FailureCallback onFailed;
  // final OnProcessed? onProcessed;
  final QrScannerOverlayShape? overlay;
  URDecoder urDecoder = URDecoder();
  bool succeed = false;
  String? data;
  String process = "0";
  double progress = 0;

  _Cubit(
    // this.target,
    this.onSuccess,
    this.onFailed, {
    this.overlay,
    // this.onProcessed,
  }) : super(_InitialState());

  void receiveQRCode(String? code) {
    try {
      if (code != null) {
        data = code;
        // print("code: >>> $code");
        emit(_State(code: code));
        urDecoder.receivePart(code);
        progress = urDecoder.getProgress();
        process = (urDecoder.getProgress() * 100).toStringAsFixed(2);
        // if(onProcessed != null) onProcessed!(code, process);
        emit(_State(process: process, progress: progress));
        if (urDecoder.isComplete()) {
          final result = urDecoder.resultUR();
          if (!succeed) {
            onSuccess(result);
            succeed = true;
          }
        }
      }
    } catch (e) {
      onFailed("Error when receiving UR $e");
      reset();
      throw e;
    }
  }

  void reset() {
    urDecoder = URDecoder();
    succeed = false;
  }
}

class AnimatedQRScanner extends StatelessWidget {
  // final RegistryType target;
  final SuccessCallback onSuccess;
  final FailureCallback onFailed;
  // final OnProcessed? onProcessed;
  final QrScannerOverlayShape? overlay;

  const AnimatedQRScanner(
      {Key? key,
      // required this.target,
      required this.onSuccess,
      required this.onFailed,
      // this.onProcessed,
      this.overlay})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>
          _Cubit(onSuccess, onFailed, overlay: overlay),
      child: _AnimatedQRScanner(),
    );
  }
}

class _AnimatedQRScanner extends StatefulWidget {
  @override
  _AnimatedQRScannerState createState() => _AnimatedQRScannerState();
}

class _AnimatedQRScannerState extends State<_AnimatedQRScanner> {
  final GlobalKey<State<StatefulWidget>> keyQr = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  late final _Cubit _cubit;

  @override
  void initState() {
    _cubit = BlocProvider.of(context);
    super.initState();
  }

  @override
  Future<void> reassemble() async {
    if (Platform.isAndroid) {
      await controller!.pauseCamera();
    }
    controller!.resumeCamera();
    super.reassemble();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          QRView(
            key: keyQr,
            onQRViewCreated: onQRViewCreated,
            overlay: QrScannerOverlayShape(
                borderLength: 236.w,
                borderColor: Colors.white,
                borderWidth: 12.w,
                borderRadius: 40.w,
                cutOutSize: 472.w,
                cutOutBottomOffset: 80.h),
          ),
          Positioned(
              top: 108.h,
              left: 32.w,
              child: GestureDetector(
                  onTap: () => Get.back(),
                  child: const Icon(Icons.arrow_back, color: Colors.white))),
          Positioned(
              bottom: 500.h,
              left: 130.w,
              right: 130.w,
              child: BlocBuilder<_Cubit, _State>(
                  bloc: _cubit,
                  builder: (context, state) {
                    return Row(children: [
                      Expanded(
                          child: LinearProgressIndicator(
                              minHeight: 12.w,
                              value: state.progress,
                              color: const Color(0xFFF4B400),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6.w)),
                              backgroundColor: Colors.grey)),
                      SizedBox(width: 24.w),
                      Text("${state.process}%",
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(color: Colors.white, fontSize: 28.sp))
                    ]);
                  })),
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Column(children: [
                Image.asset('assets/images/img_scan_progress.png',
                    width: 160.w, height: 160.w),
                SizedBox(height: 16.w),
                Text('Scan the QR codes on your Goldshell wallet',
                    style: TextStyle(color: Colors.white, fontSize: 28.sp)),
                SizedBox(height: 200.w)
              ])),
        ],
      ),
    );
  }

  Future<void> onQRViewCreated(QRViewController controller) async {
    setState(() => this.controller = controller);
    reassemble();
    try {
      controller.scannedDataStream.listen((event) {
        _cubit.receiveQRCode(event.code);
      });
    } catch (e) {
      _cubit.onFailed("Error when receiving UR: $e");
      _cubit.reset();
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}


```