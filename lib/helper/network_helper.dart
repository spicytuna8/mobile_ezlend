import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:loan_project/flavor.dart';
import 'package:loan_project/helper/preference_helper.dart';
import 'package:loan_project/helper/router.dart';
import 'package:loan_project/helper/router_name.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Import API Logger
import 'api_logger.dart';

class NetworkHelper {
  static const String divider = "\n------------------------------------";
  static final Dio _dio = Dio();
  final context = navigatorKey.currentContext;

  /// DEMO URL

  // final String baseApi = 'https://test-api.ez-lend.loans/';
  final String baseApi = F.baseUrl;
  // final String baseApi = 'https://elend.cgtechnology.io/';

  /// LIVE URL
  // final String baseApi = F.baseUrl;

  // static final NetworkHelper _instance = NetworkHelper.internal();
  // NetworkHelper.internal();
  // factory NetworkHelper() => _instance;

  // final _dio = DioUtil.getInstance();

  static const TOKEN = "Token";
  static const _connectTimeoutDefault = Duration(seconds: 60);
  static const _receiveTimeoutDefault = Duration(seconds: 60);
  static const _sendTimeoutDefault = Duration(seconds: 60);

  //  final _d = client(isUseToken: true, connectTimeout: _connectTimeoutDefault, receiveTimeout: _receiveTimeoutDefault, sendTimeout: _sendTimeoutDefault);

  String _formDataToJson(FormData formData) {
    final fields = formData.fields;
    final files = formData.files;
    final map = <String, String>{};

    for (MapEntry<String, String> field in fields) {
      map[field.key] = field.value;
    }

    for (MapEntry<String, MultipartFile> file in files) {
      map[file.key] = file.value.filename ?? '';
    }

    return json.encode(map);
  }

  Future<Response> get(String endpoint,
      {bool isUseToken = true, Map<String, dynamic>? params, Function(int, int)? progress, Options? options}) async {
    PreferencesHelper preferencesHelper = PreferencesHelper(sharedPreferences: SharedPreferences.getInstance());
    log('get');
    final dio = await client(isUseToken: isUseToken);

    dio.options.headers['Authorization'] = 'Bearer ${await preferencesHelper.getToken}';
    return await dio.get(baseApi + endpoint, queryParameters: params, onReceiveProgress: progress, options: options);
  }

  Future<Response> post(String endpoint,
      {bool isUseToken = true,
      Map<String, dynamic>? params,
      Function(int, int)? receiveProgress,
      Function(int, int)? progress,
      Options? options,
      dynamic data}) async {
    PreferencesHelper preferencesHelper = PreferencesHelper(sharedPreferences: SharedPreferences.getInstance());

    String token = await preferencesHelper.getToken;
    final dio = await client(isUseToken: isUseToken);
    // log("token ${dio.toString()}");

    dio.options.headers['Authorization'] = 'Bearer $token';
    return await dio.post(baseApi + endpoint,
        queryParameters: params,
        onReceiveProgress: receiveProgress,
        options: options,
        onSendProgress: progress,
        data: data);
  }

  Future<Response> postFormData(String endpoint,
      {bool isUseToken = true,
      Map<String, dynamic>? params,
      Function(int, int)? receiveProgress,
      Function(int, int)? progress,
      Options? options,
      dynamic data}) async {
    PreferencesHelper preferencesHelper = PreferencesHelper(sharedPreferences: SharedPreferences.getInstance());

    String token = await preferencesHelper.getToken;
    log("token $token");
    _dio.options.headers['Authorization'] = 'Bearer $token';
    _dio.options.headers['Content-Type'] = 'multipart/form-data';
    return await _dio.post(endpoint,
        queryParameters: params,
        onReceiveProgress: receiveProgress,
        options: options,
        onSendProgress: progress,
        data: data);
  }

  Future<Response> put(String endpoint,
      {bool isUseToken = true,
      Map<String, dynamic>? params,
      Function(int, int)? receiveProgress,
      Function(int, int)? progress,
      Options? options,
      dynamic data}) async {
    PreferencesHelper preferencesHelper = PreferencesHelper(sharedPreferences: SharedPreferences.getInstance());

    _dio.options.headers['Authorization'] = 'Bearer ${await preferencesHelper.getToken}';
    return await _dio.put(baseApi + endpoint,
        queryParameters: params,
        onReceiveProgress: receiveProgress,
        onSendProgress: progress,
        options: options,
        data: data);
  }

  Future<Response> patch(String endpoint,
      {bool isUseToken = true,
      Map<String, dynamic>? params,
      Function(int, int)? receiveProgress,
      Function(int, int)? progress,
      Options? options,
      dynamic data}) async {
    PreferencesHelper preferencesHelper = PreferencesHelper(sharedPreferences: SharedPreferences.getInstance());

    _dio.options.headers['Authorization'] = 'Bearer ${await preferencesHelper.getToken}';
    return await _dio.patch(baseApi + endpoint,
        queryParameters: params,
        onReceiveProgress: receiveProgress,
        onSendProgress: progress,
        options: options,
        data: data);
  }

  Future<Response> delete(String endpoint,
      {bool isUseToken = true, Map<String, dynamic>? params, Options? options, dynamic data}) async {
    PreferencesHelper preferencesHelper = PreferencesHelper(sharedPreferences: SharedPreferences.getInstance());

    _dio.options.headers['Authorization'] = 'Bearer ${await preferencesHelper.getToken}';
    return await _dio.delete(baseApi + endpoint, queryParameters: params, options: options, data: data);
  }

  Future<Response> download(String endpoint,
      {bool isUseToken = true,
      savePath,
      dynamic data,
      Options? options,
      Function(int, int)? progress,
      Map<String, dynamic>? params}) async {
    PreferencesHelper preferencesHelper = PreferencesHelper(sharedPreferences: SharedPreferences.getInstance());

    _dio.options.headers['Authorization'] = 'Bearer ${await preferencesHelper.getToken}';
    return await _dio.download(endpoint, savePath,
        data: data, options: options, onReceiveProgress: progress, queryParameters: params);
  }

  Future<Dio> client(
      {isUseToken = true, Duration? connectTimeout, Duration? receiveTimeout, Duration? sendTimeout}) async {
    // final client = Dio();
    PreferencesHelper preferencesHelper = PreferencesHelper(sharedPreferences: SharedPreferences.getInstance());
    String token;
    if (isUseToken) {
      token = await preferencesHelper.getToken;
    } else {
      token = '';
    }
    _dio.interceptors.add(interceptor(token,
        connectTimeout: connectTimeout ?? _connectTimeoutDefault,
        receiveTimeout: receiveTimeout ?? _receiveTimeoutDefault,
        sendTimeout: sendTimeout ?? _sendTimeoutDefault));
    return _dio;
  }

//   @deprecated
//   static Dio clientCrud() {
//     final client = Dio();
//     client.interceptors.add(crudInterceptor());
//     return client;
//   }

//   @deprecated
//   static Dio clientUpload() {
//     final client = Dio();
//     client.interceptors.add(uploadInterceptor());
//     return client;
//   }

  InterceptorsWrapper interceptor(String token,
      {Duration connectTimeout = _connectTimeoutDefault,
      Duration receiveTimeout = _receiveTimeoutDefault,
      Duration sendTimeout = _sendTimeoutDefault}) {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Log request dengan format yang rapi
        ApiLogger.logRequest(options);

        // String? token = await StorageService().readAccessToken();
        // options.headers['Authorization'] = 'Bearer $token';
        return handler.next(options);
      },
      onResponse: (options, handler) {
        // Log response dengan format yang rapi
        ApiLogger.logResponse(options);

        return handler.next(options);
      },
      onError: (DioException e, handler) async {
        EasyLoading.dismiss();

        // Log error dengan format yang rapi
        ApiLogger.logError(e);

        // log(e.response!.data.toString());
        if (e.response != null) {
          final PreferencesHelper preferencesHelper =
              PreferencesHelper(sharedPreferences: SharedPreferences.getInstance());
          // ApiServiceAuth apiServiceAuth = ApiServiceAuth();
          // log('masuk error dio ga? ${e.response?.statusCode}');
          if (e.response?.statusCode == 401) {
            preferencesHelper.removeStringSharedPref('access_token');
            // log('masuk error dio ga 401?');
            // GoRoute(path: login);
            context!.pushNamed(login);

            // Navigation.pushNoData(loginRoute);
          } else {
            // log('message else 2');
            handler.next(e);
          }
        }
      },
    );
  }

//   @deprecated
//   static InterceptorsWrapper crudInterceptor() {
//     return InterceptorsWrapper(onRequest: (RequestOptions options,
//         RequestInterceptorHandler requestInterceptorHandler) {
//       final token = LocalHelper.getSession(TOKEN, defaultValue: null);

//       options.connectTimeout = 60000; //60s
//       options.receiveTimeout = 60000;
//       options.sendTimeout = 60000;
//       if (token != null) options.headers["Authorization"] = token;
//       if (token != null) options.headers["token"] = token;
//       final data = (options.data is FormData)
//           ? _formDataToJson(options.data as FormData)
//           : json.encode(options.data);

//       var logRequest =
//           "$divider\nRequest (${options.method}) : ${options.path} \n[Headers] : ${json.encode(options.headers)} \n[Params] : ${json.encode(options.queryParameters)} \n[Body] : $data \n$divider";
//       print(logRequest);

//       return options;
//     }, onResponse: (Response response,
//         ResponseInterceptorHandler responseInterceptorHandler) {
//       var logResponse =
//           "$divider\nResponse (${response.statusCode}) : ${json.encode(response.data)}\n$divider";
//       print(logResponse);

//       return response;
//     }, onError: (DioError error, ErrorInterceptorHandler) {
//       var logError = "$divider\nError : \nMessage : ${error.message}";

//       print(logError);

//       if (error.response != null) {
//         var errorResponse =
//             "Request : ${error.response.request.toString()}Headers : ${error.response.headers.toString()}Params: ${error.response.toString()}Data : ${json.encode(error.response.data)}";
//         print(errorResponse);
//       }

//       print("\n$divider");
//       return error;
//     });
//   }

//   @deprecated
//   static InterceptorsWrapper uploadInterceptor() {
//     return InterceptorsWrapper(onRequest: (RequestOptions options,
//         RequestInterceptorHandler requestInterceptorHandler) {
//       final token = LocalHelper.getSession(TOKEN, defaultValue: null);

//       options.connectTimeout = 120000; //2m
//       options.receiveTimeout = 120000;
//       options.sendTimeout = 120000;
//       if (token != null) options.headers["Authorization"] = token;
//       if (token != null) options.headers["token"] = token;
//       final data = (options.data is FormData)
//           ? _formDataToJson(options.data as FormData)
//           : options.data.toString();

//       var logRequest =
//           "Request (${options.method}) : ${options.path} \n[Headers] : ${json.encode(options.headers)} \n[Params] : ${json.encode(options.queryParameters)} \n[Body] : $data \n";
//       print(logRequest);

//       return options;
//     }, onResponse: (Response response, ResponseInterceptorHandler) {
//       var logResponse =
//           "Response (${response.statusCode}) : ${json.encode(response.data)}";
//       print(logResponse);

//       return response;
//     }, onError: (DioError error) {
//       var logError = "Error : \n"
//           "Message : ${error.message}";

//       print(logError);

//       if (error.response != null) {
//         var errorResponse =
//             "Response : ${error.response.request.toString()}Headers : ${json.encode(error.response.headers.toString())}Data : ${json.encode(error.response.data)}";
//         print(errorResponse);
//       }
//       return error;
//     });
//   }
// }

// extension NetworkError on DioError {
//   Map<String, dynamic> toJson() {
//     if (CommonUtil.isJsonValid(response.data)) {
//       return response.data;
//     } else {
//       if (response.data is Map) {
//         return json.decode(json.encode(response.data));
//       } else {
//         if (CommonUtil.isJsonValid(response.data)) {
//           return json.decode(response.data);
//         } else {
//           final contentJson = <String, dynamic>{};
//           contentJson["code"] = response.statusCode;
//           contentJson["data"] = null;
//           contentJson["message"] = response.statusMessage;
//           contentJson["error"] = message;

//           return json.decode(json.encode(contentJson));
//         }
//       }
//     }
//   }
}

// Future<Response> refreshToken() async {
//   // Response? response;
//   // Repository repository = Repository();
//   var dio = Dio();
//   final Uri apiUrl = Uri.parse(BASE_API + "/auth/refresh");
//   // var refreshToken = GetStorage().read('refreshToken');
//   var accessToken = GetStorage().read('accessToken');
//   var sessionId = GetStorage().read('sessionId');
//   // dio.options.headers["Authorization"] = "Bearer " + refreshToken;
//   dio.options.headers["cookie"] = sessionId;

//   // log(accessToken + "access token");
//   // log(refreshToken + "refrseh token");
//   log(sessionId + "cookie token");
//   // try {
//   var response = await dio.postUri(apiUrl);
//   if (response.statusCode == 200 || response.statusCode == 201) {
//     ResponseLogin refreshTokenModel =
//         ResponseLogin.fromJson(jsonDecode(response.toString()));
//     var box = GetStorage();
//     log('berhasil ga ?');

//     box.write('accessToken', refreshTokenModel.accessToken);
//     // box.write('refreshToken', refreshTokenModel.refreshToken);
//     // return response;
//   } else {
//     log('berhasil else?');
//     print(response.toString()); //TODO: logout
//     // return response;
//   }
//   try {
//     return response;
//   } on DioError {
//     return response;
//   }
//   // }
//   // catch (e) {
//   //   print(e.toString()); //TODO: logout
//   //       return response!;

//   // }
// }

Future<Response> refreshToken() async {
  // Response? response;
  // Repository repository = Repository();
  var dio = Dio();
  final Uri apiUrl = Uri.parse("https://dev.api.alhikmah.capioteknologi.xyz/merchants/auth/token/refresh");

  // try {
  var response = await dio.postUri(apiUrl);
  PreferencesHelper preferencesHelper = PreferencesHelper(sharedPreferences: SharedPreferences.getInstance());
  if (response.statusCode == 200 || response.statusCode == 201) {
    preferencesHelper.setStringSharedPref('access_token', response.data['data']['access_token'].toString());
    preferencesHelper.setStringSharedPref('refresh_token', response.data['data']['refresh_token'].toString());
    preferencesHelper.setStringSharedPref('expires_at', response.data['data']['expires_at'].toString());
  } else {
    log('berhasil else?');
    print(response.toString()); //TODO: logout
    // return response;
  }
  try {
    return response;
  } on DioException {
    preferencesHelper.removeStringSharedPref('access_token');
    // Navigation.pushNoData(loginRoute);
    return response;
  }
  // }
  // catch (e) {
  //   print(e.toString()); //TODO: logout
  //       return response!;

  // }
}
