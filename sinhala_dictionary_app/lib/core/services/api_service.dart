import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:sinhala_dictionary_app/core/constants/url_constants.dart';
import 'package:sinhala_dictionary_app/core/errors/exceptions.dart';
import 'package:sinhala_dictionary_app/core/services/secure_storage_service.dart';
import 'package:sinhala_dictionary_app/core/utils/app_logger.dart';

class ApiService {
  late final Dio _dio;
  late final SecureStorageService _secureStorage;

  ApiService({required SecureStorageService secureStorage, required Dio dio}) {
    _dio = dio;
    _secureStorage = secureStorage;

    _setupInterceptors();
  }

  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final accessToken = await _secureStorage.getAccessToken();
          if (accessToken != null) {
            options.headers['Authorization'] = 'Bearer $accessToken';
          }
          return handler.next(options);
        },
        onError: (error, handler) async {
          appLog('dio onError: $error', name: 'DIO');
          if (error.response?.statusCode == 401 &&
              error.requestOptions.path != UrlConstants.getRefreshToken) {
            try {
              final newAccessToken = await _refreshTokens();
              if (newAccessToken == null) return;

              final retryOptions = error.requestOptions;
              retryOptions.headers['Authorization'] = 'Bearer $newAccessToken';

              final response = await _dio.fetch(retryOptions);
              return handler.resolve(response);
            } catch (e) {
              await _secureStorage.clearTokens();
            }
          }
          return handler.next(error);
        },
      ),
    );
  }

  Future<String?> _refreshTokens() async {
    final refreshToken = await _secureStorage.getRefreshToken();
    if (refreshToken == null) return null;

    final refreshDio = Dio(BaseOptions(baseUrl: UrlConstants.baseUrl));
    final response = await refreshDio.post(
      UrlConstants.getRefreshToken,
      data: {'refreshToken': refreshToken},
    );

    final newAccessToken = response.data['accessToken'];
    final newRefreshToken = response.data['refreshToken'];

    await _secureStorage.saveTokens(
      accessToken: newAccessToken,
      refreshToken: newRefreshToken,
    );

    return newAccessToken;
  }

  Future<Map<String, dynamic>> post(
    String url,
    Map<String, dynamic> request,
  ) async {
    appLog('url: $url', name: 'AppService (POST)');
    try {
      final response = await _dio.post(url, data: request);
      return response.data;
    } on DioException catch (e) {
      // API returned a response
      if (e.response != null) {
        final statusCode = e.response?.statusCode;

        if (statusCode == 429) {
          throw const LimitExceedException();
        } else {
          appLog('statusCode: ${e.response?.data}', name: 'Dio Exception');
          throw const ServerException();
        }
      }

      // API did not return a response
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          throw NetworkException(
            'Request timed out. Please check your connection',
          );
        case DioExceptionType.connectionError:
          throw NetworkException();
        default:
          if (e.error is SocketException) {
            throw NetworkException();
          }
          throw const UnknownException();
      }
    } on AppException {
      rethrow;
    } catch (e) {
      throw const UnknownException();
    }
  }
}
