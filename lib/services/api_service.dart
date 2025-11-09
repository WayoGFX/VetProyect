import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vet_smart_ids/config/api_config.dart';
import 'package:vet_smart_ids/models/alergia.dart';
import 'package:vet_smart_ids/models/cita.dart';
import 'package:vet_smart_ids/models/historial_medico.dart';
import 'package:vet_smart_ids/models/mascota.dart';
import 'package:vet_smart_ids/models/mascota_alergia.dart';
import 'package:vet_smart_ids/models/mascota_vacuna.dart';
import 'package:vet_smart_ids/models/usuario.dart';
import 'package:vet_smart_ids/models/vacuna.dart';
import 'package:vet_smart_ids/models/veterinario.dart';

/// Servicio centralizado para todas las peticiones HTTP a la API
class ApiService {
  // ============================================================================
  // MÉTODOS GENÉRICOS PRIVADOS (reutilizables)
  // ============================================================================

  /// GET - Obtener lista de recursos
  Future<List<T>> _getList<T>(
    String endpoint,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    try {
      final response = await http
          .get(
            Uri.parse('${ApiConfig.baseUrl}/$endpoint'),
            headers: ApiConfig.headers,
          )
          .timeout(ApiConfig.timeout);

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => fromJson(json)).toList();
      } else {
        throw Exception('Error al obtener $endpoint: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  /// GET - Obtener un recurso por ID
  Future<T> _getById<T>(
    String endpoint,
    int id,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    try {
      final response = await http
          .get(
            Uri.parse('${ApiConfig.baseUrl}/$endpoint/$id'),
            headers: ApiConfig.headers,
          )
          .timeout(ApiConfig.timeout);

      if (response.statusCode == 200) {
        return fromJson(json.decode(response.body));
      } else if (response.statusCode == 404) {
        throw Exception('$endpoint con ID $id no encontrado');
      } else {
        throw Exception('Error al obtener $endpoint: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  /// POST - Crear un recurso
  Future<T> _create<T>(
    String endpoint,
    Map<String, dynamic> data,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    try {
      final response = await http
          .post(
            Uri.parse('${ApiConfig.baseUrl}/$endpoint'),
            headers: ApiConfig.headers,
            body: json.encode(data),
          )
          .timeout(ApiConfig.timeout);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return fromJson(json.decode(response.body));
      } else {
        throw Exception('Error al crear en $endpoint: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  /// PUT - Actualizar un recurso
  Future<void> _update<T>(
    String endpoint,
    int id,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await http
          .put(
            Uri.parse('${ApiConfig.baseUrl}/$endpoint/$id'),
            headers: ApiConfig.headers,
            body: json.encode(data),
          )
          .timeout(ApiConfig.timeout);

      if (response.statusCode != 204 && response.statusCode != 200) {
        throw Exception(
            'Error al actualizar $endpoint: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  /// DELETE - Eliminar un recurso
  Future<void> _delete(String endpoint, int id) async {
    try {
      final response = await http
          .delete(
            Uri.parse('${ApiConfig.baseUrl}/$endpoint/$id'),
            headers: ApiConfig.headers,
          )
          .timeout(ApiConfig.timeout);

      if (response.statusCode != 204 && response.statusCode != 200) {
        throw Exception('Error al eliminar $endpoint: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // ============================================================================
  // ALERGIAS
  // ============================================================================

  Future<List<Alergia>> getAlergias() =>
      _getList('Alergias', (json) => Alergia.fromJson(json));

  Future<Alergia> getAlergiaById(int id) =>
      _getById('Alergias', id, (json) => Alergia.fromJson(json));

  Future<Alergia> createAlergia(Alergia alergia) =>
      _create('Alergias', alergia.toJson(), (json) => Alergia.fromJson(json));

  Future<void> updateAlergia(int id, Alergia alergia) =>
      _update('Alergias', id, alergia.toJson());

  Future<void> deleteAlergia(int id) => _delete('Alergias', id);

  // ============================================================================
  // CITAS
  // ============================================================================

  Future<List<Cita>> getCitas() =>
      _getList('Citas', (json) => Cita.fromJson(json));

  Future<Cita> getCitaById(int id) =>
      _getById('Citas', id, (json) => Cita.fromJson(json));

  Future<Cita> createCita(Cita cita) =>
      _create('Citas', cita.toJson(), (json) => Cita.fromJson(json));

  Future<void> updateCita(int id, Cita cita) =>
      _update('Citas', id, cita.toJson());

  Future<void> deleteCita(int id) => _delete('Citas', id);

  // ============================================================================
  // HISTORIALES MÉDICOS
  // ============================================================================

  Future<List<HistorialMedico>> getHistorialesMedicos() =>
      _getList('HistorialesMedicos', (json) => HistorialMedico.fromJson(json));

  Future<HistorialMedico> getHistorialMedicoById(int id) => _getById(
      'HistorialesMedicos', id, (json) => HistorialMedico.fromJson(json));

  Future<HistorialMedico> createHistorialMedico(HistorialMedico historial) =>
      _create('HistorialesMedicos', historial.toJson(),
          (json) => HistorialMedico.fromJson(json));

  Future<void> updateHistorialMedico(int id, HistorialMedico historial) =>
      _update('HistorialesMedicos', id, historial.toJson());

  Future<void> deleteHistorialMedico(int id) =>
      _delete('HistorialesMedicos', id);

  // ============================================================================
  // MASCOTAS
  // ============================================================================

  Future<List<Mascota>> getMascotas() =>
      _getList('Mascotas', (json) => Mascota.fromJson(json));

  Future<Mascota> getMascotaById(int id) =>
      _getById('Mascotas', id, (json) => Mascota.fromJson(json));

  Future<Mascota> createMascota(Mascota mascota) =>
      _create('Mascotas', mascota.toJson(), (json) => Mascota.fromJson(json));

  Future<void> updateMascota(int id, Mascota mascota) =>
      _update('Mascotas', id, mascota.toJson());

  Future<void> deleteMascota(int id) => _delete('Mascotas', id);

  // ============================================================================
  // MASCOTAS-ALERGIAS
  // ============================================================================

  Future<List<MascotaAlergia>> getMascotasAlergias() =>
      _getList('MascotasAlergias', (json) => MascotaAlergia.fromJson(json));

  Future<MascotaAlergia> getMascotaAlergiaById(int id) => _getById(
      'MascotasAlergias', id, (json) => MascotaAlergia.fromJson(json));

  Future<MascotaAlergia> createMascotaAlergia(MascotaAlergia mascotaAlergia) =>
      _create('MascotasAlergias', mascotaAlergia.toJson(),
          (json) => MascotaAlergia.fromJson(json));

  Future<void> updateMascotaAlergia(int id, MascotaAlergia mascotaAlergia) =>
      _update('MascotasAlergias', id, mascotaAlergia.toJson());

  Future<void> deleteMascotaAlergia(int id) => _delete('MascotasAlergias', id);

  // ============================================================================
  // MASCOTAS-VACUNAS
  // ============================================================================

  Future<List<MascotaVacuna>> getMascotasVacunas() =>
      _getList('MascotasVacunas', (json) => MascotaVacuna.fromJson(json));

  Future<MascotaVacuna> getMascotaVacunaById(int id) =>
      _getById('MascotasVacunas', id, (json) => MascotaVacuna.fromJson(json));

  Future<MascotaVacuna> createMascotaVacuna(MascotaVacuna mascotaVacuna) =>
      _create('MascotasVacunas', mascotaVacuna.toJson(),
          (json) => MascotaVacuna.fromJson(json));

  Future<void> updateMascotaVacuna(int id, MascotaVacuna mascotaVacuna) =>
      _update('MascotasVacunas', id, mascotaVacuna.toJson());

  Future<void> deleteMascotaVacuna(int id) => _delete('MascotasVacunas', id);

  // ============================================================================
  // USUARIOS
  // ============================================================================

  Future<List<Usuario>> getUsuarios() =>
      _getList('Usuarios', (json) => Usuario.fromJson(json));

  Future<Usuario> getUsuarioById(int id) =>
      _getById('Usuarios', id, (json) => Usuario.fromJson(json));

  Future<Usuario> createUsuario(Usuario usuario) =>
      _create('Usuarios', usuario.toJson(), (json) => Usuario.fromJson(json));

  Future<void> updateUsuario(int id, Usuario usuario) =>
      _update('Usuarios', id, usuario.toJson());

  Future<void> deleteUsuario(int id) => _delete('Usuarios', id);

  // ============================================================================
  // VACUNAS
  // ============================================================================

  Future<List<Vacuna>> getVacunas() =>
      _getList('Vacunas', (json) => Vacuna.fromJson(json));

  Future<Vacuna> getVacunaById(int id) =>
      _getById('Vacunas', id, (json) => Vacuna.fromJson(json));

  Future<Vacuna> createVacuna(Vacuna vacuna) =>
      _create('Vacunas', vacuna.toJson(), (json) => Vacuna.fromJson(json));

  Future<void> updateVacuna(int id, Vacuna vacuna) =>
      _update('Vacunas', id, vacuna.toJson());

  Future<void> deleteVacuna(int id) => _delete('Vacunas', id);

  // ============================================================================
  // VETERINARIOS
  // ============================================================================

  Future<List<Veterinario>> getVeterinarios() =>
      _getList('Veterinarios', (json) => Veterinario.fromJson(json));

  Future<Veterinario> getVeterinarioById(int id) =>
      _getById('Veterinarios', id, (json) => Veterinario.fromJson(json));

  Future<Veterinario> createVeterinario(Veterinario veterinario) => _create(
      'Veterinarios', veterinario.toJson(), (json) => Veterinario.fromJson(json));

  Future<void> updateVeterinario(int id, Veterinario veterinario) =>
      _update('Veterinarios', id, veterinario.toJson());

  Future<void> deleteVeterinario(int id) => _delete('Veterinarios', id);
}
