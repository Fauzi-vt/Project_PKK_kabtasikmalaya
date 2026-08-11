import 'package:flutter/foundation.dart';
import '../services/api_service.dart';

class KeluargaProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  // ─── Auth State ───────────────────────────────────────────────────────────
  bool _isLoading = false;
  String? _errorMessage;
  Map<String, dynamic>? _currentUser;
  String? _token;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null && _token != null;
  Map<String, dynamic>? get currentUser => _currentUser;
  String? get token => _token;

  // ─── Keluarga List State ───────────────────────────────────────────────────
  List<Map<String, dynamic>> _keluargaList = [];
  bool _isLoadingKeluarga = false;
  String? _keluargaError;

  List<Map<String, dynamic>> get keluargaList => _keluargaList;
  bool get isLoadingKeluarga => _isLoadingKeluarga;
  String? get keluargaError => _keluargaError;

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

  /// Fetches daftar keluarga (KK) from ApiService asynchronously.
  Future<void> getKeluargaData() async {
    _isLoadingKeluarga = true;
    _keluargaError = null;
    notifyListeners();

    try {
      final data = await _apiService.getKeluargaData();
      _keluargaList = data;
      _isLoadingKeluarga = false;
      notifyListeners();
    } catch (e) {
      _isLoadingKeluarga = false;
      _keluargaError = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
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
