/// Configuración global de la API
class ApiConfig {
  // URL base de tu API - CAMBIA ESTO según tu IP si usas dispositivo físico
  // NOTA: El API redirige HTTP a HTTPS, así que usamos HTTPS directamente
  static const String baseUrl = 'http://localhost:5022/api/';

  // Si usas emulador Android, usa: 'https://10.0.2.2:7071/api/'
  // Si usas dispositivo físico en la misma red, usa tu IP local: 'https://192.168.x.x:7071/api/'

  // Timeout para peticiones HTTP
  static const Duration timeout = Duration(
    seconds: 30,
  );

  // Headers comunes
  static const Map<
    String,
    String
  >
  headers = {
    'Content-Type': 'application/json; charset=UTF-8',
  };
}
