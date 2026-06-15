import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../theme/app_colors.dart';
import '../../painters/diagonal_bg_painter.dart';

// TODO: importar acá tu selector de formato de torneo y descomentar la
// navegación en _irACrearTorneo(). Decime cómo se llama el archivo/clase
// (el que abre clásico / eliminatorias / etc.) y te lo dejo cableado.
// import 'crear_torneo_screen.dart';

/// Panel del organizador: torneos activos, finalizados y crear nuevo.
/// Acceso restringido: solo usuarios con rol 'fiscal' u 'organizador'.
/// El fiscal entra por el mismo acceso; acá se verifica el permiso.
class MisTorneosScreen extends StatefulWidget {
  const MisTorneosScreen({super.key});

  @override
  State<MisTorneosScreen> createState() => _MisTorneosScreenState();
}

class _MisTorneosScreenState extends State<MisTorneosScreen> {
  static const _accent = AppColors.blueBright;

  bool _cargando = true;
  bool _habilitado = false;
  String? _error;
  List<Map<String, dynamic>> _torneos = [];

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    setState(() {
      _cargando = true;
      _error = null;
    });
    try {
      final supa = Supabase.instance.client;
      final uid = supa.auth.currentUser?.id;
      if (uid == null) {
        setState(() {
          _habilitado = false;
          _cargando = false;
        });
        return;
      }

      // 1) Verificar permiso: rol fiscal u organizador
      final perfil = await supa
          .from('usuarios')
          .select('rol')
          .eq('id', uid)
          .maybeSingle();
      final rol = perfil?['rol'] as String?;
      final ok = rol == 'fiscal' || rol == 'organizador';

      // 2) Si está habilitado, traer SUS torneos
      List<Map<String, dynamic>> torneos = [];
      if (ok) {
        final res = await supa
            .from('torneos')
            .select()
            .eq('creado_por', uid)
            .order('created_at', ascending: false);
        torneos = List<Map<String, dynamic>>.from(res);
      }

      if (!mounted) return;
      setState(() {
        _habilitado = ok;
        _torneos = torneos;
        _cargando = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'No se pudieron cargar los torneos';
        _cargando = false;
      });
    }
  }

  List<Map<String, dynamic>> get _activos => _torneos
      .where((t) => t['estado'] == 'inscripcion' || t['estado'] == 'en_juego')
      .toList();

  List<Map<String, dynamic>> get _finalizados => _torneos
      .where((t) => t['estado'] == 'finalizado' || t['estado'] == 'cancelado')
      .toList();

  void _irACrearTorneo() {
    // TODO: descomentar cuando importes tu selector de formato:
    // Navigator.push(context,
    //     MaterialPageRoute(builder: (_) => const CrearTorneoScreen()));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Falta cablear la pantalla de crear torneo',
          style: GoogleFonts.barlowCondensed(fontSize: 15)),
      backgroundColor: _accent,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy,
      body: Stack(children: [
        CustomPaint(painter: DiagonalBgPainter(), child: Container()),
        SafeArea(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 24, 0),
              child: Row(children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_ios,
                      color: AppColors.white30, size: 20),
                ),
                Expanded(
                  child: Text('MIS TORNEOS',
                      style: GoogleFonts.bebasNeue(
                          fontSize: 26, letterSpacing: 2, color: Colors.white)),
                ),
                IconButton(
                  onPressed: _cargar,
                  icon: const Icon(Icons.refresh,
                      color: AppColors.white30, size: 20),
                ),
              ]),
            ),
            Expanded(child: _body()),
          ]),
        ),
      ]),
    );
  }

  Widget _body() {
    if (_cargando) {
      return const Center(child: CircularProgressIndicator(color: _accent));
    }
    if (_error != null) {
      return Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(_error!,
              style: GoogleFonts.barlowCondensed(
                  fontSize: 16, color: AppColors.white30)),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: _cargar,
            child: Text('REINTENTAR',
                style: GoogleFonts.barlowCondensed(
                    fontSize: 14, letterSpacing: 2, color: _accent)),
          ),
        ]),
      );
    }
    if (!_habilitado) return _sinAcceso();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Botón crear
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _irACrearTorneo,
            icon: const Icon(Icons.add, color: Colors.white),
            label: Text('CREAR NUEVO TORNEO',
                style: GoogleFonts.barlowCondensed(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2,
                    color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: _accent,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
        const SizedBox(height: 28),
        _seccion('TORNEOS ACTIVOS', _activos,
            vacio: 'No tenés torneos en inscripción ni en juego.'),
        const SizedBox(height: 24),
        _seccion('TORNEOS FINALIZADOS', _finalizados,
            vacio: 'Todavía no finalizaste ningún torneo.'),
      ]),
    );
  }

  Widget _sinAcceso() => Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.lock_outline, color: AppColors.white30, size: 48),
            const SizedBox(height: 16),
            Text('ACCESO RESTRINGIDO',
                style: GoogleFonts.bebasNeue(
                    fontSize: 22, letterSpacing: 2, color: Colors.white)),
            const SizedBox(height: 8),
            Text(
              'Tu cuenta no está habilitada para organizar torneos. '
              'Si querés organizar torneos MPC/FejuBA, contactá al fiscal.',
              textAlign: TextAlign.center,
              style: GoogleFonts.barlowCondensed(
                  fontSize: 15, color: AppColors.white30),
            ),
          ]),
        ),
      );

  Widget _seccion(String titulo, List<Map<String, dynamic>> items,
      {required String vacio}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(titulo,
          style: GoogleFonts.barlowCondensed(
              fontSize: 11, letterSpacing: 3, color: _accent)),
      const SizedBox(height: 10),
      if (items.isEmpty)
        Text(vacio,
            style: GoogleFonts.barlow(fontSize: 12, color: AppColors.white30))
      else
        for (final t in items) _torneoCard(t),
    ]);
  }

  Widget _torneoCard(Map<String, dynamic> t) {
    final estado = (t['estado'] as String?) ?? '';
    final (estadoTxt, estadoColor) = switch (estado) {
      'inscripcion' => ('INSCRIPCIÓN', _accent),
      'en_juego' => ('EN JUEGO', AppColors.green),
      'finalizado' => ('FINALIZADO', AppColors.white30),
      _ => ('CANCELADO', AppColors.red),
    };
    final fechas = t['fecha_inicio'] != null
        ? '${t['fecha_inicio']} → ${t['fecha_fin'] ?? ''}'
        : (t['fecha']?.toString() ?? '');
    final clubes = t['clubes'] is List
        ? (t['clubes'] as List).join(', ')
        : (t['club']?.toString() ?? '');

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white05,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.white10),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(
            child: Text((t['nombre'] ?? '').toString(),
                style: GoogleFonts.barlowCondensed(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Colors.white)),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: estadoColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: estadoColor.withOpacity(0.5)),
            ),
            child: Text(estadoTxt,
                style: GoogleFonts.barlowCondensed(
                    fontSize: 10, letterSpacing: 2, color: estadoColor)),
          ),
        ]),
        const SizedBox(height: 4),
        Text([fechas, clubes].where((s) => s.isNotEmpty).join(' · '),
            style: GoogleFonts.barlow(fontSize: 12, color: AppColors.white30)),
      ]),
    );
  }
}