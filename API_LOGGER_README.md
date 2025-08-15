# API Logger Documentation

## Overview
API Logger adalah utility untuk debugging HTTP requests/responses dengan format yang rapi dan pretty JSON formatting. Logger ini hanya aktif dalam debug mode (`kDebugMode = true`) dan tidak akan mempengaruhi performance aplikasi production.

## Features
- ✅ Pretty JSON formatting dengan indentasi
- ✅ Automatic request/response logging via Dio interceptor
- ✅ Sensitive data masking (Authorization tokens)
- ✅ Request duration tracking
- ✅ Comprehensive error logging dengan stack trace
- ✅ Debug mode only (production safe)
- ✅ Emoji icons untuk easy identification

## Auto Logging
API Logger secara otomatis akan log semua HTTP requests/responses yang melalui `NetworkHelper` karena sudah terintegrasi dengan Dio interceptor.

### Sample Output
```
================================================================================
📤 API REQUEST
----------------------------------------
🌐 Method: POST
🔗 URL: https://api.example.com/v1/member/auth/login
📋 Headers:
    Content-Type: application/json
    Authorization: Bearer eyJhbGci...***
📦 Request Body:
{
  "ic": "A1234567",
  "phone": "1234567890"
}
================================================================================

================================================================================
📥 API RESPONSE
----------------------------------------
🌐 Method: POST
🔗 URL: https://api.example.com/v1/member/auth/login
📊 Status: 200 OK
⏱️  Duration: 1250ms
📦 Response Body:
{
  "success": true,
  "data": {
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "user": {
      "id": 123,
      "ic": "A1234567"
    }
  }
}
================================================================================
```

## Manual Logging
Anda juga bisa menggunakan manual logging untuk debugging custom messages:

### Import
```dart
import 'package:loan_project/helper/api_logger.dart';
```

### Usage Examples

#### 1. Simple Debug Message
```dart
ApiLogger.logMessage('User login successful', tag: 'AUTH');
```

#### 2. Logging dengan Custom Tag
```dart
ApiLogger.logMessage('Starting KYC validation process', tag: 'KYC');
```

#### 3. Logging Object/Data
```dart
final userData = {'id': 123, 'name': 'John'};
ApiLogger.logMessage('User data: ${jsonEncode(userData)}', tag: 'USER');
```

## Integration dengan Service Layer

Contoh penggunaan di service classes:

```dart
import 'package:loan_project/helper/api_logger.dart';
import 'package:loan_project/helper/network_helper.dart';

class ApiServiceAuth {
  final NetworkHelper _dio = NetworkHelper();

  Future<Response> login({required String ic, required String phone}) async {
    // Log untuk debugging login attempt
    ApiLogger.logMessage('Attempting login for IC: $ic', tag: 'AUTH');
    
    final response = await _dio
        .post('v1/member/auth/login', data: {'ic': ic, 'phone': phone});
    
    // Automatic logging handled by interceptor
    return response;
  }
}
```

## Security Features

### 1. Sensitive Data Masking
Authorization headers otomatis di-mask:
```
Original: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
Logged:   Bearer eyJhbGci...***
```

### 2. Production Safety
```dart
if (!kDebugMode) return; // Tidak ada logging di production
```

### 3. Stack Trace Limiting
Error stack traces dibatasi hanya 10 baris pertama untuk menghindari log yang terlalu panjang.

## Configuration

API Logger sudah terintegrasi dengan `NetworkHelper` melalui Dio interceptor. Tidak perlu konfigurasi tambahan.

### Lokasi File
- Main Logger: `lib/helper/api_logger.dart`
- Integration: `lib/helper/network_helper.dart` (interceptor)

## Log Filtering di Console

Untuk memfilter log di console, gunakan nama logger:
- `API_REQUEST` - untuk request logs
- `API_RESPONSE` - untuk response logs  
- `API_ERROR` - untuk error logs
- Custom tags - untuk manual logging

## Best Practices

1. **Gunakan manual logging untuk business logic debugging**
   ```dart
   ApiLogger.logMessage('Payment calculation started', tag: 'PAYMENT');
   ```

2. **Tambahkan context yang berguna**
   ```dart
   ApiLogger.logMessage('KYC validation failed for user $userId', tag: 'KYC');
   ```

3. **Gunakan tags yang konsisten**
   - `AUTH` - Authentication related
   - `KYC` - KYC processes
   - `PAYMENT` - Payment related
   - `LOAN` - Loan operations
   - `USER` - User operations

4. **Jangan log sensitive data secara manual**
   ```dart
   // ❌ Bad
   ApiLogger.logMessage('Password: $password', tag: 'AUTH');
   
   // ✅ Good
   ApiLogger.logMessage('Password validation completed', tag: 'AUTH');
   ```

## Troubleshooting

### 1. Logs tidak muncul
- Pastikan `kDebugMode = true` di `lib/helper/constants.dart`
- Pastikan running dalam debug mode (`flutter run --debug`)

### 2. JSON tidak ter-format dengan rapi
- ApiLogger otomatis handle JSON formatting
- Pastikan data adalah valid JSON

### 3. Authorization tokens masih terlihat penuh
- Pastikan header menggunakan nama yang mengandung "authorization"
- Case-insensitive, jadi "Authorization", "AUTHORIZATION", dll akan di-mask

Dengan API Logger ini, debugging HTTP requests/responses menjadi lebih mudah dan terorganisir!
