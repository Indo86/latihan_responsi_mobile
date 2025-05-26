import 'dart:io';
import 'package:http/http.dart' as http;

class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);
  @override
  String toString() => message;
}

class NetworkService {
  final http.Client client;
  NetworkService({http.Client? client}) : client = client ?? http.Client();

  Future<http.Response> getRequest(Uri uri) async {
    try {
      final res = await client.get(uri);
      if (res.statusCode != 200) {
        throw NetworkException('Server Error: ${res.statusCode}');
      }
      return res;
    } on SocketException {
      throw NetworkException('Tidak ada koneksi internet');
    }
  }
}
