import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../theme/app_colors.dart';
import '../../painters/diagonal_bg_painter.dart';
import '../../widgets/profile_avatar.dart';
import '../auth/login_screen.dart';
import '../../constants/distritos.dart';

class InvitadoScreen extends StatefulWidget {
  const InvitadoScreen({super.key});
  @override
  State<InvitadoScreen> createState() => _InvitadoScreenState();
}

class _InvitadoScreenState extends State<InvitadoScreen>
    with SingleTickerProviderStateMixin {

  // ── Navegación interna ──
  // null = home, 'torneos' = pantalla torneos, 'jugadores' = pantalla jugadores
  String? _seccion;

  // ── Torneos ──
  final _buscarTorneoCtrl = TextEditingController();
  final _distritoCtrl     = TextEditingController();
  final _localidadCtrl    = TextEditingController();
  String _filtroEstado    = '';
  List<Map<String, dynamic>> _torneos = [];
  List<String> _distSuggestions = [];
  List<String> _locSuggestions  = [];
  bool _showDistSug        = false;
  bool _showLocSug         = false;
  bool _cargandoTorneos    = false;
  bool _showFiltrosTorneos = false;

  // ── Jugadores ──
  final _buscarJugCtrl = TextEditingController();
  List<Map<String, dynamic>> _jugadores = [];
  bool _cargandoJug = false;

  // ── Filtros jugadores ──
  String _filtroGeneroJug  = '';
  String _filtroManoJug    = '';
  String _filtroLadoJug    = '';
  int    _filtroCatJug     = 0;
  bool   _showFiltrosJug   = false;
  final _distJugCtrl = TextEditingController();
  final _locJugCtrl  = TextEditingController();
  List<String> _distJugSug = [];
  List<String> _locJugSug  = [];
  bool _showDistJugSug = false;
  bool _showLocJugSug  = false;

  // ── Banners publicitarios ──
  final List<Map<String, dynamic>> _banners = [
    {
      'titulo'  : 'PINTURERÍA "CANELA"',
      'sub'     : 'Todo en pinturas y revestimientos · San Bernardo',
      'color'   : const Color(0xFFD4845A),
      'icon'    : Icons.format_paint_outlined,
      'tag'     : 'PUBLICIDAD',
    },
    {
      'titulo'  : 'MATERIALES CALIENDO',
      'sub'     : 'Construcción y ferretería · Consultas al local',
      'color'   : const Color(0xFF7CB9E8),
      'icon'    : Icons.hardware_outlined,
      'tag'     : 'PUBLICIDAD',
    },
    {
      'titulo'  : 'SUPERMERCADO "FRUTAMAR"',
      'sub'     : 'Frutas, verduras y almacén · Precios bajos siempre',
      'color'   : const Color(0xFF5FAD56),
      'icon'    : Icons.storefront_outlined,
      'tag'     : 'PUBLICIDAD',
    },
  ];
  int _bannerIdx = 0;

  // ── Timer banner ──
  late final _bannerTimer = Stream.periodic(const Duration(seconds: 4));

  @override
  void initState() {
    super.initState();
    _startBannerLoop();
  }

  void _startBannerLoop() {
    Future.delayed(const Duration(seconds: 4), () {
      if (!mounted) return;
      setState(() => _bannerIdx = (_bannerIdx + 1) % _banners.length);
      _startBannerLoop();
    });
  }

  @override
  void dispose() {
    _buscarTorneoCtrl.dispose(); _distritoCtrl.dispose(); _localidadCtrl.dispose();
    _buscarJugCtrl.dispose(); _distJugCtrl.dispose(); _locJugCtrl.dispose();
    super.dispose();
  }

  // ── TORNEOS ──────────────────────────────────────────────────────────────────

  Future<void> _cargarTorneos() async {
    setState(() => _cargandoTorneos = true);
    try {
      var query = Supabase.instance.client.from('torneos').select();
      final q   = _buscarTorneoCtrl.text.trim();
      final dis = _distritoCtrl.text.trim();
      final loc = _localidadCtrl.text.trim();
      if (q.isNotEmpty)            query = query.ilike('nombre', '%$q%') as dynamic;
      if (dis.isNotEmpty)          query = query.ilike('distrito', '%$dis%') as dynamic;
      if (loc.isNotEmpty)          query = query.ilike('localidad', '%$loc%') as dynamic;
      if (_filtroEstado.isNotEmpty) query = query.eq('estado', _filtroEstado) as dynamic;
      final res = await query.order('fecha_inicio', ascending: true).limit(50);
      if (mounted) setState(() => _torneos = List<Map<String, dynamic>>.from(res));
    } catch (e) {
      debugPrint('Error torneos: $e');
    } finally {
      if (mounted) setState(() => _cargandoTorneos = false);
    }
  }

  // ── JUGADORES ────────────────────────────────────────────────────────────────

  Future<void> _buscarJugadores() async {
    final q   = _buscarJugCtrl.text.trim();
    final dis = _distJugCtrl.text.trim();
    final loc = _locJugCtrl.text.trim();
    final hayFiltros = _filtroGeneroJug.isNotEmpty || _filtroManoJug.isNotEmpty ||
        _filtroLadoJug.isNotEmpty || _filtroCatJug > 0 || dis.isNotEmpty || loc.isNotEmpty;
    if (q.isEmpty && !hayFiltros) { setState(() => _jugadores = []); return; }
    setState(() => _cargandoJug = true);
    try {
      var query = Supabase.instance.client.from('usuarios')
          .select('id, nombre, apellido, categoria, categoria_observada, foto_url, localidad, distrito, lado_cancha, mano_habil, genero');
      if (q.isNotEmpty) query = query.or('nombre.ilike.%$q%,apellido.ilike.%$q%') as dynamic;
      if (_filtroGeneroJug.isNotEmpty)  query = query.eq('genero', _filtroGeneroJug) as dynamic;
      if (_filtroManoJug.isNotEmpty)    query = query.eq('mano_habil', _filtroManoJug) as dynamic;
      if (_filtroLadoJug.isNotEmpty)    query = query.eq('lado_cancha', _filtroLadoJug) as dynamic;
      if (_filtroCatJug > 0)            query = query.eq('categoria', _filtroCatJug) as dynamic;
      if (dis.isNotEmpty)               query = query.ilike('distrito', '%$dis%') as dynamic;
      if (loc.isNotEmpty)               query = query.ilike('localidad', '%$loc%') as dynamic;
      final res = await query.order('nombre').limit(30);
      if (mounted) setState(() => _jugadores = List<Map<String, dynamic>>.from(res));
    } catch (e) {
      debugPrint('Error jugadores: $e');
    } finally {
      if (mounted) setState(() => _cargandoJug = false);
    }
  }

  // ── Autocomplete distrito/localidad jugadores ──
  void _onDistJugChanged(String val) {
    final matches = kDistritosBA.keys.where((d) => d.toLowerCase().contains(val.toLowerCase())).take(8).toList();
    setState(() { _distJugSug = matches; _showDistJugSug = matches.isNotEmpty && val.isNotEmpty; });
    if (val.isEmpty) { _locJugCtrl.clear(); _buscarJugadores(); }
  }
  void _selectDistJug(String d) {
    _distJugCtrl.text = d; _locJugCtrl.clear();
    setState(() { _showDistJugSug = false; _distJugSug = []; });
    _buscarJugadores();
  }
  void _onLocJugChanged(String val) {
    final locs = kDistritosBA[_distJugCtrl.text.trim()] ?? [];
    final matches = locs.where((l) => l.toLowerCase().contains(val.toLowerCase())).toList();
    setState(() { _locJugSug = matches; _showLocJugSug = matches.isNotEmpty && val.isNotEmpty; });
  }
  void _selectLocJug(String l) {
    _locJugCtrl.text = l;
    setState(() { _showLocJugSug = false; _locJugSug = []; });
    _buscarJugadores();
  }
  void _limpiarFiltrosJug() {
    setState(() {
      _filtroGeneroJug = ''; _filtroManoJug = ''; _filtroLadoJug = ''; _filtroCatJug = 0;
      _distJugCtrl.clear(); _locJugCtrl.clear();
      _showDistJugSug = false; _showLocJugSug = false;
    });
    _buscarJugadores();
  }

  // ── DISTRITO AUTOCOMPLETE ────────────────────────────────────────────────────

  void _onDistChanged(String val) {
    final q = val.toLowerCase();
    final matches = kDistritosBA.keys.where((d) => d.toLowerCase().contains(q)).take(8).toList();
    setState(() { _distSuggestions = matches; _showDistSug = matches.isNotEmpty && val.isNotEmpty; });
    if (val.isEmpty) { _localidadCtrl.clear(); _cargarTorneos(); }
  }

  void _selectDist(String d) {
    _distritoCtrl.text = d; _localidadCtrl.clear();
    setState(() { _showDistSug = false; _distSuggestions = []; });
    _cargarTorneos();
  }

  void _onLocChanged(String val) {
    final locs = kDistritosBA[_distritoCtrl.text.trim()] ?? [];
    final matches = locs.where((l) => l.toLowerCase().contains(val.toLowerCase())).toList();
    setState(() { _locSuggestions = matches; _showLocSug = matches.isNotEmpty && val.isNotEmpty; });
  }

  void _selectLoc(String l) {
    _localidadCtrl.text = l;
    setState(() { _showLocSug = false; _locSuggestions = []; });
    _cargarTorneos();
  }

  // ── BUILD ────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Container(decoration: const BoxDecoration(gradient: LinearGradient(
          begin: Alignment.topCenter, end: Alignment.bottomCenter,
          colors: [AppColors.navy, AppColors.navy2],
        ))),
        CustomPaint(painter: DiagonalBgPainter(), child: Container()),
        SafeArea(child: Column(children: [
          _header(),
          const Divider(color: AppColors.white10, height: 1),
          Expanded(child: _body()),
        ])),
      ]),
    );
  }

  // ── HEADER ───────────────────────────────────────────────────────────────────

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 12),
      child: Row(children: [
        if (_seccion != null)
          GestureDetector(
            onTap: () => setState(() => _seccion = null),
            child: const Padding(
              padding: EdgeInsets.only(right: 12),
              child: Icon(Icons.arrow_back_ios, color: AppColors.white30, size: 18),
            ),
          ),
        ShaderMask(
          shaderCallback: (b) => const LinearGradient(
            colors: [Colors.white, AppColors.blueBright, AppColors.yellow],
          ).createShader(b),
          child: Text('PADEL BA',
            style: GoogleFonts.bebasNeue(fontSize: 24, letterSpacing: 3, color: Colors.white)),
        ),
        const SizedBox(width: 8),
        if (_seccion == null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(color: AppColors.white10, borderRadius: BorderRadius.circular(8)),
            child: Text('INVITADO',
              style: GoogleFonts.barlowCondensed(fontSize: 10, letterSpacing: 2, color: AppColors.white30)),
          ),
        if (_seccion != null)
          Text(_seccion == 'torneos' ? 'TORNEOS' : 'JUGADORES',
            style: GoogleFonts.bebasNeue(fontSize: 20, letterSpacing: 2, color: Colors.white)),
        const Spacer(),
        TextButton(
          onPressed: () => Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (_) => const LoginScreen())),
          child: Text('SALIR',
            style: GoogleFonts.barlowCondensed(fontSize: 13, color: AppColors.blueBright, letterSpacing: 1)),
        ),
      ]),
    );
  }

  // ── BODY ─────────────────────────────────────────────────────────────────────

  Widget _body() {
    if (_seccion == 'torneos')   return _pantallaTorneos();
    if (_seccion == 'jugadores') return _pantallaJugadores();
    return _pantallaHome();
  }

  // ── HOME ─────────────────────────────────────────────────────────────────────

  Widget _pantallaHome() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

        // ── Dos paneles de acceso ──────────────────────────────────────────
        Row(children: [
          Expanded(child: _panelAcceso(
            icon: Icons.emoji_events_outlined,
            titulo: 'TORNEOS',
            subtexto: 'Accedé a toda la info de los torneos finalizados, en curso y próximos',
            color: AppColors.blueBright,
            onTap: () {
              setState(() => _seccion = 'torneos');
              _cargarTorneos();
            },
          )),
          const SizedBox(width: 12),
          Expanded(child: _panelAcceso(
            icon: Icons.person_search_outlined,
            titulo: 'JUGADORES',
            subtexto: 'Buscá a los mejores jugadores y sus estadísticas',
            color: AppColors.yellow,
            onTap: () => setState(() => _seccion = 'jugadores'),
          )),
        ]),
        const SizedBox(height: 24),

        // ── Banners publicitarios ──────────────────────────────────────────
        Text('PUBLICIDAD',
          style: GoogleFonts.barlowCondensed(fontSize: 10, letterSpacing: 3, color: AppColors.white30)),
        const SizedBox(height: 10),
        ..._banners.asMap().entries.map((e) => _bannerCard(e.value, e.key)),

        const SizedBox(height: 20),

        // ── Bloque auspiciante ────────────────────────────────────────────
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.blueBright.withOpacity(0.06),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.blueBright.withOpacity(0.2)),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              const Icon(Icons.campaign_outlined, color: AppColors.blueBright, size: 16),
              const SizedBox(width: 8),
              Text('¿QUERÉS ANUNCIARTE?',
                style: GoogleFonts.bebasNeue(fontSize: 16, color: AppColors.blueBright, letterSpacing: 1)),
            ]),
            const SizedBox(height: 6),
            Text('Llegá a miles de jugadores de pádel en toda la provincia de Buenos Aires. Tu negocio, visible en cada torneo.',
              style: GoogleFonts.barlow(fontSize: 12, color: AppColors.white30, height: 1.5)),
            const SizedBox(height: 10),
            Row(children: [
              const Icon(Icons.email_outlined, color: AppColors.blueBright, size: 14),
              const SizedBox(width: 6),
              Text('publicidad@padelba.app',
                style: GoogleFonts.barlowCondensed(fontSize: 13, color: AppColors.blueBright, letterSpacing: 0.5)),
            ]),
            const SizedBox(height: 6),
            Text('· Banners en pantalla de inicio  · Presencia en torneos  · Alcance regional',
              style: GoogleFonts.barlow(fontSize: 11, color: AppColors.white30)),
          ]),
        ),
        const SizedBox(height: 10),

        // ── Link discreto para jugadores ──────────────────────────────────
        Center(child: TextButton(
          onPressed: () => Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (_) => const LoginScreen())),
          child: Text('¿Sos jugador? Ingresá acá →',
            style: GoogleFonts.barlowCondensed(fontSize: 13, color: AppColors.white30, letterSpacing: 0.5)),
        )),
        const SizedBox(height: 8),
      ]),
    );
  }

  // ── PANEL ACCESO ─────────────────────────────────────────────────────────────

  Widget _panelAcceso({
    required IconData icon,
    required String titulo,
    required String subtexto,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.35), width: 1.2),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 12),
          Text(titulo,
            style: GoogleFonts.bebasNeue(fontSize: 20, letterSpacing: 1.5, color: Colors.white)),
          const SizedBox(height: 6),
          Text(subtexto,
            style: GoogleFonts.barlow(fontSize: 11, color: AppColors.white30, height: 1.4)),
          const SizedBox(height: 12),
          Row(children: [
            Text('VER TODO',
              style: GoogleFonts.barlowCondensed(fontSize: 12, color: color, letterSpacing: 1.5)),
            const SizedBox(width: 4),
            Icon(Icons.arrow_forward, color: color, size: 12),
          ]),
        ]),
      ),
    );
  }

  // ── BANNER CARD ──────────────────────────────────────────────────────────────

  Widget _bannerCard(Map<String, dynamic> b, int idx) {
    final color = b['color'] as Color;
    final isActive = idx == _bannerIdx;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(isActive ? 0.14 : 0.07),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: color.withOpacity(isActive ? 0.5 : 0.2),
          width: isActive ? 1.4 : 1,
        ),
      ),
      child: Row(children: [
        Container(
          width: 42, height: 42,
          decoration: BoxDecoration(
            color: color.withOpacity(0.18),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(b['icon'] as IconData, color: color, size: 22),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(b['titulo'] as String,
            style: GoogleFonts.bebasNeue(fontSize: 15, letterSpacing: 1, color: Colors.white)),
          Text(b['sub'] as String,
            style: GoogleFonts.barlow(fontSize: 11, color: AppColors.white30)),
        ])),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Text(b['tag'] as String,
            style: GoogleFonts.barlowCondensed(fontSize: 9, letterSpacing: 1.5, color: color)),
        ),
      ]),
    );
  }

  // ── PANTALLA TORNEOS ─────────────────────────────────────────────────────────

  Widget _pantallaTorneos() {
    final proximos    = _torneos.where((t) => t['estado'] == 'inscripcion').toList();
    final enCurso     = _torneos.where((t) => t['estado'] == 'en_juego').toList();
    final finalizados = _torneos.where((t) => t['estado'] == 'finalizado' || t['estado'] == 'cancelado').toList();
    final hayFiltros  = _filtroEstado.isNotEmpty ||
        _distritoCtrl.text.trim().isNotEmpty || _localidadCtrl.text.trim().isNotEmpty;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

        TextField(
          controller: _buscarTorneoCtrl,
          style: const TextStyle(color: Colors.white),
          onChanged: (_) { setState(() {}); _cargarTorneos(); },
          decoration: InputDecoration(
            labelText: 'Buscar torneo por nombre',
            prefixIcon: const Icon(Icons.search, color: AppColors.white30),
            suffixIcon: _buscarTorneoCtrl.text.isNotEmpty
                ? IconButton(icon: const Icon(Icons.clear, color: AppColors.white30),
                    onPressed: () { _buscarTorneoCtrl.clear(); _cargarTorneos(); setState(() {}); })
                : null,
          ),
        ),
        const SizedBox(height: 10),

        // Filtros
        GestureDetector(
          onTap: () => setState(() => _showFiltrosTorneos = !_showFiltrosTorneos),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: hayFiltros ? AppColors.blue.withOpacity(0.15) : AppColors.white05,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: hayFiltros ? AppColors.blueBright : AppColors.white10),
            ),
            child: Row(children: [
              Icon(Icons.filter_list, color: hayFiltros ? AppColors.blueBright : AppColors.white30, size: 16),
              const SizedBox(width: 8),
              Text(hayFiltros ? 'Filtros activos' : 'Filtrar por zona / estado',
                style: GoogleFonts.barlowCondensed(fontSize: 13, letterSpacing: 1,
                  color: hayFiltros ? AppColors.blueBright : AppColors.white30)),
              const Spacer(),
              Icon(_showFiltrosTorneos ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                color: AppColors.white30, size: 16),
            ]),
          ),
        ),

        if (_showFiltrosTorneos) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.navy3, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.white10)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Estado', style: GoogleFonts.barlowCondensed(fontSize: 11, letterSpacing: 2, color: AppColors.white30)),
              const SizedBox(height: 6),
              Wrap(spacing: 8, runSpacing: 6, children: [
                _chip('Todos',       _filtroEstado.isEmpty,          () => setState(() { _filtroEstado = ''; _cargarTorneos(); })),
                _chip('Próximos',    _filtroEstado == 'inscripcion', () => setState(() { _filtroEstado = 'inscripcion'; _cargarTorneos(); }), color: AppColors.blueBright),
                _chip('En curso',    _filtroEstado == 'en_juego',    () => setState(() { _filtroEstado = 'en_juego'; _cargarTorneos(); }), color: AppColors.green),
                _chip('Finalizados', _filtroEstado == 'finalizado',  () => setState(() { _filtroEstado = 'finalizado'; _cargarTorneos(); }), color: AppColors.white30),
              ]),
              const SizedBox(height: 12),
              Text('Distrito', style: GoogleFonts.barlowCondensed(fontSize: 11, letterSpacing: 2, color: AppColors.white30)),
              const SizedBox(height: 6),
              _filtroTextField(_distritoCtrl, 'Ej: La costa, Pinamar...', _onDistChanged,
                onClear: () { _distritoCtrl.clear(); _localidadCtrl.clear(); setState(() {}); _cargarTorneos(); }),
              if (_showDistSug) _suggestionList(_distSuggestions, _selectDist, Icons.map_outlined),
              const SizedBox(height: 10),
              Text('Localidad', style: GoogleFonts.barlowCondensed(fontSize: 11, letterSpacing: 2, color: AppColors.white30)),
              const SizedBox(height: 6),
              _filtroTextField(_localidadCtrl,
                _distritoCtrl.text.isNotEmpty ? 'Ej: Santa Teresita, Mar de Ajó...' : 'Primero elegí el distrito',
                _onLocChanged,
                enabled: _distritoCtrl.text.isNotEmpty,
                onClear: () { _localidadCtrl.clear(); setState(() {}); _cargarTorneos(); }),
              if (_showLocSug) _suggestionList(_locSuggestions, _selectLoc, Icons.place_outlined),
              if (hayFiltros) ...[
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () => setState(() {
                    _filtroEstado = ''; _distritoCtrl.clear(); _localidadCtrl.clear();
                    _showDistSug = false; _showLocSug = false; _cargarTorneos();
                  }),
                  child: Row(children: [
                    const Icon(Icons.clear_all, color: AppColors.red, size: 16),
                    const SizedBox(width: 6),
                    Text('Limpiar filtros', style: GoogleFonts.barlowCondensed(fontSize: 13, color: AppColors.red)),
                  ]),
                ),
              ],
            ]),
          ),
        ],

        const SizedBox(height: 16),
        if (_cargandoTorneos)
          const Center(child: Padding(padding: EdgeInsets.all(32),
            child: CircularProgressIndicator(color: AppColors.blueBright, strokeWidth: 2)))
        else if (_torneos.isEmpty)
          Center(child: Padding(padding: const EdgeInsets.all(32), child: Column(children: [
            const Icon(Icons.emoji_events_outlined, color: AppColors.white30, size: 48),
            const SizedBox(height: 12),
            Text('No hay torneos disponibles', style: GoogleFonts.barlowCondensed(fontSize: 16, color: AppColors.white30)),
            Text('Volvé pronto', style: GoogleFonts.barlow(fontSize: 12, color: AppColors.white30)),
          ])))
        else ...[
          if (proximos.isNotEmpty) ...[
            _seccionLabel('PRÓXIMOS · INSCRIPCIÓN', AppColors.blueBright),
            const SizedBox(height: 8),
            ...proximos.map(_torneoCard),
            const SizedBox(height: 16),
          ],
          if (enCurso.isNotEmpty) ...[
            _seccionLabel('EN CURSO', AppColors.green),
            const SizedBox(height: 8),
            ...enCurso.map(_torneoCard),
            const SizedBox(height: 16),
          ],
          if (finalizados.isNotEmpty) ...[
            _seccionLabel('FINALIZADOS', AppColors.white30),
            const SizedBox(height: 8),
            ...finalizados.map(_torneoCard),
          ],
        ],
      ]),
    );
  }

  // ── PANTALLA JUGADORES ───────────────────────────────────────────────────────

  Widget _pantallaJugadores() {
    final hayFiltros = _filtroGeneroJug.isNotEmpty || _filtroManoJug.isNotEmpty ||
        _filtroLadoJug.isNotEmpty || _filtroCatJug > 0 ||
        _distJugCtrl.text.trim().isNotEmpty || _locJugCtrl.text.trim().isNotEmpty;

    return Column(children: [
      Expanded(child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

          // Buscador
          TextField(
            controller: _buscarJugCtrl,
            style: const TextStyle(color: Colors.white),
            onChanged: (_) { setState(() {}); _buscarJugadores(); },
            decoration: InputDecoration(
              labelText: 'Buscar por nombre o apellido',
              prefixIcon: const Icon(Icons.search, color: AppColors.white30),
              suffixIcon: _buscarJugCtrl.text.isNotEmpty
                  ? IconButton(icon: const Icon(Icons.clear, color: AppColors.white30),
                      onPressed: () { _buscarJugCtrl.clear(); setState(() {}); _buscarJugadores(); })
                  : null,
            ),
          ),
          const SizedBox(height: 10),

          // Filtros colapsables
          GestureDetector(
            onTap: () => setState(() => _showFiltrosJug = !_showFiltrosJug),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: hayFiltros ? AppColors.yellow.withOpacity(0.12) : AppColors.white05,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: hayFiltros ? AppColors.yellow : AppColors.white10),
              ),
              child: Row(children: [
                Icon(Icons.filter_list, color: hayFiltros ? AppColors.yellow : AppColors.white30, size: 16),
                const SizedBox(width: 8),
                Text(hayFiltros ? 'Filtros activos' : 'Filtrar jugadores',
                  style: GoogleFonts.barlowCondensed(fontSize: 13, letterSpacing: 1,
                    color: hayFiltros ? AppColors.yellow : AppColors.white30)),
                const Spacer(),
                Icon(_showFiltrosJug ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: AppColors.white30, size: 16),
              ]),
            ),
          ),

          if (_showFiltrosJug) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: AppColors.navy3, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.white10)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                // Distrito
                Text('Distrito', style: GoogleFonts.barlowCondensed(fontSize: 11, letterSpacing: 2, color: AppColors.white30)),
                const SizedBox(height: 6),
                _filtroTextField(_distJugCtrl, 'Ej: La costa, Pinamar...', _onDistJugChanged,
                  onClear: () { _distJugCtrl.clear(); _locJugCtrl.clear(); setState(() {}); _buscarJugadores(); }),
                if (_showDistJugSug) _suggestionList(_distJugSug, _selectDistJug, Icons.map_outlined),
                const SizedBox(height: 10),

                // Localidad
                Text('Localidad', style: GoogleFonts.barlowCondensed(fontSize: 11, letterSpacing: 2, color: AppColors.white30)),
                const SizedBox(height: 6),
                _filtroTextField(_locJugCtrl,
                  _distJugCtrl.text.isNotEmpty ? 'Ej: Santa Teresita, Mar de Ajó...' : 'Primero elegí el distrito',
                  _onLocJugChanged,
                  enabled: _distJugCtrl.text.isNotEmpty,
                  onClear: () { _locJugCtrl.clear(); setState(() {}); _buscarJugadores(); }),
                if (_showLocJugSug) _suggestionList(_locJugSug, _selectLocJug, Icons.place_outlined),
                const SizedBox(height: 12),

                // Género
                Text('Género', style: GoogleFonts.barlowCondensed(fontSize: 11, letterSpacing: 2, color: AppColors.white30)),
                const SizedBox(height: 6),
                Wrap(spacing: 8, runSpacing: 6, children: [
                  _chip('Todos',      _filtroGeneroJug.isEmpty,          () => setState(() { _filtroGeneroJug = ''; _buscarJugadores(); })),
                  _chip('Masculino',  _filtroGeneroJug == 'masculino',   () => setState(() { _filtroGeneroJug = 'masculino'; _buscarJugadores(); })),
                  _chip('Femenino',   _filtroGeneroJug == 'femenino',    () => setState(() { _filtroGeneroJug = 'femenino'; _buscarJugadores(); })),
                ]),
                const SizedBox(height: 12),

                // Mano hábil
                Text('Mano hábil', style: GoogleFonts.barlowCondensed(fontSize: 11, letterSpacing: 2, color: AppColors.white30)),
                const SizedBox(height: 6),
                Wrap(spacing: 8, runSpacing: 6, children: [
                  _chip('Todas',      _filtroManoJug.isEmpty,          () => setState(() { _filtroManoJug = ''; _buscarJugadores(); })),
                  _chip('Derecha',    _filtroManoJug == 'derecha',     () => setState(() { _filtroManoJug = 'derecha'; _buscarJugadores(); })),
                  _chip('Izquierda',  _filtroManoJug == 'izquierda',   () => setState(() { _filtroManoJug = 'izquierda'; _buscarJugadores(); })),
                ]),
                const SizedBox(height: 12),

                // Posición en cancha
                Text('Posición en cancha', style: GoogleFonts.barlowCondensed(fontSize: 11, letterSpacing: 2, color: AppColors.white30)),
                const SizedBox(height: 6),
                Wrap(spacing: 8, runSpacing: 6, children: [
                  _chip('Todos',   _filtroLadoJug.isEmpty,        () => setState(() { _filtroLadoJug = ''; _buscarJugadores(); })),
                  _chip('Drive',   _filtroLadoJug == 'drive',     () => setState(() { _filtroLadoJug = 'drive'; _buscarJugadores(); })),
                  _chip('Revés',   _filtroLadoJug == 'reves',     () => setState(() { _filtroLadoJug = 'reves'; _buscarJugadores(); })),
                  _chip('Ambos',   _filtroLadoJug == 'ambos',     () => setState(() { _filtroLadoJug = 'ambos'; _buscarJugadores(); })),
                ]),
                const SizedBox(height: 12),

                // Categoría
                Text('Categoría', style: GoogleFonts.barlowCondensed(fontSize: 11, letterSpacing: 2, color: AppColors.white30)),
                const SizedBox(height: 6),
                Wrap(spacing: 8, runSpacing: 6, children: [
                  _chip('Todas', _filtroCatJug == 0, () => setState(() { _filtroCatJug = 0; _buscarJugadores(); })),
                  ...List.generate(8, (i) {
                    final cat = i + 1;
                    return _chip('${cat}a', _filtroCatJug == cat,
                      () => setState(() { _filtroCatJug = _filtroCatJug == cat ? 0 : cat; _buscarJugadores(); }));
                  }),
                ]),

                if (hayFiltros) ...[
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: _limpiarFiltrosJug,
                    child: Row(children: [
                      const Icon(Icons.clear_all, color: AppColors.red, size: 16),
                      const SizedBox(width: 6),
                      Text('Limpiar filtros', style: GoogleFonts.barlowCondensed(fontSize: 13, color: AppColors.red)),
                    ]),
                  ),
                ],
              ]),
            ),
          ],

          const SizedBox(height: 16),
          if (_cargandoJug)
            const Center(child: CircularProgressIndicator(color: AppColors.blueBright, strokeWidth: 2))
          else if (_jugadores.isEmpty)
            Center(child: Padding(padding: const EdgeInsets.only(top: 32), child: Column(children: [
              const Icon(Icons.person_search_outlined, color: AppColors.white30, size: 48),
              const SizedBox(height: 12),
              Text(
                _buscarJugCtrl.text.isEmpty && !hayFiltros
                  ? 'Buscá un jugador o usá los filtros'
                  : 'Sin resultados',
                style: GoogleFonts.barlowCondensed(fontSize: 15, color: AppColors.white30),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text('Próximamente: estadísticas y rankings',
                style: GoogleFonts.barlow(fontSize: 12, color: AppColors.white30)),
            ])))
          else
            ...(_jugadores.map(_jugadorTile)),
        ]),
      )),
    ]);
  }

  // ── WIDGETS HELPERS ──────────────────────────────────────────────────────────

  Widget _torneoCard(Map<String, dynamic> t) {
    final estado = (t['estado'] as String?) ?? '';
    final (estadoTxt, estadoColor) = switch (estado) {
      'inscripcion' => ('INSCRIPCIÓN', AppColors.blueBright),
      'en_juego'    => ('EN JUEGO', AppColors.green),
      'finalizado'  => ('FINALIZADO', AppColors.white30),
      _             => ('CANCELADO', AppColors.red),
    };
    final nombre   = t['nombre']?.toString() ?? 'Torneo';
    final fechas   = t['fecha_inicio'] != null ? '${t['fecha_inicio']} → ${t['fecha_fin'] ?? ''}' : '';
    final clubes   = t['clubes'] is List ? (t['clubes'] as List).join(', ') : (t['club']?.toString() ?? '');
    final distrito = t['distrito']?.toString() ?? '';
    final localidad = t['localidad']?.toString() ?? '';
    final zona     = [localidad, distrito].where((s) => s.isNotEmpty).join(', ');

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
          Expanded(child: Text(nombre,
            style: GoogleFonts.barlowCondensed(fontSize: 17, fontWeight: FontWeight.w700, color: Colors.white))),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: estadoColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: estadoColor.withOpacity(0.5)),
            ),
            child: Text(estadoTxt,
              style: GoogleFonts.barlowCondensed(fontSize: 10, letterSpacing: 2, color: estadoColor)),
          ),
        ]),
        if (fechas.isNotEmpty) ...[
          const SizedBox(height: 4),
          Row(children: [
            const Icon(Icons.calendar_today_outlined, color: AppColors.white30, size: 12),
            const SizedBox(width: 4),
            Text(fechas, style: GoogleFonts.barlow(fontSize: 12, color: AppColors.white30)),
          ]),
        ],
        if (clubes.isNotEmpty || zona.isNotEmpty) ...[
          const SizedBox(height: 2),
          Row(children: [
            const Icon(Icons.location_on_outlined, color: AppColors.white30, size: 12),
            const SizedBox(width: 4),
            Expanded(child: Text([clubes, zona].where((s) => s.isNotEmpty).join(' · '),
              style: GoogleFonts.barlow(fontSize: 12, color: AppColors.white30))),
          ]),
        ],
      ]),
    );
  }

  Widget _jugadorTile(Map<String, dynamic> j) {
    final nombre   = j['nombre'] as String? ?? '';
    final apellido = j['apellido'] as String? ?? '';
    final cat      = j['categoria'] is int ? j['categoria'] as int : int.tryParse(j['categoria']?.toString() ?? '') ?? 0;
    final catObs   = j['categoria_observada'] is int ? j['categoria_observada'] as int? : int.tryParse(j['categoria_observada']?.toString() ?? '');
    final initials = nombre.isNotEmpty ? '${nombre[0]}${apellido.isNotEmpty ? apellido[0] : ''}'.toUpperCase() : 'J';
    final loc      = j['localidad'] as String? ?? '';
    final dis      = j['distrito'] as String? ?? '';
    final mano     = j['mano_habil'] as String? ?? '';
    final lado     = j['lado_cancha'] as String? ?? '';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white05,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.white10),
      ),
      child: Row(children: [
        ProfileAvatar(
          fotoUrl: j['foto_url'] as String?,
          initials: initials,
          categoria: cat,
          categoriaObservada: catObs != null && catObs != cat ? catObs : null,
          radius: 22,
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('$nombre $apellido',
            style: GoogleFonts.barlowCondensed(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white)),
          if (loc.isNotEmpty || dis.isNotEmpty)
            Text([if (loc.isNotEmpty) loc, if (dis.isNotEmpty) dis].join(' · '),
              style: GoogleFonts.barlow(fontSize: 11, color: AppColors.white30)),
          if (mano.isNotEmpty || lado.isNotEmpty)
            Text([if (mano.isNotEmpty) mano, if (lado.isNotEmpty) lado].join(' · '),
              style: GoogleFonts.barlow(fontSize: 11, color: AppColors.white30)),
        ])),
      ]),
    );
  }

  Widget _filtroTextField(TextEditingController ctrl, String hint, ValueChanged<String> onChanged,
      {bool enabled = true, VoidCallback? onClear}) {
    return TextField(
      controller: ctrl,
      enabled: enabled,
      style: TextStyle(color: enabled ? Colors.white : AppColors.white30, fontSize: 14),
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.white30, fontSize: 13),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        filled: true, fillColor: AppColors.navy,
        suffixIcon: ctrl.text.isNotEmpty && onClear != null
            ? IconButton(icon: const Icon(Icons.clear, color: AppColors.white30, size: 16), onPressed: onClear)
            : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.white10)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.white10)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.blueBright)),
        disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.white10)),
      ),
    );
  }

  Widget _seccionLabel(String label, Color color) => Text(label,
    style: GoogleFonts.barlowCondensed(fontSize: 11, letterSpacing: 3, color: color));

  Widget _suggestionList(List<String> items, ValueChanged<String> onTap, IconData icon) =>
    Container(
      margin: const EdgeInsets.only(top: 2),
      decoration: BoxDecoration(color: AppColors.navy3, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.white10)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 180),
        child: ListView(shrinkWrap: true, children: items.map((s) => InkWell(
          onTap: () => onTap(s),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(children: [
              Icon(icon, color: AppColors.white30, size: 14),
              const SizedBox(width: 10),
              Text(s, style: GoogleFonts.barlow(fontSize: 14, color: Colors.white)),
            ]),
          ),
        )).toList()),
      ),
    );

  Widget _chip(String label, bool active, VoidCallback onTap, {Color? color}) {
    final c = color ?? AppColors.blueBright;
    return GestureDetector(onTap: onTap, child: AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: active ? c.withOpacity(0.2) : AppColors.white05,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: active ? c : AppColors.white10, width: active ? 1.5 : 1),
      ),
      child: Text(label, style: GoogleFonts.barlowCondensed(fontSize: 13, fontWeight: FontWeight.w600, color: active ? c : AppColors.white30)),
    ));
  }
}