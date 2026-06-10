import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../theme/app_colors.dart';
import '../../painters/diagonal_bg_painter.dart';
import '../../widgets/profile_avatar.dart';

class JugadoresScreen extends StatefulWidget {
  const JugadoresScreen({super.key});
  @override
  State<JugadoresScreen> createState() => _JugadoresScreenState();
}

class _JugadoresScreenState extends State<JugadoresScreen> {
  final _buscarCtrl = TextEditingController();
  List<Map<String, dynamic>> _resultados = [];
  bool _buscando = false;
  bool _showFiltros = false;
  String _filtroMano = '';
  String _filtroLado = '';
  int _filtroCat = 0;

  @override
  void dispose() { _buscarCtrl.dispose(); super.dispose(); }

  Future<void> _buscar() async {
    final q = _buscarCtrl.text.trim();
    if (q.isEmpty && _filtroMano.isEmpty && _filtroLado.isEmpty && _filtroCat == 0) {
      setState(() => _resultados = []);
      return;
    }
    setState(() => _buscando = true);
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
      final res = await query.order('nombre').limit(30);
      if (mounted) setState(() { _resultados = List<Map<String, dynamic>>.from(res); _buscando = false; });
    } catch (_) { if (mounted) setState(() => _buscando = false); }
  }

  @override
  Widget build(BuildContext context) {
    final hayFiltros = _filtroMano.isNotEmpty || _filtroLado.isNotEmpty || _filtroCat > 0;
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
                Text('JUGADORES', style: GoogleFonts.bebasNeue(fontSize: 28, letterSpacing: 2, color: Colors.white)),
              ]),
              const SizedBox(height: 8),
              TextField(
                controller: _buscarCtrl,
                style: const TextStyle(color: Colors.white),
                onChanged: (_) { setState(() {}); _buscar(); },
                decoration: InputDecoration(
                  labelText: 'Buscar por nombre, apellido o DNI',
                  prefixIcon: const Icon(Icons.search, color: AppColors.white30),
                  suffixIcon: _buscarCtrl.text.isNotEmpty
                      ? IconButton(icon: const Icon(Icons.clear, color: AppColors.white30),
                          onPressed: () { _buscarCtrl.clear(); _buscar(); setState(() {}); })
                      : null,
                ),
              ),
              const SizedBox(height: 8),
              _filtrosWidget(hayFiltros),
            ]),
          ),
          const SizedBox(height: 8),
          Expanded(child: _buscando
            ? const Center(child: CircularProgressIndicator(color: AppColors.blueBright, strokeWidth: 2))
            : _resultados.isEmpty
              ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Icon(Icons.search, color: AppColors.white30, size: 48),
                  const SizedBox(height: 8),
                  Text('Buscá un jugador', style: GoogleFonts.barlowCondensed(fontSize: 15, color: AppColors.white30)),
                  Text('o usá los filtros', style: GoogleFonts.barlow(fontSize: 12, color: AppColors.white30)),
                ]))
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  itemCount: _resultados.length,
                  itemBuilder: (_, i) => _jugadorTile(_resultados[i]),
                ),
          ),
        ])),
      ]),
    );
  }

  Widget _filtrosWidget(bool hayFiltros) => Column(children: [
    GestureDetector(
      onTap: () => setState(() => _showFiltros = !_showFiltros),
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
          Text(hayFiltros ? 'Filtros activos' : 'Filtros',
            style: GoogleFonts.barlowCondensed(fontSize: 13, color: hayFiltros ? AppColors.blueBright : AppColors.white30, letterSpacing: 1)),
          const Spacer(),
          Icon(_showFiltros ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: AppColors.white30, size: 16),
        ]),
      ),
    ),
    if (_showFiltros) ...[
      const SizedBox(height: 6),
      Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: AppColors.navy3, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.white10)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Mano', style: GoogleFonts.barlowCondensed(fontSize: 10, letterSpacing: 2, color: AppColors.white30)),
          const SizedBox(height: 4),
          Wrap(spacing: 6, children: [
            _chip('Todas', _filtroMano.isEmpty, () => setState(() { _filtroMano = ''; _buscar(); })),
            _chip('Derecha', _filtroMano == 'derecha', () => setState(() { _filtroMano = 'derecha'; _buscar(); })),
            _chip('Zurda', _filtroMano == 'zurda', () => setState(() { _filtroMano = 'zurda'; _buscar(); })),
          ]),
          const SizedBox(height: 8),
          Text('Lado', style: GoogleFonts.barlowCondensed(fontSize: 10, letterSpacing: 2, color: AppColors.white30)),
          const SizedBox(height: 4),
          Wrap(spacing: 6, children: [
            _chip('Todos', _filtroLado.isEmpty, () => setState(() { _filtroLado = ''; _buscar(); })),
            _chip('Drive', _filtroLado == 'drive', () => setState(() { _filtroLado = 'drive'; _buscar(); })),
            _chip('Revés', _filtroLado == 'reves', () => setState(() { _filtroLado = 'reves'; _buscar(); })),
            _chip('Ambos', _filtroLado == 'ambos', () => setState(() { _filtroLado = 'ambos'; _buscar(); })),
          ]),
          const SizedBox(height: 8),
          Text('Categoría', style: GoogleFonts.barlowCondensed(fontSize: 10, letterSpacing: 2, color: AppColors.white30)),
          const SizedBox(height: 4),
          Wrap(spacing: 6, runSpacing: 4, children: [
            _chip('Todas', _filtroCat == 0, () => setState(() { _filtroCat = 0; _buscar(); })),
            ...List.generate(8, (i) { final cat = i+1; return _chip('${cat}a', _filtroCat == cat,
              () => setState(() { _filtroCat = cat == _filtroCat ? 0 : cat; _buscar(); }),
              color: AppColors.categoryColor(cat)); }),
          ]),
        ]),
      ),
    ],
  ]);

  Widget _jugadorTile(Map<String, dynamic> j) {
    final nombre = j['nombre'] as String? ?? '';
    final apellido = j['apellido'] as String? ?? '';
    final cat = (j['categoria'] as int?) ?? 0;
    final catObs = j['categoria_observada'] as int?;
    final mano = j['mano_habil'] as String? ?? '';
    final lado = j['lado_cancha'] as String? ?? '';
    final localidad = j['localidad'] as String? ?? '';
    final distrito = j['distrito'] as String? ?? '';
    final initials = nombre.isNotEmpty ? '${nombre[0]}${apellido.isNotEmpty ? apellido[0] : ''}'.toUpperCase() : 'J';
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppColors.white05, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.white10)),
      child: Row(children: [
        ProfileAvatar(fotoUrl: j['foto_url'] as String?, initials: initials, categoria: cat,
          categoriaObservada: catObs != null && catObs != cat ? catObs : null, radius: 22),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('$nombre $apellido', style: GoogleFonts.barlowCondensed(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white)),
          if (localidad.isNotEmpty || distrito.isNotEmpty)
            Text([if (localidad.isNotEmpty) localidad, if (distrito.isNotEmpty) distrito].join(', '),
              style: GoogleFonts.barlow(fontSize: 11, color: AppColors.white30)),
          if (mano.isNotEmpty || lado.isNotEmpty)
            Text([if (mano.isNotEmpty) mano, if (lado.isNotEmpty) lado].join(' · '),
              style: GoogleFonts.barlow(fontSize: 11, color: AppColors.white30)),
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

// ===================== RANKING SCREEN =====================
