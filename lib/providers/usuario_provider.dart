import 'package:flutter/material.dart';
import 'package:vet_smart_ids/models/usuario.dart';
import 'package:vet_smart_ids/services/api_service.dart';

class UsuarioProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Usuario> _usuarios = [];
  Usuario? _usuarioActual;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<Usuario> get usuarios => _usuarios;
  Usuario? get usuarioActual => _usuarioActual;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _usuarioActual != null;

  /// Cargar todos los usuarios
  Future<void> loadUsuarios() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _usuarios = await _apiService.getUsuarios();
    } catch (e) {
      _errorMessage = e.toString();
      print('Error al cargar usuarios: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Cargar un usuario por ID
  Future<void> loadUsuarioById(int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _usuarioActual = await _apiService.getUsuarioById(id);
    } catch (e) {
      _errorMessage = e.toString();
      print('Error al cargar usuario: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Login simple (buscar por email)
  /// NOTA: En producción esto debería ser un endpoint de autenticación real
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final usuarios = await _apiService.getUsuarios();
      final usuario = usuarios.firstWhere(
        (u) => u.email == email,
        orElse: () => throw Exception('Usuario no encontrado'),
      );

      // En tu caso no validas password porque no hay tokens
      // pero puedes agregar una validación simple si quieres
      _usuarioActual = usuario;
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

  /// Registrar nuevo usuario
  Future<bool> register(Usuario usuario) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final nuevoUsuario = await _apiService.createUsuario(usuario);
      _usuarioActual = nuevoUsuario;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      print('Error al registrar usuario: $e');
      return false;
    }
  }

  /// Actualizar usuario
  Future<bool> updateUsuario(int id, Usuario usuario) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _apiService.updateUsuario(id, usuario);
      if (_usuarioActual?.usuarioId == id) {
        _usuarioActual = usuario;
      }
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      print('Error al actualizar usuario: $e');
      return false;
    }
  }

  /// Logout
  void logout() {
    _usuarioActual = null;
    notifyListeners();
  }

  /// Establecer usuario actual (útil para login manual)
  void setUsuarioActual(Usuario usuario) {
    _usuarioActual = usuario;
    notifyListeners();
  }
}
