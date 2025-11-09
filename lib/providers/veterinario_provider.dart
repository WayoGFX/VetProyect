import 'package:flutter/material.dart';
import 'package:vet_smart_ids/models/veterinario.dart';
import 'package:vet_smart_ids/services/api_service.dart';

class VeterinarioProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Veterinario> _veterinarios = [];
  Veterinario? _veterinarioActual;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<Veterinario> get veterinarios => _veterinarios;
  Veterinario? get veterinarioActual => _veterinarioActual;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _veterinarioActual != null;

  /// Cargar todos los veterinarios
  Future<void> loadVeterinarios() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _veterinarios = await _apiService.getVeterinarios();
    } catch (e) {
      _errorMessage = e.toString();
      print('Error al cargar veterinarios: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Cargar un veterinario por ID
  Future<void> loadVeterinarioById(int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _veterinarioActual = await _apiService.getVeterinarioById(id);
    } catch (e) {
      _errorMessage = e.toString();
      print('Error al cargar veterinario: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Login simple (buscar por email)
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final veterinarios = await _apiService.getVeterinarios();
      final veterinario = veterinarios.firstWhere(
        (v) => v.email == email,
        orElse: () => throw Exception('Veterinario no encontrado'),
      );

      _veterinarioActual = veterinario;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Credenciales inválidas';
      _isLoading = false;
      notifyListeners();
      print('Error en login: $e');
      return false;
    }
  }

  /// Registrar nuevo veterinario
  Future<bool> register(Veterinario veterinario) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final nuevoVet = await _apiService.createVeterinario(veterinario);
      _veterinarioActual = nuevoVet;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      print('Error al registrar veterinario: $e');
      return false;
    }
  }

  /// Actualizar veterinario
  Future<bool> updateVeterinario(int id, Veterinario veterinario) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _apiService.updateVeterinario(id, veterinario);
      if (_veterinarioActual?.veterinarioId == id) {
        _veterinarioActual = veterinario;
      }
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      print('Error al actualizar veterinario: $e');
      return false;
    }
  }

  /// Logout
  void logout() {
    _veterinarioActual = null;
    notifyListeners();
  }

  /// Establecer veterinario actual
  void setVeterinarioActual(Veterinario veterinario) {
    _veterinarioActual = veterinario;
    notifyListeners();
  }
}
