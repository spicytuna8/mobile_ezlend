import 'dart:convert';
import 'dart:developer' as dev;

import 'package:dio/dio.dart';
import 'package:loan_project/helper/constants.dart';

class ApiLogger {
  static const String _separator = '============';
  static const String _divider = '------------';

  /// Pretty print JSON dengan indentasi
  static String _prettyJson(dynamic data) {
    if (data == null) return 'null';

    try {
      if (data is String) {
        // Coba parse string sebagai JSON
        final decoded = jsonDecode(data);
        return const JsonEncoder.withIndent('  ').convert(decoded);
      } else {
        return const JsonEncoder.withIndent('  ').convert(data);
      }
    } catch (e) {
      // Jika bukan JSON valid, return as string
      return data.toString();
    }
  }

  /// Format headers untuk display yang rapi
  static String _formatHeaders(Map<String, dynamic>? headers) {
    if (headers == null || headers.isEmpty) return 'No headers';

    final buffer = StringBuffer();
    headers.forEach((key, value) {
      // Sembunyikan sensitive data
      if (key.toLowerCase().contains('authorization') && value is String) {
        final token = value.toString();
        if (token.startsWith('Bearer ') && token.length > 20) {
          value = 'Bearer ${token.substring(7, 15)}...***';
        }
      }
      buffer.writeln('    $key: $value');
    });

    return buffer.toString().trimRight();
  }

  /// Format Dio Headers untuk display yang rapi
  static String _formatDioHeaders(Headers? headers) {
    if (headers == null || headers.map.isEmpty) return 'No headers';

    final buffer = StringBuffer();
    headers.forEach((key, values) {
      var value = values.join(', ');
      // Sembunyikan sensitive data
      if (key.toLowerCase().contains('authorization') && value.isNotEmpty) {
        if (value.startsWith('Bearer ') && value.length > 20) {
          value = 'Bearer ${value.substring(7, 15)}...***';
        }
      }
      buffer.writeln('    $key: $value');
    });

    return buffer.toString().trimRight();
  }

  /// Log HTTP Request
  static void logRequest(RequestOptions options) {
    if (!kDebugMode) return;

    // Add start time for duration calculation
    options.extra['start_time'] = DateTime.now().millisecondsSinceEpoch;

    final buffer = StringBuffer();
    buffer.writeln(_separator);
    buffer.writeln('API REQUEST');
    buffer.writeln(_divider);
    buffer.writeln('Method: ${options.method}');
    buffer.writeln('URL: ${options.baseUrl}${options.path}');

    // Query Parameters
    if (options.queryParameters.isNotEmpty) {
      buffer.writeln('Query Params:');
      options.queryParameters.forEach((key, value) {
        buffer.writeln('    $key: $value');
      });
    }

    // Headers
    buffer.writeln('Headers:');
    buffer.writeln(_formatHeaders(options.headers));

    // Request Body
    if (options.data != null) {
      buffer.writeln('Request Body:');
      if (options.data is FormData) {
        final formData = options.data as FormData;
        buffer.writeln('    [FormData]');
        for (var field in formData.fields) {
          buffer.writeln('    ${field.key}: ${field.value}');
        }
        for (var file in formData.files) {
          buffer.writeln('    ${file.key}: [FILE] ${file.value.filename ?? 'unknown'}');
        }
      } else {
        buffer.writeln(_prettyJson(options.data));
      }
    }

    buffer.writeln(_separator);
    dev.log(buffer.toString(), name: 'API_REQUEST');
  }

  /// Log HTTP Response
  static void logResponse(Response response) {
    if (!kDebugMode) return;

    final startTime = response.requestOptions.extra['start_time'] as int? ?? DateTime.now().millisecondsSinceEpoch;
    final duration = DateTime.now().millisecondsSinceEpoch - startTime;

    final buffer = StringBuffer();
    buffer.writeln(_separator);
    buffer.writeln('API RESPONSE');
    buffer.writeln(_divider);
    buffer.writeln('Method: ${response.requestOptions.method}');
    buffer.writeln('URL: ${response.requestOptions.baseUrl}${response.requestOptions.path}');
    buffer.writeln('Status: ${response.statusCode} ${response.statusMessage ?? ''}');
    buffer.writeln('Duration: ${duration}ms');

    // Response Headers
    if (response.headers.map.isNotEmpty) {
      buffer.writeln('Response Headers:');
      buffer.writeln(_formatDioHeaders(response.headers));
    }

    // Response Body
    buffer.writeln('Response Body:');
    buffer.writeln(_prettyJson(response.data));

    buffer.writeln(_separator);
    dev.log(buffer.toString(), name: 'API_RESPONSE');
  }

  /// Log HTTP Error
  static void logError(DioException error) {
    if (!kDebugMode) return;

    final buffer = StringBuffer();
    buffer.writeln(_separator);
    buffer.writeln('API ERROR');
    buffer.writeln(_divider);
    buffer.writeln('Method: ${error.requestOptions.method}');
    buffer.writeln('URL: ${error.requestOptions.baseUrl}${error.requestOptions.path}');
    buffer.writeln('Error Type: ${error.type}');
    buffer.writeln('Message: ${error.message}');

    if (error.response != null) {
      buffer.writeln('Status: ${error.response!.statusCode} ${error.response!.statusMessage ?? ''}');

      // Error Response Headers
      if (error.response!.headers.map.isNotEmpty) {
        buffer.writeln('Error Headers:');
        buffer.writeln(_formatDioHeaders(error.response!.headers));
      }

      // Error Response Body
      if (error.response!.data != null) {
        buffer.writeln('Error Response:');
        buffer.writeln(_prettyJson(error.response!.data));
      }
    }

    // Stack trace untuk debugging lebih detail (hanya 10 baris pertama)
    buffer.writeln('Stack Trace (first 10 lines):');
    final stackLines = error.stackTrace.toString().split('\n');
    for (int i = 0; i < 10 && i < stackLines.length; i++) {
      buffer.writeln('    ${stackLines[i]}');
    }

    buffer.writeln(_separator);
    dev.log(buffer.toString(), name: 'API_ERROR');
  }

  /// Log simple message untuk debugging umum
  static void logMessage(String message, {String? tag}) {
    if (!kDebugMode) return;

    final buffer = StringBuffer();
    buffer.writeln(_divider);
    buffer.writeln('${tag ?? 'DEBUG'}: $message');
    buffer.writeln(_divider);
    dev.log(buffer.toString(), name: tag ?? 'DEBUG');
  }
}
