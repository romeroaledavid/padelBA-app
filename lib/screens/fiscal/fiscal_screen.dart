import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../theme/app_colors.dart';
import '../../painters/diagonal_bg_painter.dart';
import '../../widgets/profile_avatar.dart';
import '../home/home_screen.dart';

class FiscalScreen extends StatefulWidget {
  final VoidCallback onUpdate;
  const FiscalScreen({super.key, required this.onUpdate});
  @override
  State<FiscalScreen> createState() => _FiscalScreenState();
}

class _FiscalScreenState extends State<FiscalScreen> with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;
  // Search state
  final _buscarCtrl = TextEditingController();
  String _filtroMano = '';
  String _filtroLado = '';
  int _filtroCat = 0;
  List<Map<String, dynamic>> _resultados = [];
  bool _buscando = false;
  Map<String, dynamic>? _jugadorSel;
  int _nuevaCat = 0;
  int _catObs   = 0;
  bool _guardando = false;
  // Fiscal profile
  Map<String, dynamic>? _fiscalPerfil;
  // Filtros state
  bool _showFiltros = false;
  // Notas state
  List<Map<String, dynamic>> _notas = [];
  final _notaCtrl = TextEditingController();
  bool _guardandoNota = false;
  // Torneo state
  final _tornNombreCtrl = TextEditingController();
  final _tornClubCtrl   = TextEditingController();
  final _tornFechaCtrl  = TextEditingController();
  String _tornFormato   = 'grupos';
  List<int> _tornCats   = [];
  int _tornCanchas      = 2;
  bool _creandoTorneo   = false;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
    _loadFiscalPerfil();
  }

  Future<void> _loadFiscalPerfil() async {
    final uid = Supabase.instance.client.auth.currentUser?.id;
    if (uid == null) return;
    final data = await Supabase.instance.client.from('usuarios').select().eq('id', uid).single();
    if (mounted) setState(() => _fiscalPerfil = data);
  }

  Future<void> _buscar() async {
    final q = _buscarCtrl.text.trim();
    setState(() { _buscando = true; _resultados = []; _jugadorSel = null; });
    try {
      var query = Supabase.instance.client.from('usuarios').select();
      if (RegExp(r'^\d{4,8}$').hasMatch(q)) {
        query = query.ilike('dni', '%$q%') as dynamic;
      } else if (q.isNotEmpty) {
        query = query.or('nombre.ilike.%$q%,apellido.ilike.%$q%') as dynamic;
      }
      if (_filtroMano.isNotEmpty) query = query.eq('mano_habil', _filtroMano) as dynamic;
      if (_filtroLado.isNotEmpty) query = query.eq('lado_cancha', _filtroLado) as dynamic;
      if (_filtroCat > 0) query = query.eq('categoria', _filtroCat) as dynamic;
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
      _nuevaCat = (j['categoria'] as int?) ?? 0;
      _catObs   = (j['categoria_observada'] as int?) ?? 0;
      _notas = [];
    });
    _loadNotas(j['id'] as String);
  }

  Future<void> _loadNotas(String jugadorId) async {
    try {
      final res = await Supabase.instance.client
          .from('fiscal_notas')
          .select()
          .eq('jugador_id', jugadorId)
          .order('created_at', ascending: false);
      if (mounted) setState(() => _notas = List<Map<String, dynamic>>.from(res));
    } catch (e) {
      debugPrint('Error loading notas: $e');
    }
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
        'jugador_id': _jugadorSel!['id'],
        'fiscal_id': uid,
        'fiscal_nombre': '$fn $fa'.trim(),
        'nota': texto,
      });
      _notaCtrl.clear();
      await _loadNotas(_jugadorSel!['id'] as String);
    } catch (e) {
      _toast('Error al guardar nota: $e', error: true);
    } finally {
      if (mounted) setState(() => _guardandoNota = false);
    }
  }

  Future<void> _guardarCategoria() async {
    if (_jugadorSel == null) return;
    setState(() => _guardando = true);
    try {
      final fiscalNombre = '${_fiscalPerfil?['nombre'] ?? ''} ${_fiscalPerfil?['apellido'] ?? ''}'.trim();
      await Supabase.instance.client.from('usuarios').update({
        'categoria': _nuevaCat > 0 ? _nuevaCat : null,
        'categoria_observada': _catObs > 0 ? _catObs : null,
        'categorizado_por_nombre': fiscalNombre.isNotEmpty ? fiscalNombre : null,
        'categorizado_fecha': DateTime.now().toIso8601String(),
      }).eq('id', _jugadorSel!['id']);
      _toast('Categoria actualizada!');
      widget.onUpdate();
      _buscar();
      setState(() => _jugadorSel = null);
    } catch (e) {
      _toast('Error: $e', error: true);
    } finally {
      if (mounted) setState(() => _guardando = false);
    }
  }

  Future<void> _crearTorneo() async {
    if (_tornNombreCtrl.text.trim().isEmpty) { _toast('Ingresa el nombre del torneo', error: true); return; }
    if (_tornFechaCtrl.text.trim().isEmpty)  { _toast('Ingresa la fecha del torneo', error: true); return; }
    setState(() => _creandoTorneo = true);
    try {
      final uid = Supabase.instance.client.auth.currentUser?.id;
      await Supabase.instance.client.from('torneos').insert({
        'nombre': _tornNombreCtrl.text.trim(),
        'club': _tornClubCtrl.text.trim(),
        'fecha': _tornFechaCtrl.text.trim(),
        'formato': _tornFormato,
        'categorias': _tornCats.isNotEmpty ? _tornCats : null,
        'canchas': _tornCanchas,
        'creado_por': uid,
        'estado': 'pendiente',
      });
      _toast('Torneo creado!');
      _tornNombreCtrl.clear(); _tornClubCtrl.clear(); _tornFechaCtrl.clear();
      setState(() { _tornCats = []; _tornFormato = 'grupos'; _tornCanchas = 2; });
    } catch (e) {
      _toast('Error al crear torneo: $e', error: true);
    } finally {
      if (mounted) setState(() => _creandoTorneo = false);
    }
  }

  Future<void> _pickFecha() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
      builder: (ctx, child) => Theme(
        data: ThemeData.dark().copyWith(colorScheme: const ColorScheme.dark(primary: AppColors.blue, surface: AppColors.navy2)),
        child: child!,
      ),
    );
    if (picked != null) {
      _tornFechaCtrl.text = '${picked.year}-${picked.month.toString().padLeft(2,'0')}-${picked.day.toString().padLeft(2,'0')}';
    }
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
    _tabCtrl.dispose(); _buscarCtrl.dispose(); _notaCtrl.dispose();
    _tornNombreCtrl.dispose(); _tornClubCtrl.dispose(); _tornFechaCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fiscalNombre = _fiscalPerfil?['nombre'] as String? ?? 'Fiscal';
    final fiscalAp     = _fiscalPerfil?['apellido'] as String? ?? '';
    final fiscalFoto   = _fiscalPerfil?['foto_url'] as String?;
    final fiscalInitials = fiscalNombre.isNotEmpty ? '${fiscalNombre[0]}${fiscalAp.isNotEmpty ? fiscalAp[0] : ''}'.toUpperCase() : 'F';

    return Scaffold(
      body: Stack(children: [
        Container(decoration: const BoxDecoration(gradient: LinearGradient(
          begin: Alignment.topCenter, end: Alignment.bottomCenter,
          colors: [AppColors.navy, AppColors.navy2],
        ))),
        CustomPaint(painter: DiagonalBgPainter(), child: Container()),
        SafeArea(child: Column(children: [
          // Header fiscal
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Row(children: [
              ProfileAvatar(fotoUrl: fiscalFoto, initials: fiscalInitials, categoria: 0, radius: 22),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('PANEL FISCAL', style: GoogleFonts.bebasNeue(fontSize: 24, letterSpacing: 2, color: Colors.white)),
                Text('$fiscalNombre $fiscalAp'.trim(),
                  style: GoogleFonts.barlowCondensed(fontSize: 13, color: AppColors.yellow, letterSpacing: 1)),
              ])),
              TextButton.icon(
                onPressed: () async {
                  // Sign back in as jugador if there's a saved session
                  if (context.mounted) {
                    Navigator.pushAndRemoveUntil(context,
                      MaterialPageRoute(builder: (_) => const HomeScreen()), (route) => false);
                  }
                },
                icon: const Icon(Icons.logout, color: AppColors.white30, size: 16),
                label: Text('Salir', style: GoogleFonts.barlowCondensed(color: AppColors.white30, fontSize: 13)),
              ),
            ]),
          ),
          // Tabs
          TabBar(
            controller: _tabCtrl,
            indicatorColor: AppColors.yellow,
            labelColor: AppColors.yellow,
            unselectedLabelColor: AppColors.white30,
            labelStyle: GoogleFonts.barlowCondensed(fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 1),
            tabs: const [
              Tab(text: 'JUGADORES'),
              Tab(text: 'CREAR TORNEO'),
            ],
          ),
          Expanded(child: TabBarView(controller: _tabCtrl, children: [
            _tabJugadores(),
            _tabCrearTorneo(),
          ])),
        ])),
      ]),
    );
  }

  Widget _tabJugadores() {
    final hayFiltros = _filtroMano.isNotEmpty || _filtroLado.isNotEmpty || _filtroCat > 0;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Buscador en tiempo real
        TextField(
          controller: _buscarCtrl,
          style: const TextStyle(color: Colors.white),
          onChanged: (val) {
            setState(() {});
            _buscar();
          },
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

        // Filtros desplegables
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
              Text(
                hayFiltros ? 'Filtros activos' : 'Filtros',
                style: GoogleFonts.barlowCondensed(fontSize: 14, letterSpacing: 1,
                  color: hayFiltros ? AppColors.blueBright : AppColors.white30),
              ),
              if (hayFiltros) ...[
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(color: AppColors.blueBright, borderRadius: BorderRadius.circular(10)),
                  child: Text(
                    [if (_filtroMano.isNotEmpty) _filtroMano, if (_filtroLado.isNotEmpty) _filtroLado, if (_filtroCat > 0) '${_filtroCat}a'].join(' · '),
                    style: GoogleFonts.barlowCondensed(fontSize: 11, color: Colors.white),
                  ),
                ),
              ],
              const Spacer(),
              Icon(_showFiltros ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                color: AppColors.white30, size: 18),
            ]),
          ),
        ),

        // Panel de filtros
        if (_showFiltros) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.navy3,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.white10),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // Mano
              Text('Mano hábil', style: GoogleFonts.barlowCondensed(fontSize: 11, letterSpacing: 2, color: AppColors.white30)),
              const SizedBox(height: 6),
              Wrap(spacing: 8, children: [
                _filtroChip('Todas', _filtroMano.isEmpty, () => setState(() { _filtroMano = ''; _buscar(); })),
                _filtroChip('Derecha', _filtroMano == 'derecha', () => setState(() { _filtroMano = 'derecha'; _buscar(); })),
                _filtroChip('Zurda', _filtroMano == 'zurda', () => setState(() { _filtroMano = 'zurda'; _buscar(); })),
              ]),
              const SizedBox(height: 12),
              // Lado
              Text('Lado de cancha', style: GoogleFonts.barlowCondensed(fontSize: 11, letterSpacing: 2, color: AppColors.white30)),
              const SizedBox(height: 6),
              Wrap(spacing: 8, children: [
                _filtroChip('Todos', _filtroLado.isEmpty, () => setState(() { _filtroLado = ''; _buscar(); })),
                _filtroChip('Drive', _filtroLado == 'drive', () => setState(() { _filtroLado = 'drive'; _buscar(); })),
                _filtroChip('Revés', _filtroLado == 'reves', () => setState(() { _filtroLado = 'reves'; _buscar(); })),
                _filtroChip('Ambos', _filtroLado == 'ambos', () => setState(() { _filtroLado = 'ambos'; _buscar(); })),
              ]),
              const SizedBox(height: 12),
              // Categoria
              Text('Categoría', style: GoogleFonts.barlowCondensed(fontSize: 11, letterSpacing: 2, color: AppColors.white30)),
              const SizedBox(height: 6),
              Wrap(spacing: 8, runSpacing: 6, children: [
                _filtroChip('Todas', _filtroCat == 0, () => setState(() { _filtroCat = 0; _buscar(); })),
                ...List.generate(8, (i) {
                  final cat = i + 1;
                  return _filtroChip('${cat}a', _filtroCat == cat,
                    () => setState(() { _filtroCat = _filtroCat == cat ? 0 : cat; _buscar(); }),
                    color: AppColors.categoryColor(cat));
                }),
              ]),
              if (hayFiltros) ...[
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () => setState(() { _filtroMano = ''; _filtroLado = ''; _filtroCat = 0; _buscar(); }),
                  child: Row(children: [
                    const Icon(Icons.clear_all, color: AppColors.red, size: 16),
                    const SizedBox(width: 6),
                    Text('Limpiar filtros', style: GoogleFonts.barlowCondensed(fontSize: 13, color: AppColors.red, letterSpacing: 0.5)),
                  ]),
                ),
              ],
            ]),
          ),
        ],
        const SizedBox(height: 16),

        // Resultados
        if (_buscando)
          const Center(child: Padding(padding: EdgeInsets.all(24),
            child: CircularProgressIndicator(color: AppColors.blueBright, strokeWidth: 2)))
        else if (_resultados.isEmpty && _buscarCtrl.text.isNotEmpty)
          Center(child: Padding(padding: const EdgeInsets.all(24),
            child: Text('Sin resultados', style: GoogleFonts.barlowCondensed(fontSize: 15, color: AppColors.white30))))
        else if (_buscarCtrl.text.isEmpty && !_filtroMano.isNotEmpty && !_filtroLado.isNotEmpty && _filtroCat == 0)
          Center(child: Padding(padding: const EdgeInsets.all(24),
            child: Column(children: [
              const Icon(Icons.search, color: AppColors.white30, size: 40),
              const SizedBox(height: 8),
              Text('Escribí un nombre, apellido o DNI', style: GoogleFonts.barlowCondensed(fontSize: 14, color: AppColors.white30)),
              Text('o usá los filtros para buscar', style: GoogleFonts.barlow(fontSize: 12, color: AppColors.white30)),
            ])))
        else
          ..._resultados.map((j) => _jugadorTile(j)),

        // Panel jugador seleccionado
        if (_jugadorSel != null) ...[
          const SizedBox(height: 20),
          _panelJugadorSel(),
        ],
      ]),
    );
  }

  Widget _panelJugadorSel() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white05,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.yellow.withOpacity(0.3)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Header jugador
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(children: [
            ProfileAvatar(
              fotoUrl: _jugadorSel!['foto_url'] as String?,
              initials: () { final n = _jugadorSel!['nombre'] as String? ?? ''; final a = _jugadorSel!['apellido'] as String? ?? ''; return n.isNotEmpty ? '${n[0]}${a.isNotEmpty ? a[0] : ''}'.toUpperCase() : 'J'; }(),
              categoria: (_jugadorSel!['categoria'] as int?) ?? 0,
              categoriaObservada: _jugadorSel!['categoria_observada'] as int?,
              radius: 24,
            ),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('${_jugadorSel!['nombre'] ?? ''} ${_jugadorSel!['apellido'] ?? ''}',
                style: GoogleFonts.bebasNeue(fontSize: 20, color: Colors.white)),
              Text('DNI: ${_jugadorSel!['dni'] ?? ''} · ${_jugadorSel!['localidad'] ?? _jugadorSel!['distrito'] ?? ''}',
                style: GoogleFonts.barlow(fontSize: 12, color: AppColors.white30)),
            ])),
            IconButton(onPressed: () => setState(() { _jugadorSel = null; _notas = []; }),
              icon: const Icon(Icons.close, color: AppColors.white30, size: 20)),
          ]),
        ),

        const Divider(color: AppColors.white10, height: 1),

        // Tabs dentro del panel
        DefaultTabController(
          length: 2,
          child: Column(children: [
            TabBar(
              labelColor: AppColors.yellow,
              unselectedLabelColor: AppColors.white30,
              indicatorColor: AppColors.yellow,
              labelStyle: GoogleFonts.barlowCondensed(fontSize: 13, fontWeight: FontWeight.w600, letterSpacing: 1),
              tabs: const [Tab(text: 'CATEGORÍA'), Tab(text: 'NOTAS')],
            ),
            SizedBox(
              height: 380,
              child: TabBarView(children: [
                // Tab Categoria
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Categoría', style: GoogleFonts.barlowCondensed(fontSize: 11, letterSpacing: 2, color: AppColors.white30)),
                    const SizedBox(height: 8),
                    Wrap(spacing: 8, runSpacing: 8, children: List.generate(8, (i) {
                      final cat = i + 1;
                      final color = AppColors.categoryColor(cat);
                      final active = _nuevaCat == cat;
                      return GestureDetector(
                        onTap: () => setState(() => _nuevaCat = cat),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: active ? color.withOpacity(0.2) : AppColors.white05,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: active ? color : AppColors.white10, width: active ? 2 : 1),
                          ),
                          child: Text('${cat}a', style: GoogleFonts.barlowCondensed(fontSize: 14, fontWeight: FontWeight.w600, color: active ? color : AppColors.white30)),
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
                        final cat = i + 1;
                        final color = AppColors.categoryColor(cat);
                        final active = _catObs == cat;
                        return GestureDetector(
                          onTap: () => setState(() => _catObs = cat),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: active ? color.withOpacity(0.2) : AppColors.white05,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: active ? color : AppColors.white10, width: active ? 2 : 1),
                            ),
                            child: Text('${cat}a', style: GoogleFonts.barlowCondensed(fontSize: 14, fontWeight: FontWeight.w600, color: active ? color : AppColors.white30)),
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
                  ]),
                ),

                // Tab Notas
                _tabNotas(),
              ]),
            ),
          ]),
        ),
      ]),
    );
  }

  Widget _tabNotas() {
    return Column(children: [
      // Lista de notas existentes
      Expanded(
        child: _notas.isEmpty
            ? Center(child: Text('Sin notas aún', style: GoogleFonts.barlowCondensed(fontSize: 14, color: AppColors.white30)))
            : ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: _notas.length,
                itemBuilder: (_, i) {
                  final nota = _notas[i];
                  final fecha = nota['created_at'] != null
                      ? () { try { final d = DateTime.parse(nota['created_at']).toLocal(); return '${d.day.toString().padLeft(2,'0')}/${d.month.toString().padLeft(2,'0')}/${d.year}'; } catch(_) { return ''; } }()
                      : '';
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.navy3,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.white10),
                    ),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(children: [
                        const Icon(Icons.person_outline, color: AppColors.blueBright, size: 13),
                        const SizedBox(width: 4),
                        Text(nota['fiscal_nombre'] ?? 'Fiscal', style: GoogleFonts.barlowCondensed(fontSize: 12, color: AppColors.blueBright, letterSpacing: 0.5)),
                        const Spacer(),
                        Text(fecha, style: GoogleFonts.barlow(fontSize: 11, color: AppColors.white30)),
                      ]),
                      const SizedBox(height: 6),
                      Text(nota['nota'] ?? '', style: GoogleFonts.barlow(fontSize: 13, color: Colors.white)),
                    ]),
                  );
                },
              ),
      ),
      // Campo nueva nota
      Container(
        padding: const EdgeInsets.all(12),
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.white10)),
        ),
        child: Row(children: [
          Expanded(
            child: TextField(
              controller: _notaCtrl,
              onChanged: (_) => setState(() {}),
              style: const TextStyle(color: Colors.white, fontSize: 14),
              maxLines: 2,
              decoration: InputDecoration(
                hintText: 'Agregar observación sobre el jugador...',
                hintStyle: const TextStyle(color: AppColors.white30, fontSize: 13),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                filled: true,
                fillColor: AppColors.navy3,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.white10)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.white10)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.blueBright)),
              ),
            ),
          ),
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
    ]);
  }

  Widget _jugadorTile(Map<String, dynamic> j) {
    final nombre   = j['nombre'] as String? ?? '';
    final apellido = j['apellido'] as String? ?? '';
    final dni      = j['dni'] as String? ?? '';
    final cat      = (j['categoria'] as int?) ?? 0;
    final catObs   = j['categoria_observada'] as int?;
    final mano     = j['mano_habil'] as String? ?? '';
    final lado     = j['lado_cancha'] as String? ?? '';
    final residencia = j['residencia'] as String? ?? '';
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
          ProfileAvatar(fotoUrl: j['foto_url'] as String?, initials: initials, categoria: cat,
            categoriaObservada: catObs != null && catObs != cat ? catObs : null, radius: 22),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('$nombre $apellido', style: GoogleFonts.barlowCondensed(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white)),
            Text('DNI: $dni', style: GoogleFonts.barlow(fontSize: 12, color: AppColors.white30)),
            if (mano.isNotEmpty || lado.isNotEmpty || residencia.isNotEmpty)
              Text('${mano.isNotEmpty ? mano : ''}${lado.isNotEmpty ? ' · $lado' : ''}${residencia.isNotEmpty ? ' · $residencia' : ''}',
                style: GoogleFonts.barlow(fontSize: 11, color: AppColors.white30)),
          ])),
          const Icon(Icons.chevron_right, color: AppColors.white30, size: 18),
        ]),
      ),
    );
  }

  Widget _tabCrearTorneo() => SingleChildScrollView(
    padding: const EdgeInsets.all(20),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('NUEVO TORNEO', style: GoogleFonts.bebasNeue(fontSize: 28, letterSpacing: 2, color: Colors.white)),
      Text('Completa la informacion del torneo', style: GoogleFonts.barlowCondensed(fontSize: 12, letterSpacing: 2, color: AppColors.white30)),
      const SizedBox(height: 24),
      TextField(controller: _tornNombreCtrl, style: const TextStyle(color: Colors.white),
        decoration: const InputDecoration(labelText: 'Nombre del torneo', prefixIcon: Icon(Icons.emoji_events_outlined, color: AppColors.white30))),
      const SizedBox(height: 14),
      TextField(controller: _tornClubCtrl, style: const TextStyle(color: Colors.white),
        decoration: const InputDecoration(labelText: 'Club / Sede', prefixIcon: Icon(Icons.location_on_outlined, color: AppColors.white30))),
      const SizedBox(height: 14),
      GestureDetector(
        onTap: _pickFecha,
        child: AbsorbPointer(child: TextField(controller: _tornFechaCtrl, style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(labelText: 'Fecha', prefixIcon: Icon(Icons.calendar_today_outlined, color: AppColors.white30)))),
      ),
      const SizedBox(height: 20),
      Text('FORMATO', style: GoogleFonts.barlowCondensed(fontSize: 11, letterSpacing: 3, color: AppColors.blueBright)),
      const SizedBox(height: 10),
      Wrap(spacing: 8, children: [
        _tornChip('Grupos', _tornFormato == 'grupos', () => setState(() => _tornFormato = 'grupos')),
        _tornChip('Grupos + Eliminacion', _tornFormato == 'grupos_elim', () => setState(() => _tornFormato = 'grupos_elim')),
        _tornChip('Americano', _tornFormato == 'americano', () => setState(() => _tornFormato = 'americano')),
        _tornChip('Eliminacion directa', _tornFormato == 'eliminacion', () => setState(() => _tornFormato = 'eliminacion')),
      ]),
      const SizedBox(height: 20),
      Text('CATEGORIAS HABILITADAS', style: GoogleFonts.barlowCondensed(fontSize: 11, letterSpacing: 3, color: AppColors.blueBright)),
      const SizedBox(height: 4),
      Text('Deja vacio para todas las categorias', style: GoogleFonts.barlow(fontSize: 11, color: AppColors.white30)),
      const SizedBox(height: 10),
      Wrap(spacing: 8, runSpacing: 8, children: List.generate(8, (i) {
        final cat = i + 1;
        final color = AppColors.categoryColor(cat);
        final active = _tornCats.contains(cat);
        return GestureDetector(
          onTap: () => setState(() => active ? _tornCats.remove(cat) : _tornCats.add(cat)),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: active ? color.withOpacity(0.2) : AppColors.white05,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: active ? color : AppColors.white10, width: active ? 2 : 1),
            ),
            child: Text('${cat}a', style: GoogleFonts.barlowCondensed(fontSize: 14, fontWeight: FontWeight.w600, color: active ? color : AppColors.white30)),
          ),
        );
      })),
      const SizedBox(height: 20),
      Text('CANCHAS DISPONIBLES', style: GoogleFonts.barlowCondensed(fontSize: 11, letterSpacing: 3, color: AppColors.blueBright)),
      const SizedBox(height: 10),
      Row(children: [
        IconButton(onPressed: () => setState(() { if (_tornCanchas > 1) _tornCanchas--; }),
          icon: const Icon(Icons.remove_circle_outline, color: AppColors.white30)),
        Container(
          width: 60, height: 48,
          decoration: BoxDecoration(color: AppColors.white05, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.white10)),
          child: Center(child: Text('$_tornCanchas', style: GoogleFonts.bebasNeue(fontSize: 24, color: Colors.white))),
        ),
        IconButton(onPressed: () => setState(() { if (_tornCanchas < 20) _tornCanchas++; }),
          icon: const Icon(Icons.add_circle_outline, color: AppColors.blueBright)),
        const SizedBox(width: 8),
        Text('canchas', style: GoogleFonts.barlowCondensed(fontSize: 14, color: AppColors.white30)),
      ]),
      const SizedBox(height: 28),
      ElevatedButton(
        onPressed: _creandoTorneo ? null : _crearTorneo,
        child: _creandoTorneo
            ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
            : Text('CREAR TORNEO', style: GoogleFonts.barlowCondensed(fontSize: 18, fontWeight: FontWeight.w700, letterSpacing: 2)),
      ),
      const SizedBox(height: 20),
    ]),
  );

  Widget _filtroChip(String label, bool active, VoidCallback onTap, {Color? color}) {
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

  Widget _tornChip(String label, bool active, VoidCallback onTap) => GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: active ? AppColors.blue.withOpacity(0.2) : AppColors.white05,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: active ? AppColors.blueBright : AppColors.white10, width: active ? 2 : 1),
      ),
      child: Text(label, style: GoogleFonts.barlowCondensed(fontSize: 14, fontWeight: FontWeight.w600, color: active ? Colors.white : AppColors.white30)),
    ),
  );
}
