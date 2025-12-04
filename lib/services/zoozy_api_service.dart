import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:zoozy/models/api_models.dart';

class ZoozyApiService {
  ZoozyApiService({
    http.Client? client,
    String? baseUrl,
  })  : _client = client ?? http.Client(),
        _baseUrl = baseUrl ??
            const String.fromEnvironment(
              'ZOOZY_API_URL',
              defaultValue: 'https://localhost:5001/api',
            );

  final http.Client _client;
  final String _baseUrl;
  static const Duration _defaultTimeout = Duration(seconds: 20);

  Uri _resolve(String path) {
    final normalizedBase = _baseUrl.endsWith('/')
        ? _baseUrl.substring(0, _baseUrl.length - 1)
        : _baseUrl;
    final normalizedPath = path.startsWith('/') ? path.substring(1) : path;
    return Uri.parse('$normalizedBase/$normalizedPath');
  }

  Future<List<PetProfileModel>> fetchPetProfiles() =>
      _fetchCollection('petprofiles', PetProfileModel.fromJson);

  Future<List<ServiceProviderModel>> fetchServiceProviders() =>
      _fetchCollection('serviceproviders', ServiceProviderModel.fromJson);

  Future<List<ServiceRequestModel>> fetchServiceRequests() =>
      _fetchCollection('servicerequests', ServiceRequestModel.fromJson);

  Future<ApiDashboardData> fetchDashboardData() async {
    final results = await Future.wait([
      fetchPetProfiles(),
      fetchServiceProviders(),
      fetchServiceRequests(),
    ]);

    return ApiDashboardData(
      pets: results[0] as List<PetProfileModel>,
      providers: results[1] as List<ServiceProviderModel>,
      requests: results[2] as List<ServiceRequestModel>,
    );
  }

  Future<FirebaseSyncResultModel> syncFirebasePayload(
      Map<String, dynamic> payload) async {
    final response = await _client
        .post(
          _resolve('firebase/sync'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(payload),
        )
        .timeout(_defaultTimeout);

    _ensureSuccess(response);
    return FirebaseSyncResultModel.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  Future<List<T>> _fetchCollection<T>(
    String path,
    T Function(Map<String, dynamic>) converter,
  ) async {
    final response = await _client.get(_resolve(path)).timeout(_defaultTimeout);
    _ensureSuccess(response);

    final decoded = jsonDecode(response.body);
    if (decoded is! List) {
      throw const ApiException('Beklenmeyen yanıt formatı', 500);
    }

    return decoded
        .map<T>((item) => converter(item as Map<String, dynamic>))
        .toList();
  }

  void _ensureSuccess(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return;
    }

    throw ApiException(
      'API isteği başarısız oldu',
      response.statusCode,
      response.body.isEmpty ? null : response.body,
    );
  }

  void dispose() {
    _client.close();
  }
}

class ApiException implements Exception {
  const ApiException(this.message, this.statusCode, [this.body]);

  final String message;
  final int statusCode;
  final String? body;

  @override
  String toString() =>
      'ApiException($statusCode): $message${body != null ? ' -> $body' : ''}';
}
