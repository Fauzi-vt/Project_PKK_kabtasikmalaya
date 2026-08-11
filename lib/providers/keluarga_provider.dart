import 'package:flutter/foundation.dart';
import '../services/api_service.dart';

class KeluargaProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  bool _isLoading = false;
  String? _errorMessage;
  Map<String, dynamic>? _currentUser;
  String? _token;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null && _token != null;
  Map<String, dynamic>? get currentUser => _currentUser;
  String? get token => _token;

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<bool> login(String identifier, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.login(
        identifier: identifier,
        password: password,
      );

      _currentUser = response['user'] as Map<String, dynamic>?;
      _token = response['token'] as String?;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  void logout() {
    _currentUser = null;
    _token = null;
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }
}
