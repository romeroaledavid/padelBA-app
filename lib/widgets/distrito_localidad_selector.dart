import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../constants/distritos.dart';

// ===================== DISTRITO / LOCALIDAD SELECTOR =====================
class DistritoLocalidadSelector extends StatefulWidget {
  final String? distrito;
  final String? localidad;
  final ValueChanged<String?> onDistritoChanged;
  final ValueChanged<String?> onLocalidadChanged;
  const DistritoLocalidadSelector({
    required this.distrito,
    required this.localidad,
    required this.onDistritoChanged,
    required this.onLocalidadChanged,
  });
  @override
  State<DistritoLocalidadSelector> createState() => _DistritoLocalidadSelectorState();
}

class _DistritoLocalidadSelectorState extends State<DistritoLocalidadSelector> {
  final _distCtrl = TextEditingController();
  final _locCtrl  = TextEditingController();
  List<String> _distSuggestions = [];
  List<String> _locSuggestions  = [];
  bool _showDist = false;
  bool _showLoc  = false;

  @override
  void initState() {
    super.initState();
    if (widget.distrito != null) _distCtrl.text = widget.distrito!;
    if (widget.localidad != null) _locCtrl.text = widget.localidad!;
  }

  @override
  void dispose() { _distCtrl.dispose(); _locCtrl.dispose(); super.dispose(); }

  void _onDistChanged(String val) {
    final q = val.toLowerCase();
    final matches = kDistritosBA.keys.where((d) => d.toLowerCase().contains(q)).take(8).toList();
    setState(() { _distSuggestions = matches; _showDist = matches.isNotEmpty && val.isNotEmpty; });
    if (val.isEmpty) { widget.onDistritoChanged(null); widget.onLocalidadChanged(null); _locCtrl.clear(); }
  }

  void _selectDist(String d) {
    _distCtrl.text = d;
    _locCtrl.clear();
    widget.onDistritoChanged(d);
    widget.onLocalidadChanged(null);
    setState(() { _showDist = false; _distSuggestions = []; });
  }

  void _onLocChanged(String val) {
    final dist = widget.distrito;
    if (dist == null) return;
    final locs = kDistritosBA[dist] ?? [];
    final q = val.toLowerCase();
    final matches = locs.where((l) => l.toLowerCase().contains(q)).take(8).toList();
    setState(() { _locSuggestions = matches; _showLoc = matches.isNotEmpty && val.isNotEmpty; });
  }

  void _selectLoc(String l) {
    _locCtrl.text = l;
    widget.onLocalidadChanged(l);
    setState(() { _showLoc = false; _locSuggestions = []; });
  }

  Widget _suggestionList(List<String> items, ValueChanged<String> onTap, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(top: 2),
      decoration: BoxDecoration(color: AppColors.navy3, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.white10)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 200),
        child: ListView(shrinkWrap: true, children: items.map((s) => InkWell(
          onTap: () => onTap(s),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
            child: Row(children: [
              Icon(icon, color: AppColors.white30, size: 15),
              const SizedBox(width: 10),
              Text(s, style: GoogleFonts.barlow(fontSize: 14, color: Colors.white)),
            ]),
          ),
        )).toList()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasDistrict = widget.distrito != null && widget.distrito!.isNotEmpty;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // Distrito
      TextField(
        controller: _distCtrl,
        style: const TextStyle(color: Colors.white),
        onChanged: _onDistChanged,
        decoration: InputDecoration(
          labelText: 'Distrito / Partido',
          prefixIcon: const Icon(Icons.map_outlined, color: AppColors.white30),
          suffixIcon: _distCtrl.text.isNotEmpty
              ? IconButton(icon: const Icon(Icons.clear, color: AppColors.white30, size: 18),
                  onPressed: () { _distCtrl.clear(); _locCtrl.clear(); widget.onDistritoChanged(null); widget.onLocalidadChanged(null); setState(() { _showDist = false; _showLoc = false; }); })
              : null,
        ),
      ),
      if (_showDist) _suggestionList(_distSuggestions, _selectDist, Icons.location_city_outlined),
      const SizedBox(height: 12),
      // Localidad
      TextField(
        controller: _locCtrl,
        style: TextStyle(color: hasDistrict ? Colors.white : AppColors.white30),
        enabled: hasDistrict,
        onChanged: _onLocChanged,
        decoration: InputDecoration(
          labelText: hasDistrict ? 'Localidad' : 'Primero elegí el distrito',
          prefixIcon: const Icon(Icons.location_on_outlined, color: AppColors.white30),
          suffixIcon: _locCtrl.text.isNotEmpty
              ? IconButton(icon: const Icon(Icons.clear, color: AppColors.white30, size: 18),
                  onPressed: () { _locCtrl.clear(); widget.onLocalidadChanged(null); setState(() => _showLoc = false); })
              : null,
        ),
      ),
      if (_showLoc) _suggestionList(_locSuggestions, _selectLoc, Icons.place_outlined),
    ]);
  }
}

