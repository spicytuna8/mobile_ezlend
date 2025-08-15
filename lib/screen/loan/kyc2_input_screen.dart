// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as m;

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:loan_project/bloc/kyc/kyc_bloc.dart';
import 'package:loan_project/bloc/transaction/transaction_bloc.dart';
import 'package:loan_project/helper/Image_picker.dart';
import 'package:loan_project/helper/image_helper.dart';
import 'package:loan_project/helper/languages.dart';
import 'package:loan_project/helper/router_name.dart';
import 'package:loan_project/helper/text_helper.dart';
import 'package:loan_project/model/kyc2_param.dart';
import 'package:loan_project/model/request_kyc.dart';
import 'package:loan_project/model/request_resubmit_kyc.dart';
import 'package:loan_project/screen/loan/sample_kyc_video_screen.dart';
import 'package:loan_project/widget/global_function.dart';
import 'package:loan_project/widget/main_button_gradient.dart';
import 'package:video_player/video_player.dart';

class Kyc2InputScreen extends StatefulWidget {
  final Kyc2Param data;
  const Kyc2InputScreen({Key? key, required this.data}) : super(key: key);

  @override
  State<Kyc2InputScreen> createState() => _Kyc2InputScreenState();
}

class _Kyc2InputScreenState extends State<Kyc2InputScreen> {
  final KycBloc kycBloc = KycBloc();
  final TransactionBloc transactionBloc = TransactionBloc();
  // TextEditingController namePerId = TextEditingController();
  // TextEditingController idNumber = TextEditingController();
  // TextEditingController benefiaryName = TextEditingController();
  // TextEditingController benefiaryContact = TextEditingController();
  // TextEditingController beneficiaryRelationship = TextEditingController();
  // TextEditingController bankName = TextEditingController();
  // TextEditingController accountName = TextEditingController();
  // TextEditingController accountNumber = TextEditingController();

  int activeStep = 0;
  double progress = 0.2;
  String file = '';
  String fileFront = '';
  String fileFront64 = '';
  String fileBack = '';
  String fileBack64 = '';
  String fileSelfie = '';
  String fileSelfie64 = '';
  Map<String, dynamic>? selectedRelationship;

  VideoPlayerController? _controller;
  bool initialized = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<TransactionBloc, TransactionState>(
      bloc: transactionBloc,
      listener: (context, state) {
        if (state is PostLoanSuccess) {
          EasyLoading.dismiss();
          GlobalFunction().allDialog(context,
              title: Languages.of(context).successSubmitKycAndApplyLoan,
              onTap: () {
            Navigator.of(context).pop(); // close dialog
            Future.delayed(Duration(milliseconds: 200), () {
              context.goNamed(bottomNavigation, extra: 0);
            });
          });
        } else if (state is PostLoanError) {
          EasyLoading.dismiss();
          GlobalFunction().allDialog(
            context,
            title: state.message,
          );
        }
        // TODO: implement listener
      },
      child: Scaffold(
        backgroundColor: const Color(0xff000000),
        appBar: AppBar(
          title: Text(
            Languages.of(context).applyLoan,
            style: white18w600,
          ),
          centerTitle: true,
          actions: const [],
          // bottom: PreferredSize(
          //   preferredSize: const Size.fromHeight(70.0),
          //   child: Container(
          //     height: 70,
          //     width: MediaQuery.of(context).size.width,
          //     color: baseColor,
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //       children: [
          //         const Icon(
          //           Icons.privacy_tip,
          //           size: 25,
          //           color: Colors.white,
          //         ),
          //         Text('Your data and privacy are protect by EZ-Land',
          //             style: white14w600),
          //       ],
          //     ),
          //   ),
          // )
        ),
        body: Container(
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height,
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: BlocConsumer<KycBloc, KycState>(
              bloc: kycBloc,
              listener: (context, state) {
                if (state is PostKycSuccess) {
                  // EasyLoading.dismiss();
                  transactionBloc.add(PostLoanEvent(
                    packageId: widget.data.itemPackage!.id.toString(),
                    dateLoan: DateFormat('yyyy-MM-dd').format(DateTime.now()),
                  ));
                } else if (state is PostResubmitKycSuccess) {
                  EasyLoading.dismiss();
                  GlobalFunction().allDialog(context,
                      title: Languages.of(context).successResubmitKyc,
                      onTap: () {
                    Navigator.of(context).pop(); // close dialog
                    Future.delayed(Duration(milliseconds: 200), () {
                      context.goNamed(bottomNavigation, extra: 0);
                    });
                  });
                } else if (state is PostKycError) {
                  EasyLoading.dismiss();
                  final errors = state.errors;
                  log('${errors}error kyc');
                  if (errors?['KycFile[1][file]'] != null ||
                      errors?["KycFile[0][file]"] != null ||
                      errors?['KycFile[2][file]'] != null) {
                    GlobalFunction().allDialog(context,
                        title: Languages.of(context).fileTooLarge);
                  } else {
                    GlobalFunction().allDialog(context,
                        title: state.message,
                        iconWidget: Image.asset(
                          'assets/icons/ic_info_danger.png',
                          width: 60,
                        ));
                  }
                }
                // TODO: implement listener
              },
              builder: (context, state) {
                final errors = (state is PostKycError) ? state.errors : {};
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 25.0,
                    ),
                    Text(
                      Languages.of(context).document,
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      Languages.of(context).uploadInstructions,
                      style: GoogleFonts.inter(
                        color: const Color(0xFF7D8998),
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          Languages.of(context).idPhotoFront,
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        TextButton(
                            onPressed: () {
                              context.pushNamed(sampleKyc);
                            },
                            child: Text(
                              Languages.of(context).viewSample,
                              style: GoogleFonts.inter(
                                color: const Color(0xFF0972D3),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            )),
                      ],
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),

                    GestureDetector(
                      onTap: widget.data.statusKyc2 == true
                          ? null
                          : () async {
                              final result =
                                  await ImagePickerDialog.pickImage(context);
                              String base64Image = '';

                              if (result != null) {
                                List<int> imageBytes =
                                    await result.readAsBytes();
                                setState(() {
                                  fileFront = result.path;
                                  base64Image = base64Encode(imageBytes);
                                  fileFront64 =
                                      'data:image/png;base64,$base64Image';
                                  // log(" ini foto front " + fileFront64.toString());
                                });
                              }
                            },
                      child: widget.data.statusKyc2 == true
                          ? DottedBorder(
                              borderType: BorderType.RRect,
                              radius: const Radius.circular(8),
                              dashPattern: const [5, 5],
                              color: const Color(0xFF354150),
                              strokeWidth: 1,
                              child: fileFront == ''
                                  ? Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 24),
                                      width: double.infinity,
                                      child: Column(
                                        children: [
                                          Image.asset(
                                            'assets/icons/ic_gallery.png',
                                            width: 30,
                                            height: 30,
                                          ),
                                          const SizedBox(
                                            height: 8.0,
                                          ),
                                          Text(
                                            Languages.of(context).approved,
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.inter(
                                              color: const Color(0xFF67A353),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : SizedBox(
                                      height: 200,
                                      width: MediaQuery.of(context).size.width,
                                      child: FutureBuilder<Widget>(
                                        future:
                                            buildAutoRotatedImage(fileFront),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.done) {
                                            return snapshot.data!;
                                          } else {
                                            return const Center(
                                                child:
                                                    CircularProgressIndicator());
                                          }
                                        },
                                      ),
                                    ),
                            )
                          : DottedBorder(
                              borderType: BorderType.RRect,
                              radius: const Radius.circular(8),
                              dashPattern: const [5, 5],
                              color: const Color(0xFF354150),
                              strokeWidth: 1,
                              child: fileFront == ''
                                  ? Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 24),
                                      width: double.infinity,
                                      child: Column(
                                        children: [
                                          const Icon(
                                            Icons.image,
                                            color: Color(0xFF354150),
                                            size: 50,
                                          ),
                                          const SizedBox(
                                            height: 8.0,
                                          ),
                                          Text(
                                            Languages.of(context)
                                                .tapHereToUpload,
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.inter(
                                              color: const Color(0xFF7D8998),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 8.0,
                                          ),
                                          Text(
                                            Languages.of(context)
                                                .fileFormatLimit,
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.inter(
                                              color: const Color(0xFF7D8998),
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  : SizedBox(
                                      height: 200,
                                      width: MediaQuery.of(context).size.width,
                                      child: FutureBuilder<Widget>(
                                        future:
                                            buildAutoRotatedImage(fileFront),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.done) {
                                            return snapshot.data!;
                                          } else {
                                            return const Center(
                                                child:
                                                    CircularProgressIndicator());
                                          }
                                        },
                                      ),
                                    )),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),

                    Text(
                      errors?['KycFile[1][file]'] != null
                          ? errors!['KycFile[1][file]'][0]
                          : '',
                      style: white10,
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          Languages.of(context).idPhotoBack,
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        TextButton(
                            onPressed: () {
                              context.pushNamed(sampleKyc);
                            },
                            child: Text(
                              Languages.of(context).viewSample,
                              style: GoogleFonts.inter(
                                color: const Color(0xFF0972D3),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            )),
                      ],
                    ),
                    GestureDetector(
                      onTap: widget.data.statusKyc3 == true
                          ? null
                          : () async {
                              final result =
                                  await ImagePickerDialog.pickImage(context);
                              String base64Image = '';

                              if (result != null) {
                                List<int> imageBytes =
                                    await result.readAsBytes();
                                setState(() {
                                  fileBack = result.path;
                                  base64Image = base64Encode(imageBytes);
                                  fileBack64 =
                                      'data:image/png;base64,$base64Image';
                                  // log(" ini foto back " + fileBack64.toString());
                                });
                              }
                            },
                      child: widget.data.statusKyc3 == true
                          ? DottedBorder(
                              borderType: BorderType.RRect,
                              radius: const Radius.circular(8),
                              dashPattern: const [5, 5],
                              color: const Color(0xFF354150),
                              strokeWidth: 1,
                              child: fileBack == ''
                                  ? Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 24),
                                      width: double.infinity,
                                      child: Column(
                                        children: [
                                          Image.asset(
                                            'assets/icons/ic_gallery.png',
                                            width: 30,
                                            height: 30,
                                          ),
                                          const SizedBox(
                                            height: 8.0,
                                          ),
                                          Text(
                                            Languages.of(context).approved,
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.inter(
                                              color: const Color(0xFF67A353),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : SizedBox(
                                      height: 200,
                                      width: MediaQuery.of(context).size.width,
                                      child: FutureBuilder<Widget>(
                                        future: buildAutoRotatedImage(fileBack),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.done) {
                                            return snapshot.data!;
                                          } else {
                                            return const Center(
                                                child:
                                                    CircularProgressIndicator());
                                          }
                                        },
                                      ),
                                    ),
                            )
                          : DottedBorder(
                              borderType: BorderType.RRect,
                              radius: const Radius.circular(8),
                              dashPattern: const [5, 5],
                              color: const Color(0xFF354150),
                              strokeWidth: 1,
                              child: fileBack == ''
                                  ? Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 24),
                                      width: double.infinity,
                                      child: Column(
                                        children: [
                                          const Icon(
                                            Icons.image,
                                            color: Color(0xFF354150),
                                            size: 50,
                                          ),
                                          const SizedBox(
                                            height: 8.0,
                                          ),
                                          Text(
                                            Languages.of(context)
                                                .tapHereToUpload,
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.inter(
                                              color: const Color(0xFF7D8998),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 8.0,
                                          ),
                                          Text(
                                            Languages.of(context)
                                                .fileFormatLimit,
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.inter(
                                              color: const Color(0xFF7D8998),
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  : SizedBox(
                                      height: 200,
                                      width: MediaQuery.of(context).size.width,
                                      child: FutureBuilder<Widget>(
                                        future: buildAutoRotatedImage(fileBack),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.done) {
                                            return snapshot.data!;
                                          } else {
                                            return const Center(
                                                child:
                                                    CircularProgressIndicator());
                                          }
                                        },
                                      ),
                                    ),
                            ),
                    ),

                    const SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      errors?['KycFile[2][file]'] != null
                          ? errors!['KycFile[2][file]'][0]
                          : '',
                      style: white10,
                    ),

                    const SizedBox(
                      height: 25.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          Languages.of(context).selfieVideo,
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        TextButton(
                            onPressed: () {
                              context.pushNamed(sampleKycVideo);
                            },
                            child: Text(
                              Languages.of(context).viewSample,
                              style: GoogleFonts.inter(
                                color: const Color(0xFF0972D3),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            )),
                      ],
                    ),

                    const SizedBox(
                      height: 20.0,
                    ),

                    GestureDetector(
                      onTap: widget.data.statusKyc1 == true
                          ? null
                          : () async {
                              final ImagePicker picker = ImagePicker();
                              final XFile? result = await picker.pickVideo(
                                  source: ImageSource.camera,
                                  maxDuration: const Duration(seconds: 10));

                              // final result = await ImagePickerDialog.pickImage(context);
                              String base64Image = '';

                              if (result != null) {
                                // _controller.initialize().then((_) {
                                //   setState(() {});
                                //   _controller.play();
                                // });
                                log('masukk');
                                List<int> imageBytes =
                                    await result.readAsBytes();
                                log('masukk2');
                                setState(() {
                                  fileSelfie = result.path;
                                  _controller = VideoPlayerController.file(
                                      File(result.path));
                                  _controller?.addListener(() {
                                    // setState(() {});
                                  });

                                  _controller?.setLooping(false);
                                  _controller?.initialize();
                                  _controller?.play();
                                  base64Image = base64Encode(imageBytes);
                                  fileSelfie64 =
                                      'data:video/mp4;base64,$base64Image';
                                  // log(" ini videoo " + fileSelfie64.toString());
                                });
                              }
                            },
                      child: widget.data.statusKyc1 == true
                          ? DottedBorder(
                              borderType: BorderType.RRect,
                              radius: const Radius.circular(8),
                              dashPattern: const [5, 5],
                              color: const Color(0xFF354150),
                              strokeWidth: 1,
                              child: fileSelfie == ''
                                  ? Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 24),
                                      width: double.infinity,
                                      child: Column(
                                        children: [
                                          Image.asset(
                                            'assets/icons/ic_video.png',
                                            width: 30,
                                            height: 30,
                                          ),
                                          const SizedBox(
                                            height: 8.0,
                                          ),
                                          Text(
                                            Languages.of(context).approved,
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.inter(
                                              color: const Color(0xFF67A353),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : SizedBox(
                                      height: 200,
                                      width: MediaQuery.of(context).size.width,
                                      child: Image.file(File(fileFront)),
                                    ),
                            )
                          : DottedBorder(
                              borderType: BorderType.RRect,
                              radius: const Radius.circular(8),
                              dashPattern: const [5, 5],
                              color: const Color(0xFF354150),
                              strokeWidth: 1,
                              child: fileSelfie == ''
                                  ? Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 24),
                                      width: double.infinity,
                                      child: Column(
                                        children: [
                                          const Icon(
                                            Icons.video_camera_back,
                                            color: Color(0xFF354150),
                                            size: 50,
                                          ),
                                          const SizedBox(
                                            height: 8.0,
                                          ),
                                          Text(
                                            Languages.of(context)
                                                .tapHereToUpload,
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.inter(
                                              color: const Color(0xFF7D8998),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 8.0,
                                          ),
                                          Text(
                                            Languages.of(context).uploadSelfie,
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.inter(
                                              color: const Color(0xFF7D8998),
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10.0,
                                          ),
                                          Text(
                                            Languages.of(context).followingWord,
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.inter(
                                              color: const Color(0xFF7D8998),
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5.0,
                                          ),
                                          // Text(
                                          //   '8-10s long tu (我“名字”已向 EZ-LEND公司借錢貸款', //'Upload a selfie video around 8-10 seconds',
                                          //   textAlign: TextAlign.center,
                                          //   style: GoogleFonts.inter(
                                          //     color: const Color(0xFF7D8998),
                                          //     fontSize: 12,
                                          //     fontWeight: FontWeight.w400,
                                          //   ),
                                          // )
                                        ],
                                      ),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      child: Stack(
                                        children: [
                                          AspectRatio(
                                            aspectRatio:
                                                _controller!.value.aspectRatio,
                                            child: Stack(
                                              alignment: Alignment.bottomCenter,
                                              children: <Widget>[
                                                VideoPlayer(_controller!),
                                                ControlsOverlay(
                                                    controller: _controller!),
                                                VideoProgressIndicator(
                                                    _controller!,
                                                    allowScrubbing: true),
                                              ],
                                            ),
                                          ),
                                          Positioned(
                                            top: 8,
                                            right: 8,
                                            child: IconButton(
                                              icon: const Icon(Icons.close,
                                                  color: Colors.white),
                                              onPressed: () {
                                                setState(() {
                                                  fileSelfie = '';
                                                  _controller?.pause();
                                                  _controller = null;
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                              // SizedBox(
                              //     height: 200,
                              //     width: MediaQuery.of(context).size.width,
                              //     child: AspectRatio(
                              //       aspectRatio: _controller!.value.aspectRatio,
                              //       child: VideoPlayer(_controller!),
                              //     ),
                              //   ),
                            ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      errors?['KycFile[0][file]'] != null
                          ? errors!['KycFile[0][file]'][0]
                          : '',
                    ),
                    const SizedBox(
                      height: 25.0,
                    ),
                    // Text(
                    //   'Bank Account Details',
                    //   style: GoogleFonts.inter(
                    //     color: Colors.white,
                    //     fontSize: 24,
                    //     fontWeight: FontWeight.w600,
                    //   ),
                    // ),
                    // const SizedBox(
                    //   height: 20.0,
                    // ),
                    // Text(
                    //   'Bank Name',
                    //   style: GoogleFonts.inter(
                    //     color: Colors.white,
                    //     fontSize: 14,
                    //     fontWeight: FontWeight.w400,
                    //   ),
                    // ),
                    // const SizedBox(
                    //   height: 8.0,
                    // ),
                    // MainTextFormField(
                    //   controller: bankName,
                    //   hintText: 'Bank Name',
                    // ),
                    // const SizedBox(
                    //   height: 25.0,
                    // ),
                    // Text(
                    //   'Bank Account Holder',
                    //   style: GoogleFonts.inter(
                    //     color: Colors.white,
                    //     fontSize: 14,
                    //     fontWeight: FontWeight.w400,
                    //   ),
                    // ),
                    // const SizedBox(
                    //   height: 8.0,
                    // ),
                    // MainTextFormField(
                    //   controller: accountName,
                    //   hintText: 'Bank Account Holder',
                    // ),
                    // const SizedBox(
                    //   height: 25.0,
                    // ),
                    // Text(
                    //   'Bank Account Number',
                    //   style: GoogleFonts.inter(
                    //     color: Colors.white,
                    //     fontSize: 14,
                    //     fontWeight: FontWeight.w400,
                    //   ),
                    // ),
                    // const SizedBox(
                    //   height: 8.0,
                    // ),
                    // MainTextFormField(
                    //   controller: accountNumber,
                    //   hintText: 'Bank Account Number',
                    // ),
                    // const SizedBox(
                    //   height: 25.0,
                    // ),
                    // BlocConsumer<KycBloc, KycState>(
                    //   bloc: kycBloc,
                    //   listener: (context, state) {
                    //     final errors =
                    //         (state is PostKycError) ? state.errors : {};
                    //     if (state is PostKycSuccess) {
                    //       // EasyLoading.dismiss();
                    //       transactionBloc.add(PostLoanEvent(
                    //         packageId: widget.nominal.id.toString(),
                    //         dateLoan:
                    //             DateFormat('yyyy-MM-dd').format(DateTime.now()),
                    //       ));
                    //     } else if (state is PostKycError) {
                    //       EasyLoading.dismiss();

                    //       GlobalFunction()
                    //           .allDialog(context, title: state.message);
                    //     }
                    //     // TODO: implement listener
                    //   },
                    //   builder: (context, state) {
                    // return
                    MainButtonGradient(
                      title: state is PostKycLoading ||
                              state is PostResubmitKycLoading
                          ? Languages.of(context).loading
                          : Languages.of(context).submit,
                      onTap: () {
                        // log(Member(
                        //   bankAccountName: accountName.text,
                        //   bankAccountNumber: accountNumber.text,
                        //   bankName: bankName.text,
                        //   benefiaryContact: benefiaryContact.text,
                        //   benefiaryName: benefiaryName.text,
                        //   beneficiaryRelationship: 'anak',
                        //   fullname: namePerId.text,
                        // ).toString());
                        // transactionBloc.add(PostLoanEvent(
                        //     packageId: widget.nominal.id ?? 0,
                        //     packageRateId: 1,
                        //     remark: widget.nominal.remark ?? ''));

                        if (widget.data.isRejected) {
                          List<KycFileResubmit>? kycFileResubmitTemp = [];
                          if (fileSelfie64.isNotEmpty) {
                            kycFileResubmitTemp.add(
                                KycFileResubmit(file: fileSelfie64, type: '1'));
                          }

                          if (fileFront64.isNotEmpty) {
                            kycFileResubmitTemp.add(
                                KycFileResubmit(file: fileFront64, type: '2'));
                          }

                          if (fileBack64.isNotEmpty) {
                            kycFileResubmitTemp.add(
                                KycFileResubmit(file: fileBack64, type: '3'));
                          }

                          kycBloc.add(PostResubmitKycEvent(
                              data: RequestResubmitKyc(
                                  memberResubmit: MemberResubmit(),
                                  kycFileResubmit: kycFileResubmitTemp)));
                        } else {
                          if (fileSelfie64.isEmpty ||
                              fileBack64.isEmpty ||
                              fileFront64.isEmpty) {
                            GlobalFunction().allDialog(context,
                                isError: true,
                                title: Languages.of(context)
                                    .pleaseUploadAllRequiredDocuments);
                          } else {
                            kycBloc.add(PostKycEvent(
                                data: RequestKyc(
                                    member: Member(
                                      bankAccountName: widget.data.accountName,
                                      bankAccountNumber:
                                          widget.data.accountNumber,
                                      bankName: widget.data.bankName,
                                      benefiaryContact:
                                          widget.data.benefiaryContact,
                                      benefiaryName: widget.data.benefiaryName,
                                      beneficiaryRelationship:
                                          widget.data.beneficiaryRelationship,
                                      fullname: widget.data.namePerId,
                                    ),
                                    kycFile: [
                                  KycFile(file: fileSelfie64, type: '1'),
                                  KycFile(file: fileFront64, type: '2'),
                                  KycFile(file: fileBack64, type: '3'),
                                ])));
                            EasyLoading.show(
                                maskType: EasyLoadingMaskType.black);
                          }
                        }
                      },
                    )
                    //   },
                    // )
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
