import 'dart:async';

class ApiService {
  /// Simulates authenticating a user with NIP/Email and Password.
  /// Returns user metadata on success or throws an Exception on failure.
  Future<Map<String, dynamic>> login({
    required String identifier,
    required String password,
  }) async {
    // Simulate network latency
    await Future.delayed(const Duration(milliseconds: 1200));

    final trimmedIdentifier = identifier.trim();
    final trimmedPassword = password.trim();

    if (trimmedIdentifier.isEmpty) {
      throw Exception('Email / NIP tidak boleh kosong');
    }

    if (trimmedPassword.isEmpty) {
      throw Exception('Kata sandi tidak boleh kosong');
    }

    if (trimmedPassword.length < 4) {
      throw Exception('Kata sandi minimal 4 karakter');
    }

    // Mock validation logic
    if (trimmedIdentifier == 'error' || trimmedPassword == 'wrong') {
      throw Exception('Email/NIP atau Kata Sandi salah');
    }

    // Return mock successful user response
    return {
      'status': 'success',
      'message': 'Berhasil login',
      'user': {
        'id': 'USR-1092',
        'nama': 'Kader PKK Dasawisma',
        'identifier': trimmedIdentifier,
        'role': 'Kader Dasawisma',
        'rt': '003',
        'rw': '005',
        'kelurahan': 'Mekar Jaya',
      },
      'token': 'mock_jwt_token_pkk_dasawisma_2026',
    };
  }
}
