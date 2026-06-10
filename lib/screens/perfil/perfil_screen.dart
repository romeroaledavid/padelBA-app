import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../theme/app_colors.dart';
import '../../widgets/profile_avatar.dart';
import '../../widgets/distrito_localidad_selector.dart';
import '../../widgets/clubes_selector.dart';
import '../../constants/distritos.dart';
import '../home/home_screen.dart';

// ===================== PERFIL =====================
class PerfilScreen extends StatefulWidget {
  final Map<String, dynamic>? perfil;
  final VoidCallback onSaved;
  const PerfilScreen({super.key, required this.perfil, required this.onSaved});
  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  final _nombreCtrl    = TextEditingController();
  final _apellidoCtrl  = TextEditingController();
  final _emailCtrl     = TextEditingController();
  String _distrito       = '';
  String _localidad      = '';
  String _ladoCancha     = '';
  String _manoHabil      = '';
  List<String> _selectedClubes = [];
  String? _fotoUrl;
  bool _loading          = false;
  bool _uploading        = false;

  @override
  void initState() { super.initState(); _loadData(); }

  void _loadData() {
    final p = widget.perfil;
    if (p == null) return;
    _nombreCtrl.text     = p['nombre'] ?? '';
    _apellidoCtrl.text   = p['apellido'] ?? '';
    _emailCtrl.text = p['email'] ?? '';
    _distrito       = p['distrito'] ?? '';
    _localidad      = p['localidad'] ?? '';
    _ladoCancha     = p['lado_cancha'] ?? '';
    _manoHabil      = p['mano_habil'] ?? '';
    final rawClubes = p['clubes_ids'];
    if (rawClubes != null) {
      _selectedClubes = List<String>.from(rawClubes);
    }
  }

  @override
  void didUpdateWidget(PerfilScreen old) { super.didUpdateWidget(old); if (widget.perfil != old.perfil) _loadData(); }

  @override
  void dispose() { _nombreCtrl.dispose(); _apellidoCtrl.dispose(); _emailCtrl.dispose(); super.dispose(); }

  String _formatFecha(String isoDate) {
    try {
      final d = DateTime.parse(isoDate).toLocal();
      return '${d.day.toString().padLeft(2,'0')}/${d.month.toString().padLeft(2,'0')}/${d.year}';
    } catch (_) { return isoDate; }
  }

  int _calcEdad(String? fecha) {
    if (fecha == null || fecha.isEmpty) return 0;
    try {
      final nac = DateTime.parse(fecha);
      final hoy = DateTime.now();
      int edad = hoy.year - nac.year;
      if (hoy.month < nac.month || (hoy.month == nac.month && hoy.day < nac.day)) edad--;
      return edad;
    } catch (_) { return 0; }
  }

  Future<void> _pickFoto() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
      maxWidth: 800,
      maxHeight: 800,
    );
    if (picked == null) return;
    final uid = Supabase.instance.client.auth.currentUser?.id;
    if (uid == null) return;
    setState(() => _uploading = true);
    try {
      final file = File(picked.path);
      final ext = picked.path.split('.').last;
      final finalPath = 'avatars/$uid.$ext';
      await Supabase.instance.client.storage.from('avatars').upload(
        finalPath, file, fileOptions: const FileOptions(upsert: true));
      final url = Supabase.instance.client.storage.from('avatars').getPublicUrl(finalPath);
      await Supabase.instance.client.from('usuarios').update({'foto_url': url}).eq('id', uid);
      setState(() => _fotoUrl = '$url?t=${DateTime.now().millisecondsSinceEpoch}');
      widget.onSaved();
      _toast('Foto actualizada!');
    } catch (e) {
      _toast('Error al subir foto: $e', error: true);
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  Future<void> _guardar() async {
    final uid = Supabase.instance.client.auth.currentUser?.id;
    if (uid == null) return;
    setState(() => _loading = true);
    try {
      final nombreTrim = _nombreCtrl.text.trim();
      final apellidoTrim = _apellidoCtrl.text.trim();
      if (nombreTrim.isEmpty) {
        _toast('Ingresa tu nombre', error: true);
        setState(() => _loading = false);
        return;
      }
      await Supabase.instance.client.from('usuarios').update({
        'nombre': nombreTrim,
        'apellido': apellidoTrim,
        'email': _emailCtrl.text.trim(),
        'distrito': _distrito.isNotEmpty ? _distrito : null,
        'localidad': _localidad.isNotEmpty ? _localidad : null,
        'lado_cancha': _ladoCancha.isNotEmpty ? _ladoCancha : null,
        'mano_habil': _manoHabil.isNotEmpty ? _manoHabil : null,
        'clubes_ids': _selectedClubes.isNotEmpty ? _selectedClubes : null,
      }).eq('id', uid);
      // Navigate back to home after saving
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Perfil guardado!', style: GoogleFonts.barlowCondensed(fontSize: 15)),
          backgroundColor: AppColors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          duration: const Duration(seconds: 2),
        ));
      }
      widget.onSaved();
      if (mounted) {
        _toast('Perfil guardado!');
      }
    } catch (e) {
      _toast('Error al guardar: $e', error: true);
    } finally {
      if (mounted) setState(() => _loading = false);
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
  Widget build(BuildContext context) {
    final p = widget.perfil;
    final nombre   = p?['nombre'] as String? ?? '';
    final apellido = p?['apellido'] as String? ?? '';
    final dni      = p?['dni'] as String? ?? '';
    final fecha    = p?['fecha_nacimiento'] as String? ?? '';
    final edad     = _calcEdad(fecha);
    final categoria= (p?['categoria'] as int?) ?? 0;
    final catObs   = p?['categoria_observada'] as int?;
    final initials = nombre.isNotEmpty ? '${nombre[0]}${apellido.isNotEmpty ? apellido[0] : ''}'.toUpperCase() : 'J';

    return SafeArea(child: SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(height: 8),
        Text('MI PERFIL', style: GoogleFonts.bebasNeue(fontSize: 32, letterSpacing: 2, color: Colors.white)),
        Text('Tu informacion personal', style: GoogleFonts.barlowCondensed(fontSize: 12, letterSpacing: 3, color: AppColors.white30)),
        const SizedBox(height: 28),

        // Avatar con foto
        Center(child: Column(children: [
          Stack(children: [
            ProfileAvatar(fotoUrl: _fotoUrl ?? p?['foto_url'] as String?, initials: initials, categoria: categoria,
              categoriaObservada: catObs != null && catObs != categoria ? catObs : null, radius: 50),
            Positioned(bottom: 0, right: 0,
              child: GestureDetector(
                onTap: _pickFoto,
                child: Container(
                  width: 30, height: 30,
                  decoration: BoxDecoration(
                    color: AppColors.blue,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.navy, width: 2),
                  ),
                  child: const Icon(Icons.camera_alt, color: Colors.white, size: 15),
                ),
              ),
            ),
          ]),
          const SizedBox(height: 12),
          Text(
            _nombreCtrl.text.isNotEmpty ? '${_nombreCtrl.text} ${_apellidoCtrl.text}'.trim() : 'Tu nombre',
            style: GoogleFonts.bebasNeue(fontSize: 24, letterSpacing: 1, color: Colors.white)),
          if (edad > 0)
            Text('$edad años', style: GoogleFonts.barlowCondensed(fontSize: 14, color: AppColors.blueBright, letterSpacing: 1)),
        ])),
        const SizedBox(height: 28),

        // DNI y fecha NO editables
        _sectionTitle('DATOS FIJOS'),
        const SizedBox(height: 4),
        Text('DNI y fecha de nacimiento no pueden modificarse', style: GoogleFonts.barlow(fontSize: 11, color: AppColors.white30)),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(child: _infoTile(Icons.badge_outlined, 'DNI', dni)),
          const SizedBox(width: 10),
          Expanded(child: _infoTile(Icons.cake_outlined, 'Fecha nac.', fecha.isNotEmpty ? fecha : '—')),
        ]),
        const SizedBox(height: 20),
        // Show distrito/localidad
        if (p?['distrito'] != null || p?['localidad'] != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _infoTile(Icons.location_on_outlined, 'Ubicación',
              [p?['localidad'], p?['distrito']].where((e) => e != null && e.toString().isNotEmpty).join(', ')),
          ),
        // Nombre y apellido SÍ editables
        _sectionTitle('DATOS PERSONALES'),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(child: TextField(controller: _nombreCtrl, style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(labelText: 'Nombre'))),
          const SizedBox(width: 10),
          Expanded(child: TextField(controller: _apellidoCtrl, style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(labelText: 'Apellido'))),
        ]),
        const SizedBox(height: 28),

        // Categoria (solo lectura, la asigna el Fiscal)
        _sectionTitle('CATEGORIA'),
        const SizedBox(height: 4),
        Text('Asignada por el Fiscal', style: GoogleFonts.barlow(fontSize: 11, color: AppColors.white30)),
        const SizedBox(height: 12),
        if (categoria > 0)
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              width: 48, height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.categoryColor(categoria).withOpacity(0.15),
                border: Border.all(color: AppColors.categoryColor(categoria), width: 2),
              ),
              child: Center(child: Text('${categoria}a',
                style: GoogleFonts.bebasNeue(fontSize: 16, color: AppColors.categoryColor(categoria)))),
            ),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Categoría ${categoria}a', style: GoogleFonts.barlowCondensed(fontSize: 16, color: Colors.white, letterSpacing: 0.5)),
              const SizedBox(height: 2),
              Row(children: [
                const Icon(Icons.verified_user_outlined, color: AppColors.white30, size: 13),
                const SizedBox(width: 4),
                Text('Asignada por: ', style: GoogleFonts.barlowCondensed(fontSize: 12, color: AppColors.white30, letterSpacing: 0.5)),
                Flexible(child: RichText(
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    style: GoogleFonts.barlowCondensed(fontSize: 12, color: AppColors.blueBright, fontWeight: FontWeight.w600),
                    children: [
                      TextSpan(text: p?['categorizado_por_nombre'] != null && p!['categorizado_por_nombre'].toString().isNotEmpty
                          ? p['categorizado_por_nombre'].toString() : 'Fiscal'),
                      if (p?['categorizado_fecha'] != null)
                        TextSpan(
                          text: ' (${_formatFecha(p!['categorizado_fecha'].toString())})',
                          style: GoogleFonts.barlow(fontSize: 11, color: AppColors.white30, fontWeight: FontWeight.normal),
                        ),
                    ],
                  ),
                )),
              ]),
              if (catObs != null && catObs != categoria)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Row(children: [
                    const Icon(Icons.trending_up, color: AppColors.yellow, size: 14),
                    const SizedBox(width: 4),
                    Text('En observación para ${catObs}a',
                      style: GoogleFonts.barlowCondensed(fontSize: 13, color: AppColors.yellow, letterSpacing: 0.5)),
                  ]),
                ),
            ])),
          ])
        else
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.white05,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.white10),
            ),
            child: Row(children: [
              const Icon(Icons.hourglass_empty_outlined, color: AppColors.white30, size: 18),
              const SizedBox(width: 10),
              Text('Categoría aún no asignada', style: GoogleFonts.barlowCondensed(fontSize: 14, color: AppColors.white30, letterSpacing: 0.5)),
            ]),
          ),
        const SizedBox(height: 28),

        // Datos editables
        _sectionTitle('DATOS DE JUEGO'),
        const SizedBox(height: 12),
        TextField(controller: _emailCtrl, keyboardType: TextInputType.emailAddress,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(labelText: 'Email')),
        const SizedBox(height: 14),
        DistritoLocalidadSelector(
          distrito: _distrito.isNotEmpty ? _distrito : null,
          localidad: _localidad.isNotEmpty ? _localidad : null,
          onDistritoChanged: (v) => setState(() { _distrito = v ?? ''; _localidad = ''; }),
          onLocalidadChanged: (v) => setState(() => _localidad = v ?? ''),
        ),
        const SizedBox(height: 16),
        _chipLabel('Lado de cancha'),
        const SizedBox(height: 8),
        Wrap(spacing: 8, children: [
          _chip('Drive', _ladoCancha == 'drive', () => setState(() => _ladoCancha = 'drive')),
          _chip('Reves', _ladoCancha == 'reves', () => setState(() => _ladoCancha = 'reves')),
          _chip('Ambos', _ladoCancha == 'ambos', () => setState(() => _ladoCancha = 'ambos')),
        ]),
        const SizedBox(height: 16),
        _chipLabel('Mano habil'),
        const SizedBox(height: 8),
        Wrap(spacing: 8, children: [
          _chip('Derecha', _manoHabil == 'derecha', () => setState(() => _manoHabil = 'derecha')),
          _chip('Zurda', _manoHabil == 'zurda', () => setState(() => _manoHabil = 'zurda')),
        ]),
        const SizedBox(height: 16),
        ClubesSelector(
          selectedClubes: _selectedClubes,
          onChanged: (list) => setState(() => _selectedClubes = list),
        ),
        const SizedBox(height: 28),

        // Estadisticas
        _sectionTitle('ESTADISTICAS'),
        const SizedBox(height: 12),
        Row(children: [
          _statCard('0', 'Torneos'),
          const SizedBox(width: 10),
          _statCard('0', 'Victorias'),
          const SizedBox(width: 10),
          _statCard('—', 'Ranking'),
        ]),
        const SizedBox(height: 28),

        ElevatedButton(
          onPressed: _loading ? null : _guardar,
          child: _loading
              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
              : Text('GUARDAR', style: GoogleFonts.barlowCondensed(fontSize: 18, fontWeight: FontWeight.w700, letterSpacing: 2)),
        ),
        const SizedBox(height: 16),
      ]),
    ));
  }

  Widget _sectionTitle(String t) => Text(t,
    style: GoogleFonts.barlowCondensed(fontSize: 11, letterSpacing: 3, color: AppColors.blueBright));

  Widget _chipLabel(String t) => Text(t,
    style: GoogleFonts.barlowCondensed(fontSize: 12, letterSpacing: 1, color: AppColors.white30));

  Widget _infoTile(IconData icon, String label, String value) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    decoration: BoxDecoration(color: AppColors.white05, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.white10)),
    child: Row(children: [
      Icon(icon, color: AppColors.white30, size: 18),
      const SizedBox(width: 12),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: GoogleFonts.barlowCondensed(fontSize: 11, color: AppColors.white30, letterSpacing: 1)),
        Text(value, style: GoogleFonts.barlow(fontSize: 15, color: Colors.white)),
      ]),
    ]),
  );

  Widget _chip(String label, bool active, VoidCallback onTap) => GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: active ? AppColors.blue.withOpacity(0.2) : AppColors.white05,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: active ? AppColors.blueBright : AppColors.white10, width: active ? 2 : 1),
      ),
      child: Text(label, style: GoogleFonts.barlowCondensed(fontSize: 14, fontWeight: FontWeight.w600,
        color: active ? Colors.white : AppColors.white30)),
    ),
  );

  Widget _statCard(String value, String label) => Expanded(child: Container(
    padding: const EdgeInsets.symmetric(vertical: 16),
    decoration: BoxDecoration(color: AppColors.white05, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.white10)),
    child: Column(children: [
      Text(value, style: GoogleFonts.bebasNeue(fontSize: 28, color: Colors.white)),
      Text(label, style: GoogleFonts.barlowCondensed(fontSize: 11, color: AppColors.white30, letterSpacing: 1)),
    ]),
  ));
}



