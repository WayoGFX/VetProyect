import 'package:flutter/material.dart';
import 'package:vet_smart_ids/services/api_service.dart';
import 'package:vet_smart_ids/models/veterinario.dart';
import 'package:vet_smart_ids/models/usuario.dart';
import 'package:vet_smart_ids/models/mascota.dart';
import 'package:vet_smart_ids/models/cita.dart';

/// Pantalla de prueba para verificar la conexión con la API
/// IMPORTANTE: Esta pantalla es solo para testing, elimínala en producción
class TestApiScreen extends StatefulWidget {
  static const String name = 'test_api';
  const TestApiScreen({super.key});

  @override
  State<TestApiScreen> createState() => _TestApiScreenState();
}

class _TestApiScreenState extends State<TestApiScreen> {
  final ApiService _apiService = ApiService();
  String _resultado = 'Presiona un botón para probar la API';
  bool _isLoading = false;
  bool _success = false;

  void _setLoading(bool loading) {
    setState(() {
      _isLoading = loading;
    });
  }

  void _setResultado(String mensaje, bool success) {
    setState(() {
      _resultado = mensaje;
      _success = success;
      _isLoading = false;
    });
  }

  // ============================================================================
  // PRUEBA 1: Obtener todos los veterinarios
  // ============================================================================
  Future<void> _testGetVeterinarios() async {
    _setLoading(true);
    try {
      final veterinarios = await _apiService.getVeterinarios();
      _setResultado(
        '✅ ÉXITO: Se obtuvieron ${veterinarios.length} veterinarios\n\n'
        'Ejemplo:\n${veterinarios.isNotEmpty ? "Nombre: ${veterinarios[0].nombreCompleto}\nEmail: ${veterinarios[0].email}\nEspecialidad: ${veterinarios[0].especialidad}" : "No hay veterinarios"}',
        true,
      );
    } catch (e) {
      _setResultado('❌ ERROR al obtener veterinarios:\n$e', false);
    }
  }

  // ============================================================================
  // PRUEBA 2: Obtener todos los usuarios
  // ============================================================================
  Future<void> _testGetUsuarios() async {
    _setLoading(true);
    try {
      final usuarios = await _apiService.getUsuarios();
      _setResultado(
        '✅ ÉXITO: Se obtuvieron ${usuarios.length} usuarios\n\n'
        'Ejemplo:\n${usuarios.isNotEmpty ? "Nombre: ${usuarios[0].nombreCompleto}\nEmail: ${usuarios[0].email}\nTeléfono: ${usuarios[0].telefono}" : "No hay usuarios"}',
        true,
      );
    } catch (e) {
      _setResultado('❌ ERROR al obtener usuarios:\n$e', false);
    }
  }

  // ============================================================================
  // PRUEBA 3: Obtener todas las mascotas
  // ============================================================================
  Future<void> _testGetMascotas() async {
    _setLoading(true);
    try {
      final mascotas = await _apiService.getMascotas();
      _setResultado(
        '✅ ÉXITO: Se obtuvieron ${mascotas.length} mascotas\n\n'
        'Ejemplo:\n${mascotas.isNotEmpty ? "Nombre: ${mascotas[0].nombre}\nEspecie: ${mascotas[0].especie}\nRaza: ${mascotas[0].raza}" : "No hay mascotas"}',
        true,
      );
    } catch (e) {
      _setResultado('❌ ERROR al obtener mascotas:\n$e', false);
    }
  }

  // ============================================================================
  // PRUEBA 4: Obtener todas las citas
  // ============================================================================
  Future<void> _testGetCitas() async {
    _setLoading(true);
    try {
      final citas = await _apiService.getCitas();
      _setResultado(
        '✅ ÉXITO: Se obtuvieron ${citas.length} citas\n\n'
        'Ejemplo:\n${citas.isNotEmpty ? "Motivo: ${citas[0].motivo}\nFecha: ${citas[0].fechaHora}\nEstado: ${citas[0].estado}" : "No hay citas"}',
        true,
      );
    } catch (e) {
      _setResultado('❌ ERROR al obtener citas:\n$e', false);
    }
  }

  // ============================================================================
  // PRUEBA 5: Obtener historiales médicos
  // ============================================================================
  Future<void> _testGetHistoriales() async {
    _setLoading(true);
    try {
      final historiales = await _apiService.getHistorialesMedicos();
      _setResultado(
        '✅ ÉXITO: Se obtuvieron ${historiales.length} historiales médicos\n\n'
        'Ejemplo:\n${historiales.isNotEmpty ? "Diagnóstico: ${historiales[0].diagnostico}\nTratamiento: ${historiales[0].tratamiento}" : "No hay historiales"}',
        true,
      );
    } catch (e) {
      _setResultado('❌ ERROR al obtener historiales:\n$e', false);
    }
  }

  // ============================================================================
  // PRUEBA 6: Obtener vacunas
  // ============================================================================
  Future<void> _testGetVacunas() async {
    _setLoading(true);
    try {
      final vacunas = await _apiService.getVacunas();
      _setResultado(
        '✅ ÉXITO: Se obtuvieron ${vacunas.length} vacunas\n\n'
        'Ejemplo:\n${vacunas.isNotEmpty ? "Nombre: ${vacunas[0].nombre}\nDescripción: ${vacunas[0].descripcion}" : "No hay vacunas"}',
        true,
      );
    } catch (e) {
      _setResultado('❌ ERROR al obtener vacunas:\n$e', false);
    }
  }

  // ============================================================================
  // PRUEBA 7: Crear un veterinario de prueba
  // ============================================================================
  Future<void> _testCreateVeterinario() async {
    _setLoading(true);
    try {
      final nuevoVet = Veterinario(
        nombreCompleto: 'Dr. Test Flutter',
        email: 'test.flutter@vetsmart.com',
        passwordHash: 'test123',
        telefono: '+51 999999999',
        especialidad: 'Pruebas Automatizadas',
        fotoUrl: null,
      );

      final creado = await _apiService.createVeterinario(nuevoVet);
      _setResultado(
        '✅ ÉXITO: Veterinario creado\n\n'
        'ID: ${creado.veterinarioId}\n'
        'Nombre: ${creado.nombreCompleto}\n'
        'Email: ${creado.email}\n\n'
        'NOTA: Elimínalo manualmente de la BD si no lo necesitas',
        true,
      );
    } catch (e) {
      _setResultado('❌ ERROR al crear veterinario:\n$e', false);
    }
  }

  // ============================================================================
  // PRUEBA COMPLETA: Probar todos los endpoints principales
  // ============================================================================
  Future<void> _testAllEndpoints() async {
    _setLoading(true);
    final resultados = <String, bool>{};

    // Prueba 1: Veterinarios
    try {
      await _apiService.getVeterinarios();
      resultados['Veterinarios'] = true;
    } catch (e) {
      resultados['Veterinarios'] = false;
    }

    // Prueba 2: Usuarios
    try {
      await _apiService.getUsuarios();
      resultados['Usuarios'] = true;
    } catch (e) {
      resultados['Usuarios'] = false;
    }

    // Prueba 3: Mascotas
    try {
      await _apiService.getMascotas();
      resultados['Mascotas'] = true;
    } catch (e) {
      resultados['Mascotas'] = false;
    }

    // Prueba 4: Citas
    try {
      await _apiService.getCitas();
      resultados['Citas'] = true;
    } catch (e) {
      resultados['Citas'] = false;
    }

    // Prueba 5: Historiales
    try {
      await _apiService.getHistorialesMedicos();
      resultados['Historiales Médicos'] = true;
    } catch (e) {
      resultados['Historiales Médicos'] = false;
    }

    // Prueba 6: Vacunas
    try {
      await _apiService.getVacunas();
      resultados['Vacunas'] = true;
    } catch (e) {
      resultados['Vacunas'] = false;
    }

    // Prueba 7: Alergias
    try {
      await _apiService.getAlergias();
      resultados['Alergias'] = true;
    } catch (e) {
      resultados['Alergias'] = false;
    }

    // Generar resumen
    final exitosos = resultados.values.where((v) => v).length;
    final total = resultados.length;
    final success = exitosos == total;

    final mensaje = StringBuffer();
    mensaje.writeln(success
        ? '✅ TODAS LAS PRUEBAS PASARON ($exitosos/$total)'
        : '⚠️ ALGUNAS PRUEBAS FALLARON ($exitosos/$total)');
    mensaje.writeln('\nResultados:');
    resultados.forEach((endpoint, success) {
      mensaje.writeln('${success ? "✅" : "❌"} $endpoint');
    });

    _setResultado(mensaje.toString(), success);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🧪 Test API Connection'),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Indicador de estado
            Card(
              color: _success ? Colors.green[50] : Colors.red[50],
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: _isLoading
                    ? const Row(
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(width: 16),
                          Expanded(child: Text('Probando conexión...')),
                        ],
                      )
                    : Text(
                        _resultado,
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 12,
                          color: _success ? Colors.green[900] : Colors.red[900],
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 20),
            const Text(
              'Pruebas Individuales:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Botones de pruebas individuales
            _buildTestButton(
              'GET Veterinarios',
              Icons.medical_services,
              _testGetVeterinarios,
              Colors.blue,
            ),
            _buildTestButton(
              'GET Usuarios',
              Icons.people,
              _testGetUsuarios,
              Colors.orange,
            ),
            _buildTestButton(
              'GET Mascotas',
              Icons.pets,
              _testGetMascotas,
              Colors.brown,
            ),
            _buildTestButton(
              'GET Citas',
              Icons.calendar_today,
              _testGetCitas,
              Colors.purple,
            ),
            _buildTestButton(
              'GET Historiales',
              Icons.description,
              _testGetHistoriales,
              Colors.teal,
            ),
            _buildTestButton(
              'GET Vacunas',
              Icons.medical_information,
              _testGetVacunas,
              Colors.green,
            ),

            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 10),
            const Text(
              'Pruebas de Escritura:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            _buildTestButton(
              'POST Crear Veterinario',
              Icons.add_circle,
              _testCreateVeterinario,
              Colors.indigo,
            ),

            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 20),

            // Botón de prueba completa
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _testAllEndpoints,
              icon: const Icon(Icons.play_arrow, size: 28),
              label: const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'PROBAR TODOS LOS ENDPOINTS',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
              ),
            ),

            const SizedBox(height: 20),

            // Información de ayuda
            Card(
              color: Colors.blue[50],
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info, color: Colors.blue[700]),
                        const SizedBox(width: 8),
                        Text(
                          'Información',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[900],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '• Asegúrate que tu API esté corriendo en localhost:5022\n'
                      '• Si usas emulador, cambia la URL en api_config.dart a 10.0.2.2:5022\n'
                      '• Si usas dispositivo físico, usa tu IP local\n'
                      '• Los datos de prueba se guardan en la BD real',
                      style: TextStyle(color: Colors.blue[900], fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestButton(
    String label,
    IconData icon,
    VoidCallback onPressed,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: ElevatedButton.icon(
        onPressed: _isLoading ? null : onPressed,
        icon: Icon(icon),
        label: Padding(
          padding: const EdgeInsets.all(12),
          child: Text(label),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          alignment: Alignment.centerLeft,
        ),
      ),
    );
  }
}
