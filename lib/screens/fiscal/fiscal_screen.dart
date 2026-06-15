import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../theme/app_colors.dart';
import '../../painters/diagonal_bg_painter.dart';
import '../../widgets/profile_avatar.dart';
import '../home/home_screen.dart';
import '../../widgets/distrito_localidad_selector.dart';

class FiscalScreen extends StatefulWidget {
  final VoidCallback onUpdate;
  const FiscalScreen({super.key, required this.onUpdate});
  @override
  State<FiscalScreen> createState() => _FiscalScreenState();
}

class _FiscalScreenState extends State<FiscalScreen> {
  final _buscarCtrl    = TextEditingController();
  final _notaCtrl      = TextEditingController();

  String _filtroDistrito  = '';
  String _filtroLocalidad = '';

  String _filtroMano   = '';
  String _filtroLado   = '';
  String _filtroGenero = '';
  int    _filtroCat    = 0;

  List<Map<String, dynamic>> _resultados = [];
  bool _buscando       = false;
  Map<String, dynamic>? _jugadorSel;
  int  _nuevaCat       = 0;
  int  _catObs         = 0;
  bool _guardando      = false;
  Map<String, dynamic>? _fiscalPerfil;
  bool _showFiltros    = false;
  List<Map<String, dynamic>> _notas = [];
  bool _guardandoNota  = false;
  bool _eliminandoNota = false;

  // helper seguro para castear categoria (puede llegar como int o String)
  int _toInt(dynamic v) => v == null ? 0 : (v is int ? v : int.tryParse(v.toString()) ?? 0);

  @override
  void initState() { super.initState(); _loadFiscalPerfil(); }

  Future<void> _loadFiscalPerfil() async {
    final uid = Supabase.instance.client.auth.currentUser?.id;
    if (uid == null) return;
    final data = await Supabase.instance.client.from('usuarios').select().eq('id', uid).single();
    if (mounted) setState(() => _fiscalPerfil = data);
  }

  Future<void> _buscar() async {
    final q   = _buscarCtrl.text.trim();
    final loc = _filtroLocalidad.trim();
    final dis = _filtroDistrito.trim();
    setState(() { _buscando = true; _resultados = []; _jugadorSel = null; });
    try {
      var query = Supabase.instance.client.from('usuarios').select();
      if (RegExp(r'^\d{4,8}$').hasMatch(q)) {
        query = query.ilike('dni', '%$q%') as dynamic;
      } else if (q.isNotEmpty) {
        query = query.or('nombre.ilike.%$q%,apellido.ilike.%$q%') as dynamic;
      }
      if (_filtroMano.isNotEmpty)   query = query.eq('mano_habil', _filtroMano) as dynamic;
      if (_filtroLado.isNotEmpty)   query = query.eq('lado_cancha', _filtroLado) as dynamic;
      if (_filtroGenero.isNotEmpty) query = query.eq('genero', _filtroGenero) as dynamic;
      if (_filtroCat > 0)           query = query.eq('categoria', _filtroCat) as dynamic;
      if (dis.isNotEmpty)           query = query.ilike('distrito', '%$dis%') as dynamic;
      if (loc.isNotEmpty)           query = query.ilike('localidad', '%$loc%') as dynamic;
      final res = await query.order('nombre').limit(20);
      if (mounted) setState(() => _resultados = List<Map<String, dynamic>>.from(res));
    } catch (e) {
      _toast('Error al buscar: $e', error: true);
    } finally {
      if (mounted) setState(() => _buscando = false);
    }
  }

  void _selJugador(Map<String, dynamic> j) {
    setState(() {
      _jugadorSel = j;
      _nuevaCat   = _toInt(j['categoria']);
      _catObs     = _toInt(j['categoria_observada']);
      _notas      = [];
    });
    _loadNotas(j['id'] as String);
  }

  Future<void> _loadNotas(String jugadorId) async {
    try {
      final res = await Supabase.instance.client
          .from('fiscal_notas').select().eq('jugador_id', jugadorId)
          .order('created_at', ascending: false);
      if (mounted) setState(() => _notas = List<Map<String, dynamic>>.from(res));
    } catch (e) { debugPrint('Error loading notas: $e'); }
  }

  Future<void> _guardarNota() async {
    final texto = _notaCtrl.text.trim();
    if (texto.isEmpty || _jugadorSel == null) return;
    final uid = Supabase.instance.client.auth.currentUser?.id;
    if (uid == null) return;
    setState(() => _guardandoNota = true);
    try {
      final fn = (_fiscalPerfil?['nombre'] as String? ?? '').trim();
      final fa = (_fiscalPerfil?['apellido'] as String? ?? '').trim();
      await Supabase.instance.client.from('fiscal_notas').insert({
        'jugador_id'   : _jugadorSel!['id'],
        'fiscal_id'    : uid,
        'fiscal_nombre': '$fn $fa'.trim(),
        'nota'         : texto,
      });
      _notaCtrl.clear();
      await _loadNotas(_jugadorSel!['id'] as String);
    } catch (e) {
      _toast('Error al guardar nota: $e', error: true);
    } finally {
      if (mounted) setState(() => _guardandoNota = false);
    }
  }

  Future<void> _eliminarNota(String notaId) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.navy3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: Text('Eliminar nota', style: GoogleFonts.bebasNeue(fontSize: 22, color: Colors.white)),
        content: Text('¿Confirmás que querés eliminar esta nota?',
          style: GoogleFonts.barlow(fontSize: 14, color: AppColors.white30)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false),
            child: Text('Cancelar', style: GoogleFonts.barlowCondensed(color: AppColors.white30))),
          TextButton(onPressed: () => Navigator.pop(context, true),
            child: Text('Eliminar', style: GoogleFonts.barlowCondensed(color: AppColors.red, fontWeight: FontWeight.w700))),
        ],
      ),
    );
    if (ok != true) return;
    setState(() => _eliminandoNota = true);
    try {
      await Supabase.instance.client.from('fiscal_notas').delete().eq('id', notaId);
      await _loadNotas(_jugadorSel!['id'] as String);
    } catch (e) {
      _toast('Error al eliminar nota: $e', error: true);
    } finally {
      if (mounted) setState(() => _eliminandoNota = false);
    }
  }

  Future<void> _guardarCategoria() async {
    if (_jugadorSel == null) return;
    setState(() => _guardando = true);
    try {
      final fn = (_fiscalPerfil?['nombre'] as String? ?? '').trim();
      final fa = (_fiscalPerfil?['apellido'] as String? ?? '').trim();
      final fiscalNombre = '$fn $fa'.trim();
      await Supabase.instance.client.from('usuarios').update({
        'categoria'              : _nuevaCat > 0 ? _nuevaCat : null,
        'categoria_observada'    : _catObs > 0 ? _catObs : null,
        'categorizado_por_nombre': fiscalNombre.isNotEmpty ? fiscalNombre : null,
        'categorizado_fecha'     : DateTime.now().toIso8601String(),
      }).eq('id', _jugadorSel!['id']);
      _toast('Categoría actualizada!');
      widget.onUpdate();
      _buscar();
      setState(() => _jugadorSel = null);
    } catch (e) {
      _toast('Error: $e', error: true);
    } finally {
      if (mounted) setState(() => _guardando = false);
    }
  }

  void _limpiarFiltros() {
    setState(() {
      _filtroMano = ''; _filtroLado = ''; _filtroGenero = ''; _filtroCat = 0;
      _filtroDistrito = ''; _filtroLocalidad = '';
    });
    _buscar();
  }

  void _toast(String msg, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg, style: GoogleFonts.barlowCondensed(fontSize: 15)),
      backgroundColor: error ? AppColors.red : AppColors.green,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }

  @override
  void dispose() {
    _buscarCtrl.dispose(); _notaCtrl.dispose();
    super.dispose();
  }

  // ─── BUILD ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final fiscalNombre   = _fiscalPerfil?['nombre'] as String? ?? 'Fiscal';
    final fiscalAp       = _fiscalPerfil?['apellido'] as String? ?? '';
    final fiscalFoto     = _fiscalPerfil?['foto_url'] as String?;
    final fiscalInitials = fiscalNombre.isNotEmpty
        ? '${fiscalNombre[0]}${fiscalAp.isNotEmpty ? fiscalAp[0] : ''}'.toUpperCase() : 'F';

    return Scaffold(
      body: Stack(children: [
        Container(decoration: const BoxDecoration(gradient: LinearGradient(
          begin: Alignment.topCenter, end: Alignment.bottomCenter,
          colors: [AppColors.navy, AppColors.navy2],
        ))),
        CustomPaint(painter: DiagonalBgPainter(), child: Container()),
        SafeArea(child: Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
            child: Row(children: [
              ProfileAvatar(fotoUrl: fiscalFoto, initials: fiscalInitials, categoria: 0, radius: 22),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('PANEL FISCAL', style: GoogleFonts.bebasNeue(fontSize: 24, letterSpacing: 2, color: Colors.white)),
                Text('$fiscalNombre $fiscalAp'.trim(),
                  style: GoogleFonts.barlowCondensed(fontSize: 13, color: AppColors.yellow, letterSpacing: 1)),
              ])),
              TextButton.icon(
                onPressed: () {
                  if (context.mounted) Navigator.pushAndRemoveUntil(context,
                    MaterialPageRoute(builder: (_) => const HomeScreen()), (route) => false);
                },
                icon: const Icon(Icons.logout, color: AppColors.white30, size: 16),
                label: Text('Salir', style: GoogleFonts.barlowCondensed(color: AppColors.white30, fontSize: 13)),
              ),
            ]),
          ),
          const Divider(color: AppColors.white10, height: 1),
          Expanded(child: _tabJugadores()),
        ])),
      ]),
    );
  }

  // ─── BÚSQUEDA + FILTROS ─────────────────────────────────────────────────────

  Widget _tabJugadores() {
    final hayFiltros = _filtroMano.isNotEmpty || _filtroLado.isNotEmpty ||
        _filtroGenero.isNotEmpty || _filtroCat > 0 ||
        _filtroDistrito.isNotEmpty || _filtroLocalidad.isNotEmpty;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        TextField(
          controller: _buscarCtrl,
          style: const TextStyle(color: Colors.white),
          onChanged: (val) { setState(() {}); _buscar(); },
          decoration: InputDecoration(
            labelText: 'Buscar por nombre, apellido o DNI',
            prefixIcon: const Icon(Icons.search, color: AppColors.white30),
            suffixIcon: _buscarCtrl.text.isNotEmpty
                ? IconButton(icon: const Icon(Icons.clear, color: AppColors.white30),
                    onPressed: () { _buscarCtrl.clear(); _buscar(); setState(() {}); })
                : null,
          ),
        ),
        const SizedBox(height: 10),

        // Botón filtros
        GestureDetector(
          onTap: () => setState(() => _showFiltros = !_showFiltros),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: hayFiltros ? AppColors.blue.withOpacity(0.15) : AppColors.white05,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: hayFiltros ? AppColors.blueBright : AppColors.white10),
            ),
            child: Row(children: [
              Icon(Icons.filter_list, color: hayFiltros ? AppColors.blueBright : AppColors.white30, size: 18),
              const SizedBox(width: 8),
              Text(hayFiltros ? 'Filtros activos' : 'Filtros',
                style: GoogleFonts.barlowCondensed(fontSize: 14, letterSpacing: 1,
                  color: hayFiltros ? AppColors.blueBright : AppColors.white30)),
              if (hayFiltros) ...[
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(color: AppColors.blueBright, borderRadius: BorderRadius.circular(10)),
                  child: Text(
                    [
                      if (_filtroGenero.isNotEmpty) _filtroGenero == 'masculino' ? 'Masculino' : 'Femenino',
                      if (_filtroMano.isNotEmpty) _filtroMano,
                      if (_filtroLado.isNotEmpty) _filtroLado,
                      if (_filtroCat > 0) '${_filtroCat}a',
                      if (_filtroDistrito.isNotEmpty) _filtroDistrito,
                      if (_filtroLocalidad.isNotEmpty) _filtroLocalidad,
                    ].join(' · '),
                    style: GoogleFonts.barlowCondensed(fontSize: 11, color: Colors.white),
                  ),
                ),
              ],
              const Spacer(),
              Icon(_showFiltros ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: AppColors.white30, size: 18),
            ]),
          ),
        ),

        if (_showFiltros) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.navy3, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.white10)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

              // Distrito + Localidad
              DistritoLocalidadSelector(
                distrito: _filtroDistrito.isNotEmpty ? _filtroDistrito : null,
                localidad: _filtroLocalidad.isNotEmpty ? _filtroLocalidad : null,
                onDistritoChanged: (v) => setState(() {
                  _filtroDistrito = v ?? '';
                  _filtroLocalidad = '';
                  _buscar();
                }),
                onLocalidadChanged: (v) => setState(() {
                  _filtroLocalidad = v ?? '';
                  _buscar();
                }),
              ),
              const SizedBox(height: 12),

              // Género
              Text('Género', style: GoogleFonts.barlowCondensed(fontSize: 11, letterSpacing: 2, color: AppColors.white30)),
              const SizedBox(height: 6),
              Wrap(spacing: 8, children: [
                _chip('Todos',      _filtroGenero.isEmpty,         () => setState(() { _filtroGenero = ''; _buscar(); })),
                _chip('Masculino', _filtroGenero == 'masculino', () => setState(() { _filtroGenero = 'masculino'; _buscar(); })),
                _chip('Femenino',  _filtroGenero == 'femenino',  () => setState(() { _filtroGenero = 'femenino'; _buscar(); })),
              ]),
              const SizedBox(height: 12),

              // Mano hábil
              Text('Mano hábil', style: GoogleFonts.barlowCondensed(fontSize: 11, letterSpacing: 2, color: AppColors.white30)),
              const SizedBox(height: 6),
              Wrap(spacing: 8, children: [
                _chip('Todas',   _filtroMano.isEmpty,      () => setState(() { _filtroMano = ''; _buscar(); })),
                _chip('Derecha', _filtroMano == 'derecha', () => setState(() { _filtroMano = 'derecha'; _buscar(); })),
                _chip('Izquierda', _filtroMano == 'izquierda', () => setState(() { _filtroMano = 'izquierda'; _buscar(); })),
              ]),
              const SizedBox(height: 12),

              // Posición en cancha
              Text('Posición en cancha', style: GoogleFonts.barlowCondensed(fontSize: 11, letterSpacing: 2, color: AppColors.white30)),
              const SizedBox(height: 6),
              Wrap(spacing: 8, children: [
                _chip('Todos',  _filtroLado.isEmpty,      () => setState(() { _filtroLado = ''; _buscar(); })),
                _chip('Drive',  _filtroLado == 'drive',   () => setState(() { _filtroLado = 'drive'; _buscar(); })),
                _chip('Revés',  _filtroLado == 'reves',   () => setState(() { _filtroLado = 'reves'; _buscar(); })),
              ]),
              const SizedBox(height: 12),

              // Categoría
              Text('Categoría', style: GoogleFonts.barlowCondensed(fontSize: 11, letterSpacing: 2, color: AppColors.white30)),
              const SizedBox(height: 6),
              Wrap(spacing: 8, runSpacing: 6, children: [
                _chip('Todas', _filtroCat == 0, () => setState(() { _filtroCat = 0; _buscar(); })),
                ...List.generate(8, (i) {
                  final cat = i + 1;
                  return _chip('${cat}a', _filtroCat == cat,
                    () => setState(() { _filtroCat = _filtroCat == cat ? 0 : cat; _buscar(); }),
                    color: AppColors.categoryColor(cat));
                }),
              ]),

              if (hayFiltros) ...[
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: _limpiarFiltros,
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
        if (_buscando)
          const Center(child: Padding(padding: EdgeInsets.all(24),
            child: CircularProgressIndicator(color: AppColors.blueBright, strokeWidth: 2)))
        else if (_buscarCtrl.text.isEmpty && !hayFiltros)
          Center(child: Padding(padding: const EdgeInsets.all(24), child: Column(children: [
            const Icon(Icons.search, color: AppColors.white30, size: 40),
            const SizedBox(height: 8),
            Text('Escribí un nombre, apellido o DNI', style: GoogleFonts.barlowCondensed(fontSize: 14, color: AppColors.white30)),
            Text('o usá los filtros para buscar', style: GoogleFonts.barlow(fontSize: 12, color: AppColors.white30)),
          ])))
        else if (_resultados.isEmpty && (_buscarCtrl.text.isNotEmpty || hayFiltros))
          Center(child: Padding(padding: const EdgeInsets.all(24),
            child: Text('Sin resultados', style: GoogleFonts.barlowCondensed(fontSize: 15, color: AppColors.white30))))
        else
          ..._resultados.map((j) => _jugadorTile(j)),

        if (_jugadorSel != null) ...[
          const SizedBox(height: 20),
          _panelJugadorSel(),
        ],
      ]),
    );
  }

  // ─── PANEL JUGADOR ──────────────────────────────────────────────────────────

  Widget _panelJugadorSel() {
    final j = _jugadorSel!;
    final n = j['nombre'] as String? ?? '';
    final a = j['apellido'] as String? ?? '';
    final initials = n.isNotEmpty ? '${n[0]}${a.isNotEmpty ? a[0] : ''}'.toUpperCase() : 'J';
    final cat    = _toInt(j['categoria']);
    final catObs = _toInt(j['categoria_observada']);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white05,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.yellow.withOpacity(0.3)),
      ),
      child: Column(children: [
        // Cabecera
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(children: [
            ProfileAvatar(
              fotoUrl: j['foto_url'] as String?,
              initials: initials,
              categoria: cat,
              categoriaObservada: catObs != 0 && catObs != cat ? catObs : null,
              radius: 24,
            ),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('$n $a', style: GoogleFonts.bebasNeue(fontSize: 20, color: Colors.white)),
              Text(
                [
                  if ((j['dni'] as String?) != null) 'DNI: ${j['dni']}',
                  if ((j['localidad'] as String?)?.isNotEmpty == true) j['localidad'] as String
                  else if ((j['distrito'] as String?)?.isNotEmpty == true) j['distrito'] as String,
                ].join(' · '),
                style: GoogleFonts.barlow(fontSize: 12, color: AppColors.white30),
              ),
            ])),
            IconButton(
              onPressed: () => setState(() { _jugadorSel = null; _notas = []; }),
              icon: const Icon(Icons.close, color: AppColors.white30, size: 20)),
          ]),
        ),
        const Divider(color: AppColors.white10, height: 1),

        DefaultTabController(
          length: 3,
          child: Column(children: [
            TabBar(
              labelColor: AppColors.yellow,
              unselectedLabelColor: AppColors.white30,
              indicatorColor: AppColors.yellow,
              labelStyle: GoogleFonts.barlowCondensed(fontSize: 13, fontWeight: FontWeight.w600, letterSpacing: 1),
              tabs: const [Tab(text: 'PERFIL'), Tab(text: 'CATEGORÍA'), Tab(text: 'NOTAS')],
            ),
            SizedBox(height: 400, child: TabBarView(children: [

              // ── PERFIL (solo vista) ────────────────────────────────────────
              SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  _infoRow(Icons.badge_outlined,        'DNI',              j['dni']),
                  _infoRow(Icons.email_outlined,        'Email',            j['email']),
                  _infoRow(Icons.cake_outlined,         'Nacimiento',       _formatFecha(j['fecha_nacimiento'])),
                  _infoRow(Icons.wc, 'Género', j['genero'] != null ? (j['genero'] == 'masculino' ? 'Masculino' : 'Femenino') : null),
                  _infoRow(Icons.location_on_outlined,  'Localidad',        j['localidad']),
                  _infoRow(Icons.map_outlined,          'Distrito',         j['distrito']),
                  _infoRow(Icons.home_outlined,         'Residencia',       j['residencia']),
                  _infoRow(Icons.sports_tennis, 'Mano hábil', j['mano_habil'] != null ? (j['mano_habil'] == 'izquierda' ? 'Izquierda' : 'Derecha') : null),
                  _infoRow(Icons.swap_horiz,            'Posición cancha',  j['lado_cancha']),
                  _infoRow(Icons.groups_outlined,       'Clubes',           _clubesStr(j['clubes'])),
                ]),
              ),

              // ── CATEGORÍA ─────────────────────────────────────────────────
              SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Categoría', style: GoogleFonts.barlowCondensed(fontSize: 11, letterSpacing: 2, color: AppColors.white30)),
                const SizedBox(height: 8),
                Wrap(spacing: 8, runSpacing: 8, children: List.generate(8, (i) {
                  final c = i + 1;
                  final color  = AppColors.categoryColor(c);
                  final active = _nuevaCat == c;
                  return GestureDetector(
                    onTap: () => setState(() => _nuevaCat = c),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: active ? color.withOpacity(0.2) : AppColors.white05,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: active ? color : AppColors.white10, width: active ? 2 : 1),
                      ),
                      child: Text('${c}a', style: GoogleFonts.barlowCondensed(fontSize: 14, fontWeight: FontWeight.w600, color: active ? color : AppColors.white30)),
                    ),
                  );
                })),
                const SizedBox(height: 16),
                Text('En observación para ascenso', style: GoogleFonts.barlowCondensed(fontSize: 11, letterSpacing: 2, color: AppColors.white30)),
                const SizedBox(height: 8),
                Wrap(spacing: 8, runSpacing: 8, children: [
                  GestureDetector(
                    onTap: () => setState(() => _catObs = 0),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: _catObs == 0 ? AppColors.white10 : AppColors.white05,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: _catObs == 0 ? Colors.white : AppColors.white10, width: _catObs == 0 ? 2 : 1),
                      ),
                      child: Text('Ninguna', style: GoogleFonts.barlowCondensed(fontSize: 14, fontWeight: FontWeight.w600, color: _catObs == 0 ? Colors.white : AppColors.white30)),
                    ),
                  ),
                  ...List.generate(8, (i) {
                    final c = i + 1;
                    final color  = AppColors.categoryColor(c);
                    final active = _catObs == c;
                    return GestureDetector(
                      onTap: () => setState(() => _catObs = c),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: active ? color.withOpacity(0.2) : AppColors.white05,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: active ? color : AppColors.white10, width: active ? 2 : 1),
                        ),
                        child: Text('${c}a', style: GoogleFonts.barlowCondensed(fontSize: 14, fontWeight: FontWeight.w600, color: active ? color : AppColors.white30)),
                      ),
                    );
                  }),
                ]),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _guardando ? null : _guardarCategoria,
                  child: _guardando
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : Text('GUARDAR CATEGORÍA', style: GoogleFonts.barlowCondensed(fontSize: 16, fontWeight: FontWeight.w700, letterSpacing: 2)),
                ),
              ])),

              // ── NOTAS ─────────────────────────────────────────────────────
              Column(children: [
                Expanded(child: _notas.isEmpty
                  ? Center(child: Text('Sin notas aún', style: GoogleFonts.barlowCondensed(fontSize: 14, color: AppColors.white30)))
                  : ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: _notas.length,
                      itemBuilder: (_, i) {
                        final nota  = _notas[i];
                        final fecha = _formatFecha(nota['created_at']);
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(color: AppColors.navy3, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.white10)),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Row(children: [
                              const Icon(Icons.person_outline, color: AppColors.blueBright, size: 13),
                              const SizedBox(width: 4),
                              Text(nota['fiscal_nombre'] ?? 'Fiscal', style: GoogleFonts.barlowCondensed(fontSize: 12, color: AppColors.blueBright)),
                              const Spacer(),
                              Text(fecha, style: GoogleFonts.barlow(fontSize: 11, color: AppColors.white30)),
                              const SizedBox(width: 8),
                              // Botón eliminar
                              GestureDetector(
                                onTap: _eliminandoNota ? null : () => _eliminarNota(nota['id'] as String),
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: AppColors.red.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: _eliminandoNota
                                      ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(color: AppColors.red, strokeWidth: 2))
                                      : const Icon(Icons.delete_outline, color: AppColors.red, size: 14),
                                ),
                              ),
                            ]),
                            const SizedBox(height: 6),
                            Text(nota['nota'] ?? '', style: GoogleFonts.barlow(fontSize: 13, color: Colors.white)),
                          ]),
                        );
                      },
                    ),
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(border: Border(top: BorderSide(color: AppColors.white10))),
                  child: Row(children: [
                    Expanded(child: TextField(
                      controller: _notaCtrl,
                      onChanged: (_) => setState(() {}),
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      maxLines: 2,
                      decoration: InputDecoration(
                        hintText: 'Agregar observación...',
                        hintStyle: const TextStyle(color: AppColors.white30, fontSize: 13),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        filled: true, fillColor: AppColors.navy3,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.white10)),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.white10)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.blueBright)),
                      ),
                    )),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: _guardandoNota ? null : _guardarNota,
                      child: Container(
                        width: 44, height: 44,
                        decoration: BoxDecoration(
                          color: _notaCtrl.text.trim().isNotEmpty ? AppColors.blue : AppColors.white05,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: _guardandoNota
                            ? const Center(child: SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)))
                            : const Icon(Icons.send, color: Colors.white, size: 18),
                      ),
                    ),
                  ]),
                ),
              ]),

            ])),
          ]),
        ),
      ]),
    );
  }

  // ─── HELPERS ────────────────────────────────────────────────────────────────

  Widget _infoRow(IconData icon, String label, dynamic valor) {
    final texto = valor?.toString().trim() ?? '';
    if (texto.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(icon, color: AppColors.white30, size: 16),
        const SizedBox(width: 10),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: GoogleFonts.barlowCondensed(fontSize: 11, letterSpacing: 1.5, color: AppColors.white30)),
          Text(texto, style: GoogleFonts.barlow(fontSize: 14, color: Colors.white)),
        ])),
      ]),
    );
  }

  String _formatFecha(dynamic fecha) {
    if (fecha == null) return '';
    try {
      final d = DateTime.parse(fecha.toString()).toLocal();
      return '${d.day.toString().padLeft(2,'0')}/${d.month.toString().padLeft(2,'0')}/${d.year}';
    } catch (_) { return fecha.toString(); }
  }

  String _clubesStr(dynamic clubes) {
    if (clubes == null) return '';
    if (clubes is List) return clubes.join(', ');
    return clubes.toString();
  }

  Widget _jugadorTile(Map<String, dynamic> j) {
    final nombre   = j['nombre'] as String? ?? '';
    final apellido = j['apellido'] as String? ?? '';
    final dni      = j['dni'] as String? ?? '';
    final cat      = _toInt(j['categoria']);
    final catObs   = _toInt(j['categoria_observada']);
    final mano     = j['mano_habil'] as String? ?? '';
    final lado     = j['lado_cancha'] as String? ?? '';
    final loc      = j['localidad'] as String? ?? '';
    final dis      = j['distrito'] as String? ?? '';
    final initials = nombre.isNotEmpty ? '${nombre[0]}${apellido.isNotEmpty ? apellido[0] : ''}'.toUpperCase() : 'J';
    final selected = _jugadorSel?['id'] == j['id'];
    return GestureDetector(
      onTap: () => _selJugador(j),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? AppColors.blue.withOpacity(0.15) : AppColors.white05,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: selected ? AppColors.blueBright : AppColors.white10, width: selected ? 1.5 : 1),
        ),
        child: Row(children: [
          ProfileAvatar(
            fotoUrl: j['foto_url'] as String?,
            initials: initials,
            categoria: cat,
            categoriaObservada: catObs != 0 && catObs != cat ? catObs : null,
            radius: 22,
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('$nombre $apellido', style: GoogleFonts.barlowCondensed(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white)),
            Text('DNI: $dni', style: GoogleFonts.barlow(fontSize: 12, color: AppColors.white30)),
            if (loc.isNotEmpty || dis.isNotEmpty)
              Text([if (loc.isNotEmpty) loc, if (dis.isNotEmpty) dis].join(' · '),
                style: GoogleFonts.barlow(fontSize: 11, color: AppColors.white30)),
            if (mano.isNotEmpty || lado.isNotEmpty)
              Text([if (mano.isNotEmpty) mano, if (lado.isNotEmpty) lado].join(' · '),
                style: GoogleFonts.barlow(fontSize: 11, color: AppColors.white30)),
          ])),
          const Icon(Icons.chevron_right, color: AppColors.white30, size: 18),
        ]),
      ),
    );
  }

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