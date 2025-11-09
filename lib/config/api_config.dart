/// Configuración global de la API
class ApiConfig {
  // URL base de tu API - CAMBIA ESTO según tu IP si usas dispositivo físico
  static const String baseUrl = 'http://localhost:5022/api';

  // Si usas emulador Android, usa: 'http://10.0.2.2:5022/api'
  // Si usas dispositivo físico en la misma red, usa tu IP local: 'http://192.168.x.x:5022/api'

  // Timeout para peticiones HTTP
  static const Duration timeout = Duration(seconds: 30);

  // Headers comunes
  static const Map<String, String> headers = {
    'Content-Type': 'application/json; charset=UTF-8',
  };
}
