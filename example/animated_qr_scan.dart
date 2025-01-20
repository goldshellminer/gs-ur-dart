// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:get/get.dart';
// import 'package:gs_ur_dart/gs_ur_dart.dart';
// import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// extension FxSize on num {
//   /// Auto adjust width with system text size setting. It is for vertical space size to auto changed with setting.
//   double get aw => Get.mediaQuery.textScaler.scale(w);
// }

// class _State {
//   final String? code;
//   final String process;
//   final double progress;

//   _State({this.code, this.process = "0", this.progress = 0});
// }

// class _InitialState extends _State {}

// typedef SuccessCallback = void Function(UR);
// typedef FailureCallback = void Function(String);
// typedef OnProcessed = void Function(String, String);

// class _Cubit extends Cubit<_State> {
//   // late final RegistryType target;
//   final SuccessCallback onSuccess;
//   final FailureCallback onFailed;
//   // final OnProcessed? onProcessed;
//   final QrScannerOverlayShape? overlay;
//   URDecoder urDecoder = URDecoder();
//   bool succeed = false;
//   String? data;
//   String process = "0";
//   double progress = 0;

//   _Cubit(
//     // this.target,
//     this.onSuccess,
//     this.onFailed, {
//     this.overlay,
//     // this.onProcessed,
//   }) : super(_InitialState());

//   void receiveQRCode(String? code) {
//     try {
//       if (code != null) {
//         data = code;
//         // print("code: >>> $code");
//         emit(_State(code: code));
//         urDecoder.receivePart(code);
//         progress = urDecoder.getProgress();
//         process = (urDecoder.getProgress() * 100).toStringAsFixed(2);
//         // if(onProcessed != null) onProcessed!(code, process);
//         emit(_State(process: process, progress: progress));
//         if (urDecoder.isComplete()) {
//           final result = urDecoder.resultUR();
//           if (!succeed) {
//             onSuccess(result);
//             succeed = true;
//           }
//         }
//       }
//     } catch (e) {
//       onFailed("Error when receiving UR $e");
//       reset();
//       throw e;
//     }
//   }

//   void reset() {
//     urDecoder = URDecoder();
//     succeed = false;
//   }
// }

// class AnimatedQRScanner extends StatelessWidget {
//   // final RegistryType target;
//   final SuccessCallback onSuccess;
//   final FailureCallback onFailed;
//   // final OnProcessed? onProcessed;
//   final QrScannerOverlayShape? overlay;

//   const AnimatedQRScanner(
//       {Key? key,
//       // required this.target,
//       required this.onSuccess,
//       required this.onFailed,
//       // this.onProcessed,
//       this.overlay})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (BuildContext context) =>
//           _Cubit(onSuccess, onFailed, overlay: overlay),
//       child: _AnimatedQRScanner(),
//     );
//   }
// }

// class _AnimatedQRScanner extends StatefulWidget {
//   @override
//   _AnimatedQRScannerState createState() => _AnimatedQRScannerState();
// }

// class _AnimatedQRScannerState extends State<_AnimatedQRScanner> {
//   final GlobalKey<State<StatefulWidget>> keyQr = GlobalKey(debugLabel: 'QR');
//   QRViewController? controller;
//   late final _Cubit _cubit;

//   @override
//   void initState() {
//     _cubit = BlocProvider.of(context);
//     super.initState();
//   }

//   @override
//   Future<void> reassemble() async {
//     if (Platform.isAndroid) {
//       await controller!.pauseCamera();
//     }
//     controller!.resumeCamera();
//     super.reassemble();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // return QRView(
//     //   key: keyQr,
//     //   onQRViewCreated: onQRViewCreated,
//     //   overlay: _cubit.overlay,
//     // );
//     return Scaffold(
//       // appBar: AppBar(title: Text('Scan')),
//       body: Stack(
//         children: [
//           QRView(
//             key: keyQr,
//             onQRViewCreated: onQRViewCreated,
//             // overlay: _cubit.overlay,
//             overlay: QrScannerOverlayShape(
//                 borderLength: 236.w,
//                 borderColor: Colors.white,
//                 borderWidth: 12.w,
//                 borderRadius: 40.w,
//                 cutOutSize: 472.w,
//                 cutOutBottomOffset: 80.h),
//           ),
//           Positioned(
//               top: 108.h,
//               left: 32.w,
//               child: GestureDetector(
//                   onTap: () => Get.back(),
//                   child: const Icon(Icons.arrow_back, color: Colors.white))),
//           Positioned(
//               bottom: 500.h,
//               left: 130.w,
//               right: 130.w,
//               child: BlocBuilder<_Cubit, _State>(
//                   bloc: _cubit,
//                   builder: (context, state) {
//                     return Row(children: [
//                       Expanded(
//                           child: LinearProgressIndicator(
//                               minHeight: 12.w,
//                               value: state.progress,
//                               color: const Color(0xFFF4B400),
//                               borderRadius:
//                                   BorderRadius.all(Radius.circular(6.w)),
//                               backgroundColor: Colors.grey)),
//                       SizedBox(width: 24.w),
//                       Text("${state.process}%",
//                           textAlign: TextAlign.center,
//                           style:
//                               TextStyle(color: Colors.white, fontSize: 28.sp))
//                     ]);
//                   })),
//           Positioned(
//               bottom: 0,
//               left: 0,
//               right: 0,
//               child: Column(children: [
//                 Image.asset('assets/images/img_scan_progress.png',
//                     width: 160.w, height: 160.w),
//                 SizedBox(height: 16.w),
//                 Text('Scan the QR codes on your Goldshell wallet',
//                     style: TextStyle(color: Colors.white, fontSize: 28.sp)),
//                 SizedBox(height: 200.w)
//               ])),
//         ],
//       ),
//     );
//   }

//   Future<void> onQRViewCreated(QRViewController controller) async {
//     setState(() => this.controller = controller);
//     // The reassemble function call is needed because of the black screen error
//     // https://github.com/juliuscanute/qr_code_scanner/issues/538#issuecomment-1133883828
//     // https://github.com/juliuscanute/qr_code_scanner/issues/548
//     reassemble();
//     try {
//       controller.scannedDataStream.listen((event) {
//         _cubit.receiveQRCode(event.code);
//       });
//     } catch (e) {
//       _cubit.onFailed("Error when receiving UR: $e");
//       _cubit.reset();
//     }
//   }

//   @override
//   void dispose() {
//     controller?.dispose();
//     super.dispose();
//   }
// }
