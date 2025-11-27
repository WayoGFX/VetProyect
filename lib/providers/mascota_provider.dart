import 'package:flutter/material.dart';
import 'package:vet_smart_ids/models/mascota.dart';
import 'package:vet_smart_ids/models/paciente_detalle.dart';
import 'package:vet_smart_ids/services/api_service.dart';

class MascotaProvider
    extends
        ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<
    Mascota
  >
  _mascotas = [];
  Mascota? _mascotaSeleccionada;
  PacienteDetalle? _pacienteDetalle;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<
    Mascota
  >
  get mascotas => _mascotas;
  Mascota? get mascotaSeleccionada => _mascotaSeleccionada;
  PacienteDetalle? get pacienteDetalle => _pacienteDetalle;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Cargar todas las mascotas
  Future<
    void
  >
  loadMascotas() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _mascotas = await _apiService.getMascotas();
    } catch (
      e
    ) {
      _errorMessage = e.toString();
      print(
        'Error al cargar mascotas: $e',
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Cargar mascotas de un usuario específico
  Future<
    void
  >
  loadMascotasByUsuario(
    int usuarioId,
  ) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final todasMascotas = await _apiService.getMascotas();
      _mascotas = todasMascotas
          .where(
            (
              m,
            ) =>
                m.usuarioId ==
                usuarioId,
          )
          .toList();
    } catch (
      e
    ) {
      _errorMessage = e.toString();
      print(
        'Error al cargar mascotas del usuario: $e',
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Cargar una mascota por ID
  Future<
    void
  >
  loadMascotaById(
    int id,
  ) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _mascotaSeleccionada = await _apiService.getMascotaById(
        id,
      );
    } catch (
      e
    ) {
      _errorMessage = e.toString();
      print(
        'Error al cargar mascota: $e',
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Crear una nueva mascota
  Future<
    bool
  >
  createMascota(
    Mascota mascota,
  ) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _apiService.createMascota(
        mascota,
      );
      await loadMascotas(); // Recargar la lista
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (
      e
    ) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      print(
        'Error al crear mascota: $e',
      );
      return false;
    }
  }

  /// Actualizar una mascota
  Future<
    bool
  >
  updateMascota(
    int id,
    Mascota mascota,
  ) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _apiService.updateMascota(
        id,
        mascota,
      );
      await loadMascotas(); // Recargar la lista
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (
      e
    ) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      print(
        'Error al actualizar mascota: $e',
      );
      return false;
    }
  }

  /// Eliminar una mascota
  Future<
    bool
  >
  deleteMascota(
    int id,
  ) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _apiService.deleteMascota(
        id,
      );
      await loadMascotas(); // Recargar la lista
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (
      e
    ) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      print(
        'Error al eliminar mascota: $e',
      );
      return false;
    }
  }

  /// Seleccionar una mascota
  void selectMascota(
    Mascota mascota,
  ) {
    _mascotaSeleccionada = mascota;
    notifyListeners();
  }

  /// Limpiar mascota seleccionada
  void clearSelection() {
    _mascotaSeleccionada = null;
    _pacienteDetalle = null;
    notifyListeners();
  }

  /// Cargar información completa del paciente (para ficha médica)
  Future<
    void
  >
  loadPacienteDetalle(
    int mascotaId,
  ) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // 1. Cargar mascota
      final mascota = await _apiService.getMascotaById(
        mascotaId,
      );

      // 2. Cargar dueño
      final dueno = await _apiService.getUsuarioById(
        mascota.usuarioId,
      );

      // 3. Cargar vacunas aplicadas
      final todasMascotasVacunas = await _apiService.getMascotasVacunas();
      final mascotaVacunas = todasMascotasVacunas
          .where(
            (
              mv,
            ) =>
                mv.mascotaId ==
                mascotaId,
          )
          .toList();

      final List<
        VacunaAplicada
      >
      vacunasAplicadas = [];
      for (var mv in mascotaVacunas) {
        try {
          final vacuna = await _apiService.getVacunaById(
            mv.vacunaId,
          );
          vacunasAplicadas.add(
            VacunaAplicada.fromMascotaVacuna(
              mv,
              vacuna,
            ),
          );
        } catch (
          e
        ) {
          print(
            'Error al cargar vacuna ${mv.vacunaId}: $e',
          );
        }
      }

      // 4. Cargar alergias
      final todasMascotasAlergias = await _apiService.getMascotasAlergias();
      final mascotaAlergias = todasMascotasAlergias
          .where(
            (
              ma,
            ) =>
                ma.mascotaId ==
                mascotaId,
          )
          .toList();

      final List<
        AlergiaDetalle
      >
      alergiasDetalle = [];
      for (var ma in mascotaAlergias) {
        try {
          final alergia = await _apiService.getAlergiaById(
            ma.alergiaId,
          );
          alergiasDetalle.add(
            AlergiaDetalle.fromMascotaAlergia(
              ma,
              alergia,
            ),
          );
        } catch (
          e
        ) {
          print(
            'Error al cargar alergia ${ma.alergiaId}: $e',
          );
        }
      }

      // 5. Cargar citas
      final todasCitas = await _apiService.getCitas();
      final citasMascota = todasCitas
          .where(
            (
              c,
            ) =>
                c.mascotaId ==
                mascotaId,
          )
          .toList();

      final ahora = DateTime.now();
      final proximasCitas =
          citasMascota
              .where(
                (
                  c,
                ) => c.fechaHora.isAfter(
                  ahora,
                ),
              )
              .toList()
            ..sort(
              (
                a,
                b,
              ) => a.fechaHora.compareTo(
                b.fechaHora,
              ),
            );

      final citasAnteriores =
          citasMascota
              .where(
                (
                  c,
                ) => c.fechaHora.isBefore(
                  ahora,
                ),
              )
              .toList()
            ..sort(
              (
                a,
                b,
              ) => b.fechaHora.compareTo(
                a.fechaHora,
              ),
            );

      // 6. Cargar historial médico
      final todosHistoriales = await _apiService.getHistorialesMedicos();
      final historialMascota =
          todosHistoriales
              .where(
                (
                  h,
                ) =>
                    h.mascotaId ==
                    mascotaId,
              )
              .toList()
            ..sort(
              (
                a,
                b,
              ) => b.fechaConsulta.compareTo(
                a.fechaConsulta,
              ),
            );

      // 7. Crear el detalle completo
      _pacienteDetalle = PacienteDetalle(
        mascota: mascota,
        dueno: dueno,
        vacunas: vacunasAplicadas,
        alergias: alergiasDetalle,
        proximasCitas: proximasCitas,
        citasAnteriores: citasAnteriores,
        historialMedico: historialMascota,
      );

      _mascotaSeleccionada = mascota;
    } catch (
      e
    ) {
      _errorMessage = e.toString();
      print(
        'Error al cargar detalle del paciente: $e',
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
