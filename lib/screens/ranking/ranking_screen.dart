import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../theme/app_colors.dart';
import '../../painters/diagonal_bg_painter.dart';
import '../../widgets/profile_avatar.dart';
import '../../constants/distritos.dart';

class RankingScreen extends StatefulWidget {
  const RankingScreen({super.key});
  @override
  State<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  // Filters
  String? _filtroDistrito;
  String? _filtroLocalidad;
  String? _filtroClubId;
  int _filtroCat = 0;
  bool _showFiltros = true;
  List<Map<String, dynamic>> _clubes = [];
  List<Map<String, dynamic>> _jugadores = [];
  bool _buscando = false;
  final _distCtrl = TextEditingController();
  final _locCtrl  = TextEditingController();
  List<String> _distSug = [];
  List<String> _locSug  = [];
  bool _showDistSug = false;
  bool _showLocSug  = false;

  @override
  void initState() { super.initState(); _loadClubes(); }

  @override
  void dispose() { _distCtrl.dispose(); _locCtrl.dispose(); super.dispose(); }

  Future<void> _loadClubes() async {
    try {
      final res = await Supabase.instance.client.from('clubes').select().eq('activo', true).order('nombre');
      if (mounted) setState(() => _clubes = List<Map<String, dynamic>>.from(res));
    } catch (_) {}
  }

  Future<void> _buscar() async {
    setState(() => _buscando = true);
    try {
      var query = Supabase.instance.client.from('usuarios').select();
      if (_filtroDistrito != null && _filtroDistrito!.isNotEmpty)
        query = query.eq('distrito', _filtroDistrito!) as dynamic;
      if (_filtroLocalidad != null && _filtroLocalidad!.isNotEmpty)
        query = query.eq('localidad', _filtroLocalidad!) as dynamic;
      if (_filtroClubId != null)
        query = query.contains('clubes_ids', [_filtroClubId!]) as dynamic;
      if (_filtroCat > 0)
        query = query.eq('categoria', _filtroCat) as dynamic;
      else
        query = query.not('categoria', 'is', null) as dynamic;
      final res = await query.order('categoria').limit(100);
      if (mounted) setState(() { _jugadores = List<Map<String, dynamic>>.from(res); _buscando = false; });
    } catch (e) { if (mounted) setState(() => _buscando = false); }
  }

  void _onDistChanged(String val) {
    final q = val.toLowerCase();
    final matches = kDistritosBA.keys.where((d) => d.toLowerCase().contains(q)).take(6).toList();
    setState(() { _distSug = matches; _showDistSug = matches.isNotEmpty && val.isNotEmpty; });
    if (val.isEmpty) { _filtroDistrito = null; _filtroLocalidad = null; _locCtrl.clear(); }
  }

  void _selectDist(String d) {
    _distCtrl.text = d; _locCtrl.clear();
    setState(() { _filtroDistrito = d; _filtroLocalidad = null; _showDistSug = false; _distSug = []; });
  }

  void _onLocChanged(String val) {
    if (_filtroDistrito == null) return;
    final locs = kDistritosBA[_filtroDistrito!] ?? [];
    final q = val.toLowerCase();
    final matches = locs.where((l) => l.toLowerCase().contains(q)).take(6).toList();
    setState(() { _locSug = matches; _showLocSug = matches.isNotEmpty && val.isNotEmpty; });
  }

  void _selectLoc(String l) {
    _locCtrl.text = l;
    setState(() { _filtroLocalidad = l; _showLocSug = false; _locSug = []; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy,
      body: Stack(children: [
        CustomPaint(painter: DiagonalBgPainter(), child: Container()),
        SafeArea(child: Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                IconButton(onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_ios, color: AppColors.white30, size: 20)),
                Text('RANKING', style: GoogleFonts.bebasNeue(fontSize: 28, letterSpacing: 2, color: Colors.white)),
              ]),
              Text('Buscá los mejores jugadores por zona', style: GoogleFonts.barlowCondensed(fontSize: 12, letterSpacing: 1, color: AppColors.white30)),
              const SizedBox(height: 12),
              // Filtros
              GestureDetector(
                onTap: () => setState(() => _showFiltros = !_showFiltros),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.white05, borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.white10),
                  ),
                  child: Row(children: [
                    const Icon(Icons.tune, color: AppColors.blueBright, size: 16),
                    const SizedBox(width: 8),
                    Text('Filtros de búsqueda', style: GoogleFonts.barlowCondensed(fontSize: 13, color: AppColors.blueBright, letterSpacing: 1)),
                    const Spacer(),
                    Icon(_showFiltros ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: AppColors.white30, size: 16),
                  ]),
                ),
              ),
              if (_showFiltros) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(color: AppColors.navy3, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.white10)),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    // Distrito
                    Text('Distrito / Partido', style: GoogleFonts.barlowCondensed(fontSize: 10, letterSpacing: 2, color: AppColors.white30)),
                    const SizedBox(height: 4),
                    TextField(
                      controller: _distCtrl,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      onChanged: _onDistChanged,
                      decoration: InputDecoration(
                        hintText: 'Ej: La Costa, Bahía Blanca...',
                        hintStyle: const TextStyle(color: AppColors.white30, fontSize: 13),
                        prefixIcon: const Icon(Icons.map_outlined, color: AppColors.white30, size: 18),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        suffixIcon: _distCtrl.text.isNotEmpty ? IconButton(icon: const Icon(Icons.clear, color: AppColors.white30, size: 16),
                          onPressed: () { _distCtrl.clear(); _locCtrl.clear(); setState(() { _filtroDistrito = null; _filtroLocalidad = null; _showDistSug = false; }); }) : null,
                      ),
                    ),
                    if (_showDistSug) _suggestionBox(_distSug, _selectDist, Icons.location_city_outlined),
                    const SizedBox(height: 8),
                    // Localidad
                    Text('Localidad', style: GoogleFonts.barlowCondensed(fontSize: 10, letterSpacing: 2, color: AppColors.white30)),
                    const SizedBox(height: 4),
                    TextField(
                      controller: _locCtrl,
                      enabled: _filtroDistrito != null,
                      style: TextStyle(color: _filtroDistrito != null ? Colors.white : AppColors.white30, fontSize: 14),
                      onChanged: _onLocChanged,
                      decoration: InputDecoration(
                        hintText: _filtroDistrito != null ? 'Ej: Cabildo, Las Toninas...' : 'Primero elegí el distrito',
                        hintStyle: const TextStyle(color: AppColors.white30, fontSize: 13),
                        prefixIcon: const Icon(Icons.location_on_outlined, color: AppColors.white30, size: 18),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        suffixIcon: _locCtrl.text.isNotEmpty ? IconButton(icon: const Icon(Icons.clear, color: AppColors.white30, size: 16),
                          onPressed: () { _locCtrl.clear(); setState(() { _filtroLocalidad = null; _showLocSug = false; }); }) : null,
                      ),
                    ),
                    if (_showLocSug) _suggestionBox(_locSug, _selectLoc, Icons.place_outlined),
                    const SizedBox(height: 8),
                    // Club
                    Text('Club', style: GoogleFonts.barlowCondensed(fontSize: 10, letterSpacing: 2, color: AppColors.white30)),
                    const SizedBox(height: 4),
                    if (_clubes.isNotEmpty)
                      SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: [
                        _chip('Todos', _filtroClubId == null, () => setState(() => _filtroClubId = null)),
                        ..._clubes.map((c) => Padding(
                          padding: const EdgeInsets.only(left: 6),
                          child: _chip(c['nombre'] as String, _filtroClubId == c['id'],
                            () => setState(() => _filtroClubId = _filtroClubId == c['id'] ? null : c['id'] as String)),
                        )),
                      ])),
                    const SizedBox(height: 8),
                    // Categoria
                    Text('Categoría', style: GoogleFonts.barlowCondensed(fontSize: 10, letterSpacing: 2, color: AppColors.white30)),
                    const SizedBox(height: 4),
                    Wrap(spacing: 6, runSpacing: 4, children: [
                      _chip('Todas', _filtroCat == 0, () => setState(() => _filtroCat = 0)),
                      ...List.generate(8, (i) { final cat = i+1; return _chip('${cat}a', _filtroCat == cat,
                        () => setState(() => _filtroCat = cat == _filtroCat ? 0 : cat),
                        color: AppColors.categoryColor(cat)); }),
                    ]),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _buscando ? null : _buscar,
                      style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 44)),
                      child: _buscando
                          ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : Text('BUSCAR', style: GoogleFonts.barlowCondensed(fontSize: 16, fontWeight: FontWeight.w700, letterSpacing: 2)),
                    ),
                  ]),
                ),
              ],
            ]),
          ),
          const SizedBox(height: 8),
          Expanded(child: _jugadores.isEmpty
            ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Icon(Icons.leaderboard_outlined, color: AppColors.white30, size: 52),
                const SizedBox(height: 10),
                Text('Aplicá filtros y buscá', style: GoogleFonts.barlowCondensed(fontSize: 15, color: AppColors.white30)),
                Text('para ver el ranking por zona', style: GoogleFonts.barlow(fontSize: 12, color: AppColors.white30)),
              ]))
            : ListView.builder(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                itemCount: _jugadores.length,
                itemBuilder: (_, i) => _jugadorRow(_jugadores[i], i + 1),
              ),
          ),
        ])),
      ]),
    );
  }

  Widget _suggestionBox(List<String> items, ValueChanged<String> onTap, IconData icon) =>
    Container(
      margin: const EdgeInsets.only(top: 2),
      decoration: BoxDecoration(color: AppColors.navy2, borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.white10)),
      child: ConstrainedBox(constraints: const BoxConstraints(maxHeight: 160),
        child: ListView(shrinkWrap: true, children: items.map((s) => InkWell(
          onTap: () => onTap(s),
          child: Padding(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(children: [
              Icon(icon, color: AppColors.white30, size: 14),
              const SizedBox(width: 8),
              Text(s, style: GoogleFonts.barlow(fontSize: 13, color: Colors.white)),
            ])),
        )).toList()),
      ),
    );

  Widget _jugadorRow(Map<String, dynamic> j, int pos) {
    final nombre = j['nombre'] as String? ?? '';
    final apellido = j['apellido'] as String? ?? '';
    final cat = (j['categoria'] as int?) ?? 0;
    final catObs = j['categoria_observada'] as int?;
    final mano = j['mano_habil'] as String? ?? '';
    final lado = j['lado_cancha'] as String? ?? '';
    final localidad = j['localidad'] as String? ?? '';
    final initials = nombre.isNotEmpty ? '${nombre[0]}${apellido.isNotEmpty ? apellido[0] : ''}'.toUpperCase() : 'J';
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppColors.white05, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.white10)),
      child: Row(children: [
        SizedBox(width: 28, child: Text('#$pos', style: GoogleFonts.bebasNeue(fontSize: 16, color: AppColors.white30))),
        ProfileAvatar(fotoUrl: j['foto_url'] as String?, initials: initials, categoria: cat,
          categoriaObservada: catObs != null && catObs != cat ? catObs : null, radius: 20),
        const SizedBox(width: 10),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('$nombre $apellido', style: GoogleFonts.barlowCondensed(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white)),
          if (localidad.isNotEmpty) Text(localidad, style: GoogleFonts.barlow(fontSize: 11, color: AppColors.white30)),
          if (mano.isNotEmpty || lado.isNotEmpty)
            Text([if (mano.isNotEmpty) mano, if (lado.isNotEmpty) lado].join(' · '), style: GoogleFonts.barlow(fontSize: 11, color: AppColors.white30)),
        ])),
        if (cat > 0) Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(color: AppColors.categoryColor(cat).withOpacity(0.15), borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.categoryColor(cat))),
          child: Text('${cat}a', style: GoogleFonts.bebasNeue(fontSize: 14, color: AppColors.categoryColor(cat))),
        ),
      ]),
    );
  }

  Widget _chip(String label, bool active, VoidCallback onTap, {Color? color}) {
    final c = color ?? AppColors.blueBright;
    return GestureDetector(onTap: onTap, child: AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: active ? c.withOpacity(0.2) : AppColors.white05, borderRadius: BorderRadius.circular(14), border: Border.all(color: active ? c : AppColors.white10, width: active ? 1.5 : 1)),
      child: Text(label, style: GoogleFonts.barlowCondensed(fontSize: 12, fontWeight: FontWeight.w600, color: active ? c : AppColors.white30)),
    ));
  }
}

// ===================== FISCAL LOGIN =====================
// Authorized DNIs that can access fiscal panel
const List<String> _fiscalDnis = ['30366869'];
