import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/vegetable_model.dart';
import '../models/category_model.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

class VegetableApiService {
  // Singleton pattern
  static final VegetableApiService _instance = VegetableApiService._internal();
  factory VegetableApiService() => _instance;
  VegetableApiService._internal();

  static const String baseUrl = 'https://api-mobile.dnccudinus.org/api';
  static const Duration timeoutDuration = Duration(seconds: 12);

  final Map<String, String> _headers = {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  };

  /// 1. GET /api/vegetables
  /// Mengambil semua daftar sayuran
  Future<List<VegetableModel>> fetchVegetables() async {
    final uri = Uri.parse('$baseUrl/vegetables');
    debugPrint('[VegetableApiService] GET: $uri');

    try {
      final response = await http.get(uri, headers: _headers).timeout(timeoutDuration);

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic> && decoded['data'] is List) {
          final List list = decoded['data'];
          return list.map((item) => VegetableModel.fromJson(item as Map<String, dynamic>)).toList();
        } else if (decoded is List) {
          return decoded.map((item) => VegetableModel.fromJson(item as Map<String, dynamic>)).toList();
        } else {
          throw ApiException('Format data sayuran tidak valid');
        }
      } else {
        throw ApiException(
          'Gagal memuat sayuran (HTTP ${response.statusCode})',
          statusCode: response.statusCode,
        );
      }
    } on SocketException catch (_) {
      throw ApiException('Tidak dapat terhubung ke server. Periksa koneksi internet Anda.');
    } on TimeoutException catch (_) {
      throw ApiException('Koneksi ke server timeout. Silakan coba lagi.');
    } on FormatException catch (e) {
      throw ApiException('Gagal memproses respon server: ${e.message}');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Terjadi kesalahan: $e');
    }
  }

  /// 2. GET /api/vegetables/:id
  /// Mengambil detail sayuran berdasarkan ID
  Future<VegetableModel> fetchVegetableDetail(dynamic id) async {
    final uri = Uri.parse('$baseUrl/vegetables/$id');
    debugPrint('[VegetableApiService] GET Detail: $uri');

    try {
      final response = await http.get(uri, headers: _headers).timeout(timeoutDuration);

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic> && decoded['data'] is Map<String, dynamic>) {
          return VegetableModel.fromJson(decoded['data'] as Map<String, dynamic>);
        } else if (decoded is Map<String, dynamic>) {
          return VegetableModel.fromJson(decoded);
        } else {
          throw ApiException('Format data detail sayuran tidak valid');
        }
      } else {
        throw ApiException(
          'Gagal memuat detail sayuran (HTTP ${response.statusCode})',
          statusCode: response.statusCode,
        );
      }
    } on SocketException catch (_) {
      throw ApiException('Tidak dapat terhubung ke server. Periksa koneksi internet Anda.');
    } on TimeoutException catch (_) {
      throw ApiException('Koneksi ke server timeout.');
    } on FormatException catch (e) {
      throw ApiException('Gagal memproses detail sayuran: ${e.message}');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Terjadi kesalahan saat memuat detail: $e');
    }
  }

  /// 3. GET /api/vegetables/categories
  /// Mengambil daftar kategori sayuran beserta jumlahnya
  Future<List<VegetableCategory>> fetchCategories() async {
    final uri = Uri.parse('$baseUrl/vegetables/categories');
    debugPrint('[VegetableApiService] GET Categories: $uri');

    try {
      final response = await http.get(uri, headers: _headers).timeout(timeoutDuration);

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic> && decoded['data'] is List) {
          final List list = decoded['data'];
          return list.map((item) => VegetableCategory.fromJson(item as Map<String, dynamic>)).toList();
        } else if (decoded is List) {
          return decoded.map((item) => VegetableCategory.fromJson(item as Map<String, dynamic>)).toList();
        } else {
          throw ApiException('Format data kategori tidak valid');
        }
      } else {
        throw ApiException(
          'Gagal memuat kategori sayuran (HTTP ${response.statusCode})',
          statusCode: response.statusCode,
        );
      }
    } on SocketException catch (_) {
      throw ApiException('Tidak dapat terhubung ke server saat memuat kategori.');
    } on TimeoutException catch (_) {
      throw ApiException('Koneksi timeout saat memuat kategori.');
    } on FormatException catch (e) {
      throw ApiException('Gagal memproses respon kategori: ${e.message}');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Terjadi kesalahan memuat kategori: $e');
    }
  }
}
