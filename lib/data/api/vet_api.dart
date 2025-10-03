import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/api_base.dart'; // donde está resolveBaseUrl()

int _toInt(dynamic v) {
  if (v is int) return v;
  if (v is num) return v.toInt();
  if (v is String && v.isNotEmpty) return int.parse(v);
  throw FormatException('No pude convertir "$v" a int');
}

double _toDouble(dynamic v) {
  if (v is double) return v;
  if (v is num) return v.toDouble();
  if (v is String && v.trim().isNotEmpty) return double.parse(v);
  throw FormatException('No pude convertir "$v" a double');
}

String _toStringOrEmpty(dynamic v) => (v ?? '').toString();

double _pickLat(Map<String, dynamic> j) {
  if (j.containsKey('latitud')) return _toDouble(j['latitud']);
  if (j.containsKey('lat')) return _toDouble(j['lat']);
  throw const FormatException('Falta lat/latitud');
}

double _pickLon(Map<String, dynamic> j) {
  if (j.containsKey('longitud')) return _toDouble(j['longitud']);
  if (j.containsKey('lon')) return _toDouble(j['lon']);
  throw const FormatException('Falta lon/longitud');
}

class Vet {
  final int id;
  final String nombre;
  final double lat, lon;
  final String? municipio, localidad, cp;

  /// En modo agregado trae el conteo; en detalle viene null.
  final int? total;

  Vet({
    required this.id,
    required this.nombre,
    required this.lat,
    required this.lon,
    this.municipio,
    this.localidad,
    this.cp,
    this.total,
  });

  factory Vet.fromJson(Map<String, dynamic> j) {
    int safeId() {
      final v = j['id'];
      if (v is int) return v;
      if (v is num) return v.toInt();
      if (v is String) {
        // hash string → entero estable
        return v.codeUnits.fold<int>(0, (h, c) => (h * 31 + c) & 0x7fffffff);
      }
      throw const FormatException('id inválido');
    }

    return Vet(
      id: safeId(),
      nombre: _toStringOrEmpty(j['nombre']),
      lat: _pickLat(j),
      lon: _pickLon(j),
      municipio: j['municipio'] as String?,
      localidad: j['localidad'] as String?,
      cp: j['codigo_postal'] as String?,
      total: j['total'] == null ? null : _toInt(j['total']),
    );
  }
}

class VetApi {
  final String baseUrl;
  final http.Client _client;

  VetApi({http.Client? client})
    : baseUrl = resolveBaseUrl(),
      _client = client ?? http.Client();

  /// ❌ Si no vas a enviar bbox, elimina este método o úsalo solo para debugging con un bbox fijo.
  Future<List<Vet>> listDebugWithBbox({
    required double s,
    required double w,
    required double n,
    required double e,
    int limit = 200,
  }) async {
    final uri = Uri.parse(
      '$baseUrl/api/v1/veterinarias',
    ).replace(queryParameters: {'bbox': '$s,$w,$n,$e', 'limit': '$limit'});

    final res = await _client.get(uri).timeout(const Duration(seconds: 12));
    if (res.statusCode != 200) {
      throw Exception('HTTP ${res.statusCode}: ${res.body}');
    }
    final List data = json.decode(res.body);
    return data.map((e) => Vet.fromJson(e as Map<String, dynamic>)).toList();
  }

  /// ✅ Detalle por BBOX (puntos individuales)
  Future<List<Vet>> listByBbox({
    required double s,
    required double w,
    required double n,
    required double e,
    int limit = 800,
    String? q,
  }) async {
    final qp = <String, String>{
      'bbox': '$s,$w,$n,$e', // 👈 así lo espera el backend
      'limit': '$limit',
      if (q != null && q.isNotEmpty) 'q': q,
    };

    final uri = Uri.parse(
      '$baseUrl/api/v1/veterinarias',
    ).replace(queryParameters: qp);
    final res = await _client.get(uri).timeout(const Duration(seconds: 12));
    if (res.statusCode != 200) {
      throw Exception('HTTP ${res.statusCode}: ${res.body}');
    }
    final List data = json.decode(res.body);
    return data.map((e) => Vet.fromJson(e as Map<String, dynamic>)).toList();
  }

  /// ✅ Agregado por grilla (centroides con contador `total`)
  Future<List<Vet>> listAggregatedByBbox({
    required double s,
    required double w,
    required double n,
    required double e,
    required int precision, // 0..6
    int limit = 2000,
  }) async {
    final qp = <String, String>{
      's': '$s',
      'w': '$w',
      'n': '$n',
      'e': '$e',
      'precision': '$precision',
      'limit': '$limit',
    };

    final uri =
        Uri.parse('$baseUrl/api/v1/veterinarias/agg') // 👈 ruta correcta
            .replace(queryParameters: qp);

    final res = await _client.get(uri).timeout(const Duration(seconds: 12));
    if (res.statusCode != 200) {
      throw Exception('HTTP ${res.statusCode}: ${res.body}');
    }
    final List data = json.decode(res.body);
    return data.map((e) => Vet.fromJson(e as Map<String, dynamic>)).toList();
  }

  void dispose() {
    _client.close();
  }
}
