import 'dart:developer';
import 'dart:io';

import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:loan_project/helper/languages.dart';
import 'package:loan_project/widget/main_button_gradient.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:restart_app/restart_app.dart';
import 'package:url_launcher/url_launcher.dart';

class GlobalFunction {
  void restartApp() {
    if (Platform.isAndroid) {
      // For Android, use the following code to restart the app
      SystemNavigator.pop();
    } else if (Platform.isIOS) {
      // For iOS, use the following code to restart the app
      exit(0);
    }
  }

  void showPermissionUI(BuildContext context, {String? title}) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            title: Text(Languages.of(context).permissionRequired),
            content: Text(Languages.of(context).thisAppRequires),
            actions: <Widget>[
              TextButton(
                child: Text(Languages.of(context).allow),
                onPressed: () async {
                  // Open app settings

                  PermissionStatus status;
                  if (title == Languages.of(context).contact) {
                    status = await Permission.contacts.status;
                    log("Contact permission status: $status");
                  } else if (title == Languages.of(context).callLog) {
                    status = await Permission.phone.status;
                    log("Call log permission status: $status");
                  } else {
                    status = await Permission.photos.status;
                    log("Photo permission status: $status");
                  }
                  var callLogStatus = await Permission.phone.request();

                  // Check if permission is granted, then close the dialog
                  if (status.isGranted && callLogStatus.isGranted) {
                    // Navigator.of(context).pop();
                    Restart.restartApp();
                  } else if (status.isDenied) {
                    if (title == Languages.of(context).contact) {
                      await Permission.contacts.request();
                      log("Contact permission status: $status");
                    } else if (title == Languages.of(context).callLog) {
                      await Permission.phone.request();
                      log("Call log permission status: $status");
                    } else {
                      if (status.isDenied) {
                        await openAppSettings();
                        PermissionStatus statusPhone = await Permission.phone.status;
                        PermissionStatus statusPhotos = await Permission.photos.status;
                        PermissionStatus statusGallery = await Permission.manageExternalStorage.status;
                        PermissionStatus statusContact = await Permission.contacts.status;
                        if (!statusPhone.isGranted ||
                            !statusPhotos.isGranted ||
                            !statusGallery.isGranted ||
                            !statusContact.isGranted) {
                          await openAppSettings();
                        } else {
                          restartApp();
                        }
                        // await fetchData();
                      }
                    }
                  } else {
                    await openAppSettings();
                    if (title == 'contact') {
                      status = await Permission.contacts.status;
                      log("Contact permission status: $status");
                    } else if (title == Languages.of(context).callLog) {
                      status = await Permission.phone.status;
                      log("Call log permission status: $status");
                    } else {
                      status = await Permission.photos.status;
                      log("Photo permission status: $status");
                    }
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void openSettings() {
    openAppSettings();
  }

  Future<dynamic> allDialog(BuildContext context,
      {String? title,
      String? subtitle,
      String? titleButton,
      Widget? iconWidget,
      bool isError = false,
      Function()? onTap,
      Widget? titleWidget,
      bool? barrierDismissible,
      Widget? buttonWidget}) {
    return showDialog(
      context: context,
      barrierDismissible: barrierDismissible ?? true,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF252422),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Container(
            padding: const EdgeInsets.all(10),
            color: const Color(0xFF252422),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 20.0,
                ),
                isError
                    ? const Icon(
                        Icons.error,
                        color: Colors.red,
                        size: 30,
                      )
                    : iconWidget ??
                        Image.asset(
                          'assets/icons/ic_done.png',
                          width: 101,
                        ),
                const SizedBox(
                  height: 20.0,
                ),
                titleWidget ??
                    Text(
                      title ?? '',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontFamily: 'Alata',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                const SizedBox(
                  height: 4.0,
                ),
                SizedBox(
                  width: 212,
                  child: Text(
                    subtitle ?? '',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFF7D8998),
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 34.0,
                ),
                buttonWidget ??
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MainButtonGradient(
                          width: 200,
                          onTap: onTap ??
                              () {
                                context.pop();
                              },
                          title: titleButton ?? 'Ok',
                        ),
                      ],
                    )
              ],
            ),
          ),
        );
      },
    );
  }

  Future<dynamic> rejectCodeDialog(BuildContext context,
      {String? title,
      String? subtitle,
      String? titleButton,
      Widget? iconWidget,
      bool isError = false,
      Function()? onTap,
      Widget? titleWidget,
      bool? barrierDismissible,
      Widget? buttonWidget}) {
    return showDialog(
      context: context,
      barrierDismissible: barrierDismissible ?? true,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF252422),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Container(
            padding: const EdgeInsets.all(10),
            color: const Color(0xFF252422),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 20.0,
                ),
                titleWidget ??
                    Text(
                      title ?? '',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'Alata',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                const SizedBox(
                  height: 4.0,
                ),
                SizedBox(
                  width: 212,
                  child: Text(
                    subtitle ?? '',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFF7D8998),
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 34.0,
                ),
                buttonWidget ??
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MainButtonGradient(
                          width: 200,
                          onTap: onTap ??
                              () {
                                context.pop();
                              },
                          title: titleButton ?? 'Ok',
                        ),
                      ],
                    )
              ],
            ),
          ),
        );
      },
    );
  }

  Future<dynamic> rejectCodeKycDialog(BuildContext context,
      {String? title,
      List<dynamic>? subtitle,
      String? titleButton,
      Widget? iconWidget,
      bool isError = false,
      Function()? onTap,
      Widget? titleWidget,
      bool? barrierDismissible,
      Widget? buttonWidget}) {
    return showDialog(
      context: context,
      barrierDismissible: barrierDismissible ?? true,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF252422),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Container(
            color: const Color(0xFF252422),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 20.0,
                ),
                titleWidget ??
                    Text(
                      title ?? '',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'Alata',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                const SizedBox(
                  height: 4.0,
                ),
                SizedBox(
                  width: 212,
                  height: MediaQuery.of(context).size.height * 0.15,
                  child: ListView.separated(
                    shrinkWrap: true,
                    separatorBuilder: (context, index) {
                      return const Divider();
                    },
                    itemCount: subtitle == null ? 0 : subtitle.length,
                    physics: const ScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      // Menambahkan angka berurutan
                      int itemNumber = index + 1;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '$itemNumber. ${subtitle?[index]['unique_code'] ?? ''}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Color(0xFF7D8998),
                              fontSize: 14,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 34.0,
                ),
                buttonWidget ??
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MainButtonGradient(
                          width: 200,
                          onTap: onTap ??
                              () {
                                context.pop();
                              },
                          title: titleButton ?? 'Ok',
                        ),
                      ],
                    )
              ],
            ),
          ),
        );
      },
    );
  }

  String formattedMoney(double? money) {
    String value = NumberFormat("#,##0.00", "zh_HK").format(money ?? 0);

    final moneyStr = (money ?? 0).toString();
    final moneys = moneyStr.split(".");

    if (moneys.length == 2) {
      if (moneys[1].length == 1 && moneys[1] != "0") {
        value = "${value}0";
      }
    }

    return value == "NaN" ? "0" : value;
    // return value;
    // == "NaN" ? "0" : value;
  }

  String getStatus(int? status, BuildContext context) {
    String statusString;
    switch (status) {
      case 0:
        statusString = Languages.of(context).pending;
        break;
      case 2:
        statusString = Languages.of(context).paid;
        break;
      case 3:
        statusString = Languages.of(context).rejected;
        break;
      // Anda dapat menambahkan kondisi tambahan sesuai kebutuhan
      default:
        statusString = Languages.of(context).pending;
    }
    return statusString;
  }

  String getStatusDetail(int? status, BuildContext context) {
    String statusString;
    switch (status) {
      case 0:
        statusString = Languages.of(context).pending;
        break;
      case 1:
        statusString = Languages.of(context).approved;
        break;
      case 2:
        statusString = Languages.of(context).approved;
        break;
      case 3:
        statusString = Languages.of(context).rejected;
        break;
      // Anda dapat menambahkan kondisi tambahan sesuai kebutuhan
      default:
        statusString = Languages.of(context).wireTransfer;
    }
    return statusString;
  }

  String getBankInfo(int? status, BuildContext context) {
    String statusString;
    switch (status) {
      case 0:
        statusString = Languages.of(context).wireTransfer;
        break;
      case 1:
        statusString = Languages.of(context).manualBanking;
        break;

      // Anda dapat menambahkan kondisi tambahan sesuai kebutuhan
      default:
        statusString = Languages.of(context).wireTransfer;
    }
    return statusString;
  }

  String getStatusKyc(int? status, context) {
    String statusString;
    switch (status) {
      case 0:
        statusString = Languages.of(context).pending;
        break;
      case 2:
        statusString = Languages.of(context).rejected;
        break;
      case 1:
        statusString = Languages.of(context).approved;
        break;
      // Anda dapat menambahkan kondisi tambahan sesuai kebutuhan
      default:
        statusString = Languages.of(context).pending;
    }
    return statusString;
  }

  Future<void> openUrl(String url) async {
    final url0 = Uri.parse(url);
    if (!await launchUrl(url0, mode: LaunchMode.externalApplication)) {
      // <--
      throw Exception('Could not launch $url0');
    }
  }

  Row customerServiceButton(String url, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/icons/ic_phone.png',
          width: 22,
          height: 22,
        ),
        TextButton(
            onPressed: () {
              GlobalFunction().openUrl(url);
            },
            child: Text(
              Languages.of(context).customerService,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF1C64F2),
                fontSize: 18,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                decoration: TextDecoration.underline,
              ),
            ))
      ],
    );
  }

  String getCallTypeString(int index) {
    CallType callType;

    try {
      callType = CallType.values[index];
    } catch (e) {
      return 'Invalid Index';
    }

    switch (callType) {
      case CallType.incoming:
        return 'Incoming Call';
      case CallType.outgoing:
        return 'Outgoing Call';
      case CallType.missed:
        return 'Missed Call';
      case CallType.voiceMail:
        return 'Voicemail Call';
      case CallType.rejected:
        return 'Rejected Call';
      case CallType.blocked:
        return 'Blocked Call';
      case CallType.answeredExternally:
        return 'Answered Externally';
      case CallType.unknown:
        return 'Unknown Call';
      case CallType.wifiIncoming:
        return 'WiFi Incoming Call';
      case CallType.wifiOutgoing:
        return 'WiFi Outgoing Call';
      default:
        return 'Invalid Call Type';
    }
  }

  void showToast(message, {bgColor, txtColor, ToastGravity gravity = ToastGravity.BOTTOM}) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: gravity,
      timeInSecForIosWeb: 1,
      backgroundColor: bgColor,
      // ?? kPrimaryColor,
      textColor: txtColor ?? Colors.white,
      fontSize: 12.0,
    );
  }

  String translateRelationship(BuildContext context, String? key) {
    switch (key?.toLowerCase()) {
      case 'parents':
        return Languages.of(context).parents;
      case 'spouse':
        return Languages.of(context).spouse;
      case 'children':
        return Languages.of(context).children;
      default:
        return key ?? '';
    }
  }
}
