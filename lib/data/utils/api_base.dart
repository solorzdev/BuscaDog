// lib/data/api/api_base.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:universal_io/io.dart' as io;

/// ============================
/// Resolver la URL base
/// ============================
String resolveBaseUrl() {
  const port = 8080;

  if (kIsWeb) return 'http://localhost:$port'; // Flutter Web
  if (io.Platform.isAndroid) return 'http://10.0.2.2:$port'; // Emulador Android
  // iOS simulador, Windows/Mac/Linux desktop:
  return 'http://localhost:$port';

  // ⚠️ Para dispositivo físico:
  // return 'http://192.168.x.x:$port';
}

/// ============================
/// Excepción personalizada
/// ============================
class ApiException implements Exception {
  final int? status;
  final String message;
  final Uri uri;

  ApiException(this.message, {this.status, required this.uri});

  @override
  String toString() =>
      'ApiException(status: $status, uri: $uri, message: $message)';
}

/// ============================
/// Cliente base para APIs
/// ============================
class ApiBase {
  final String baseUrl;
  final Duration timeout;
  final Map<String, String> defaultHeaders;

  ApiBase({
    String? baseUrl,
    this.timeout = const Duration(seconds: 8),
    Map<String, String>? headers,
  }) : baseUrl = baseUrl ?? resolveBaseUrl(),
       defaultHeaders = {
         'Accept': 'application/json',
         'Content-Type': 'application/json',
         ...?headers,
       };

  Uri buildUri(String path, [Map<String, dynamic>? query]) {
    return Uri.parse('$baseUrl$path').replace(
      queryParameters: query?.map((k, v) => MapEntry(k, v?.toString() ?? '')),
    );
  }

  Future<List<dynamic>> getJsonList(
    String path, {
    Map<String, dynamic>? query,
  }) async {
    final uri = buildUri(path, query);
    final res = await http.get(uri, headers: defaultHeaders).timeout(timeout);

    if (res.statusCode != 200) {
      throw ApiException(
        'HTTP ${res.statusCode}: ${res.body}',
        status: res.statusCode,
        uri: uri,
      );
    }

    final body = jsonDecode(res.body);
    if (body is List) return body;
    throw ApiException(
      'Se esperaba una lista JSON',
      status: res.statusCode,
      uri: uri,
    );
  }

  Future<Map<String, dynamic>> getJsonMap(
    String path, {
    Map<String, dynamic>? query,
  }) async {
    final uri = buildUri(path, query);
    final res = await http.get(uri, headers: defaultHeaders).timeout(timeout);

    if (res.statusCode != 200) {
      throw ApiException(
        'HTTP ${res.statusCode}: ${res.body}',
        status: res.statusCode,
        uri: uri,
      );
    }

    final body = jsonDecode(res.body);
    if (body is Map<String, dynamic>) return body;
    throw ApiException(
      'Se esperaba un objeto JSON',
      status: res.statusCode,
      uri: uri,
    );
  }
}
