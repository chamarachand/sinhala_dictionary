import 'package:sinhala_dictionary_app/core/constants/url_constants.dart';
import 'package:sinhala_dictionary_app/core/services/api_service.dart';
import 'package:sinhala_dictionary_app/core/services/secure_storage_service.dart';

class AuthRepository {
  final ApiService apiService;
  final SecureStorageService secureStorageService;

  AuthRepository({
    required this.apiService,
    required this.secureStorageService,
  });

  Future<void> initializeAnonymousUser() async {
    final existingAccessToken = await secureStorageService.getAccessToken();
    if (existingAccessToken != null) return; // User already initialized

    final response = await apiService.post(UrlConstants.authAnonymously, {});

    final accessToken = response['accessToken'] as String?;
    final refreshToken = response['refreshToken'] as String?;

    if (accessToken != null && refreshToken != null) {
      await secureStorageService.saveTokens(
        accessToken: accessToken,
        refreshToken: refreshToken,
      );
    }
  }

  Future<bool> isAuthenticated() async {
    final token = await secureStorageService.getAccessToken();
    return token != null;
  }
}
