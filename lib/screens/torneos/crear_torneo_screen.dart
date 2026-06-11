import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../theme/app_colors.dart';
import '../../painters/diagonal_bg_painter.dart';

class CrearTorneoScreen extends StatefulWidget {
  final String formatoInicial;

const CrearTorneoScreen({
  super.key,
  this.formatoInicial = 'grupos',
});

  @override
  State<CrearTorneoScreen> createState() => _CrearTorneoScreenState();
}

class _CrearTorneoScreenState extends State<CrearTorneoScreen> {
  final _nombreCtrl = TextEditingController();
  final _clubCtrl   = TextEditingController();
  final _fechaCtrl  = TextEditingController();
  String _formato   = 'grupos';
  List<int> _cats   = [];
  int _canchas      = 2;
  bool _loading     = false;

@override
void initState() {
  super.initState();
  _formato = widget.formatoInicial;
}

  @override
  void dispose() {
    _nombreCtrl.dispose(); _clubCtrl.dispose(); _fechaCtrl.dispose();
    super.dispose();
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
      _fechaCtrl.text = '${picked.year}-${picked.month.toString().padLeft(2,'0')}-${picked.day.toString().padLeft(2,'0')}';
    }
  }

  Future<void> _crear() async {
    if (_nombreCtrl.text.trim().isEmpty) { _toast('Ingresa el nombre del torneo', error: true); return; }
    if (_fechaCtrl.text.trim().isEmpty)  { _toast('Ingresa la fecha del torneo', error: true); return; }
    setState(() => _loading = true);
    try {
      final uid = Supabase.instance.client.auth.currentUser?.id;
      await Supabase.instance.client.from('torneos').insert({
        'nombre': _nombreCtrl.text.trim(),
        'club': _clubCtrl.text.trim(),
        'fecha': _fechaCtrl.text.trim(),
        'formato': _formato,
        'categorias': _cats.isNotEmpty ? _cats : null,
        'canchas': _canchas,
        'creado_por': uid,
        'estado': 'pendiente',
      });
      _toast('Torneo creado exitosamente!');
      if (mounted) Navigator.pop(context);
    } catch (e) {
      _toast('Error al crear torneo: $e', error: true);
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
    return Scaffold(
      backgroundColor: AppColors.navy,
      body: Stack(children: [
        CustomPaint(painter: DiagonalBgPainter(), child: Container()),
        SafeArea(child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_ios, color: AppColors.white30, size: 20),
              ),
              Text('CREAR TORNEO', style: GoogleFonts.bebasNeue(fontSize: 28, letterSpacing: 2, color: Colors.white)),
            ]),
            Text('Completa la informacion del torneo', style: GoogleFonts.barlowCondensed(fontSize: 12, letterSpacing: 2, color: AppColors.white30)),
            const SizedBox(height: 24),
            _field('Nombre del torneo', _nombreCtrl, icon: Icons.emoji_events_outlined),
            const SizedBox(height: 14),
            _field('Club / Sede', _clubCtrl, icon: Icons.location_on_outlined),
            const SizedBox(height: 14),
            GestureDetector(
              onTap: _pickFecha,
              child: AbsorbPointer(child: _field('Fecha', _fechaCtrl, icon: Icons.calendar_today_outlined)),
            ),
            const SizedBox(height: 20),
            _label('FORMATO SELECCIONADO'),
const SizedBox(height: 10),

Container(
  padding: const EdgeInsets.symmetric(
    horizontal: 14,
    vertical: 10,
  ),
  decoration: BoxDecoration(
    color: AppColors.navy2,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(
      color: AppColors.blueBright,
    ),
  ),
  child: Text(
    _formato.toUpperCase(),
    style: GoogleFonts.barlowCondensed(
      fontSize: 15,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    ),
  ),
),

const SizedBox(height: 20),
            _label('CATEGORÍAS HABILITADAS'),
            const SizedBox(height: 4),
            Text('Dejá vacío para todas', style: GoogleFonts.barlow(fontSize: 11, color: AppColors.white30)),
            const SizedBox(height: 8),
            Wrap(spacing: 8, runSpacing: 8, children: List.generate(8, (i) {
              final cat = i + 1;
              final color = AppColors.categoryColor(cat);
              final active = _cats.contains(cat);
              return GestureDetector(
                onTap: () => setState(() => active ? _cats.remove(cat) : _cats.add(cat)),
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
            _label('CANCHAS DISPONIBLES'),
            const SizedBox(height: 10),
            Row(children: [
              IconButton(
                onPressed: () => setState(() { if (_canchas > 1) _canchas--; }),
                icon: const Icon(Icons.remove_circle_outline, color: AppColors.white30),
              ),
              Container(
                width: 60, height: 48,
                decoration: BoxDecoration(color: AppColors.white05, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.white10)),
                child: Center(child: Text('$_canchas', style: GoogleFonts.bebasNeue(fontSize: 24, color: Colors.white))),
              ),
              IconButton(
                onPressed: () => setState(() { if (_canchas < 20) _canchas++; }),
                icon: const Icon(Icons.add_circle_outline, color: AppColors.blueBright),
              ),
              Text('canchas', style: GoogleFonts.barlowCondensed(fontSize: 14, color: AppColors.white30)),
            ]),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _loading ? null : _crear,
              child: _loading
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : Text('CREAR TORNEO', style: GoogleFonts.barlowCondensed(fontSize: 18, fontWeight: FontWeight.w700, letterSpacing: 2)),
            ),
            const SizedBox(height: 20),
          ]),
        )),
      ]),
    );
  }

  Widget _label(String t) => Text(t, style: GoogleFonts.barlowCondensed(fontSize: 11, letterSpacing: 3, color: AppColors.blueBright));

  Widget _field(String label, TextEditingController ctrl, {IconData? icon}) =>
    TextField(controller: ctrl, style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(labelText: label, prefixIcon: icon != null ? Icon(icon, color: AppColors.white30) : null));

  Widget _chip(String label, bool active, VoidCallback onTap) => GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: active ? AppColors.blue.withOpacity(0.2) : AppColors.white05,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: active ? AppColors.blueBright : AppColors.white10, width: active ? 2 : 1),
      ),
      child: Text(label, style: GoogleFonts.barlowCondensed(fontSize: 13, fontWeight: FontWeight.w600, color: active ? Colors.white : AppColors.white30)),
    ),
  );
}