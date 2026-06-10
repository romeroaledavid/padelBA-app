import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../theme/app_colors.dart';

// ===================== CLUBES SELECTOR =====================
class ClubesSelector extends StatefulWidget {
  final List<String> selectedClubes;
  final ValueChanged<List<String>> onChanged;
  const ClubesSelector({required this.selectedClubes, required this.onChanged});
  @override
  State<ClubesSelector> createState() => ClubesSelectorState();
}

class ClubesSelectorState extends State<ClubesSelector> {
  List<Map<String, dynamic>> _clubes = [];
  bool _loading = true;
  bool _showDropdown = false;
  final _searchCtrl = TextEditingController();
  List<Map<String, dynamic>> _filtered = [];

  @override
  void initState() { super.initState(); _loadClubes(); }

  @override
  void dispose() { _searchCtrl.dispose(); super.dispose(); }

  Future<void> _loadClubes() async {
    try {
      final res = await Supabase.instance.client.from('clubes').select().eq('activo', true).order('nombre');
      if (mounted) setState(() {
        _clubes = List<Map<String, dynamic>>.from(res);
        _filtered = _clubes;
        _loading = false;
      });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _onSearch(String val) {
    setState(() {
      _filtered = val.isEmpty
          ? _clubes
          : _clubes.where((c) => (c['nombre'] as String).toLowerCase().contains(val.toLowerCase()) ||
              ((c['localidad'] as String? ?? '').toLowerCase().contains(val.toLowerCase()))).toList();
    });
  }

  void _select(Map<String, dynamic> club) {
    final id = club['id'] as String;
    final list = List<String>.from(widget.selectedClubes);
    if (!list.contains(id)) list.add(id);
    widget.onChanged(list);
    setState(() { _showDropdown = false; _searchCtrl.clear(); _filtered = _clubes; });
  }

  void _remove(String id) {
    final list = List<String>.from(widget.selectedClubes);
    list.remove(id);
    widget.onChanged(list);
  }

  String _nombreById(String id) {
    final c = _clubes.firstWhere((c) => c['id'] == id, orElse: () => {});
    if (c.isEmpty) return id;
    final loc = c['localidad'] as String? ?? '';
    return loc.isNotEmpty ? '${c['nombre']} · $loc' : c['nombre'] as String;
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Clubes donde juego', style: GoogleFonts.barlowCondensed(fontSize: 12, letterSpacing: 1, color: AppColors.white30)),
      const SizedBox(height: 8),
      // Selected clubs as chips
      if (widget.selectedClubes.isNotEmpty)
        Wrap(spacing: 8, runSpacing: 8, children: widget.selectedClubes.map((id) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.blue.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.blueBright, width: 1.5),
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.sports_tennis, color: AppColors.blueBright, size: 13),
            const SizedBox(width: 6),
            Text(_nombreById(id), style: GoogleFonts.barlowCondensed(fontSize: 13, color: Colors.white)),
            const SizedBox(width: 6),
            GestureDetector(onTap: () => _remove(id),
              child: const Icon(Icons.close, color: AppColors.white30, size: 14)),
          ]),
        )).toList()),
      const SizedBox(height: 8),
      // Add club button
      GestureDetector(
        onTap: () => setState(() => _showDropdown = !_showDropdown),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          decoration: BoxDecoration(
            color: AppColors.white05,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _showDropdown ? AppColors.blueBright : AppColors.white10),
          ),
          child: Row(children: [
            const Icon(Icons.add_circle_outline, color: AppColors.white30, size: 18),
            const SizedBox(width: 10),
            Text('Agregar club', style: GoogleFonts.barlow(fontSize: 15, color: AppColors.white30)),
            const Spacer(),
            Icon(_showDropdown ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: AppColors.white30, size: 18),
          ]),
        ),
      ),
      if (_showDropdown) ...[
        const SizedBox(height: 4),
        Container(
          decoration: BoxDecoration(
            color: AppColors.navy3,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.white10),
          ),
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: TextField(
                controller: _searchCtrl,
                onChanged: _onSearch,
                autofocus: true,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Buscar club...',
                  hintStyle: const TextStyle(color: AppColors.white30, fontSize: 14),
                  prefixIcon: const Icon(Icons.search, color: AppColors.white30, size: 18),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  filled: true, fillColor: AppColors.white05,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                ),
              ),
            ),
            if (_loading)
              const Padding(padding: EdgeInsets.all(16), child: CircularProgressIndicator(color: AppColors.blueBright, strokeWidth: 2))
            else
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 200),
                child: ListView(shrinkWrap: true, children: _filtered.where((c) => !widget.selectedClubes.contains(c['id'])).map((c) {
                  final localidad = c['localidad'] as String? ?? '';
                  return InkWell(
                    onTap: () => _select(c),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(children: [
                        const Icon(Icons.sports_tennis_outlined, color: AppColors.white30, size: 16),
                        const SizedBox(width: 10),
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(c['nombre'] as String, style: GoogleFonts.barlowCondensed(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
                          if (localidad.isNotEmpty)
                            Text(localidad, style: GoogleFonts.barlow(fontSize: 12, color: AppColors.white30)),
                        ])),
                        const Icon(Icons.add, color: AppColors.blueBright, size: 16),
                      ]),
                    ),
                  );
                }).toList()),
              ),
          ]),
        ),
      ],
    ]);
  }
}


// ===================== TORNEOS SCREEN =====================