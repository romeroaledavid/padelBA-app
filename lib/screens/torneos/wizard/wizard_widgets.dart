import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import '../../../painters/diagonal_bg_painter.dart';

/// Widgets compartidos por los wizards de creación de torneos.
/// Cada formato (torneo clásico, eliminatorias, maratón, ranking, americano)
/// define sus propios pasos y usa este scaffold + helpers.

class WizardStep {
  final String title;
  final Widget child;

  /// Validación opcional del paso: devuelve un mensaje de error si falta
  /// completar algo, o null si está todo bien y se puede avanzar.
  final String? Function()? validate;

  const WizardStep({required this.title, required this.child, this.validate});
}

class TorneoWizard extends StatefulWidget {
  final String titulo;
  final Color color;
  final List<WizardStep> steps;

  /// Por ahora el wizard es solo lectura: el botón final no persiste nada.
  /// Cuando se conecte a Supabase, pasar acá el callback de guardado.
  final VoidCallback? onCrear;

  const TorneoWizard({
    super.key,
    required this.titulo,
    required this.color,
    required this.steps,
    this.onCrear,
  });

  @override
  State<TorneoWizard> createState() => _TorneoWizardState();
}

class _TorneoWizardState extends State<TorneoWizard> {
  int _index = 0;

  bool get _esUltimo => _index == widget.steps.length - 1;

  void _siguiente() {
    final error = widget.steps[_index].validate?.call();
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(error, style: GoogleFonts.barlowCondensed(fontSize: 15)),
        backgroundColor: AppColors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ));
      return;
    }
    if (!_esUltimo) setState(() => _index++);
  }

  void _anterior() {
    if (_index > 0) {
      setState(() => _index--);
    } else {
      Navigator.pop(context);
    }
  }

  void _crear() {
    if (widget.onCrear != null) {
      widget.onCrear!();
      return;
    }
    // Modo solo lectura: todavía no se guarda en la base.
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Modo solo lectura — el guardado se habilita próximamente',
          style: GoogleFonts.barlowCondensed(fontSize: 15)),
      backgroundColor: widget.color,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final step = widget.steps[_index];
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
                  onPressed: _anterior,
                  icon: const Icon(Icons.arrow_back_ios, color: AppColors.white30, size: 20),
                ),
                Expanded(
                  child: Text(widget.titulo,
                      style: GoogleFonts.bebasNeue(
                          fontSize: 26, letterSpacing: 2, color: Colors.white)),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.white05,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.white10),
                  ),
                  child: Text('SOLO LECTURA',
                      style: GoogleFonts.barlowCondensed(
                          fontSize: 10, letterSpacing: 2, color: AppColors.white30)),
                ),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 4, 24, 0),
              child: Text(
                'PASO ${_index + 1} DE ${widget.steps.length} · ${step.title.toUpperCase()}',
                style: GoogleFonts.barlowCondensed(
                    fontSize: 11, letterSpacing: 2, color: widget.color),
              ),
            ),
            const SizedBox(height: 10),
            // Indicador de progreso por segmentos.
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: List.generate(widget.steps.length, (i) {
                  return Expanded(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: 4,
                      margin: EdgeInsets.only(right: i == widget.steps.length - 1 ? 0 : 6),
                      decoration: BoxDecoration(
                        color: i <= _index ? widget.color : AppColors.white10,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  );
                }),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: KeyedSubtree(key: ValueKey(_index), child: step.child),
                ),
              ),
            ),
            // Barra de navegación inferior.
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
              child: Row(children: [
                if (_index > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _anterior,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.white10),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text('ANTERIOR',
                          style: GoogleFonts.barlowCondensed(
                              fontSize: 16, letterSpacing: 2, color: AppColors.white30)),
                    ),
                  ),
                if (_index > 0) const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: _esUltimo ? _crear : _siguiente,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.color,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(_esUltimo ? 'CREAR TORNEO' : 'SIGUIENTE',
                        style: GoogleFonts.barlowCondensed(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2,
                            color: Colors.white)),
                  ),
                ),
              ]),
            ),
          ]),
        ),
      ]),
    );
  }
}

// ---------------------------------------------------------------------------
// Helpers de formulario reutilizables
// ---------------------------------------------------------------------------

Widget wzLabel(String t, {Color color = AppColors.blueBright}) => Text(t,
    style: GoogleFonts.barlowCondensed(fontSize: 11, letterSpacing: 3, color: color));

Widget wzHint(String t) =>
    Text(t, style: GoogleFonts.barlow(fontSize: 11, color: AppColors.white30));

Widget wzField(String label, TextEditingController ctrl,
        {IconData? icon, bool readOnly = false, VoidCallback? onTap}) =>
    TextField(
      controller: ctrl,
      readOnly: readOnly,
      onTap: onTap,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon != null ? Icon(icon, color: AppColors.white30) : null,
      ),
    );

/// Campo de fecha: abre el date picker con el tema oscuro de la app.
Widget wzDateField(BuildContext context, String label, TextEditingController ctrl,
    {Color accent = AppColors.blue}) {
  Future<void> pick() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
      builder: (ctx, child) => Theme(
        data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(primary: accent, surface: AppColors.navy2)),
        child: child!,
      ),
    );
    if (picked != null) {
      ctrl.text =
          '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
    }
  }

  return wzField(label, ctrl,
      icon: Icons.calendar_today_outlined, readOnly: true, onTap: pick);
}

/// Campo de rango de fechas: inicio y cierre en el mismo calendario.
/// Muestra el día de hoy resaltado; ideal para torneos de 3-4 días.
Widget wzDateRangeField(
    BuildContext context, String label, TextEditingController ctrl,
    {Color accent = AppColors.blue, void Function(DateTimeRange)? onPicked}) {
  Future<void> pick() async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365 * 2)),
      currentDate: now,
      initialDateRange: DateTimeRange(
        start: now.add(const Duration(days: 7)),
        end: now.add(const Duration(days: 10)),
      ),
      saveText: 'LISTO',
      helpText: 'FECHAS DEL TORNEO',
      builder: (ctx, child) => Theme(
        data: ThemeData.dark().copyWith(
            colorScheme:
                ColorScheme.dark(primary: accent, surface: AppColors.navy2)),
        child: child!,
      ),
    );
    if (picked != null) {
      String f(DateTime d) =>
          '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
      ctrl.text = '${f(picked.start)} → ${f(picked.end)}';
      onPicked?.call(picked);
    }
  }

  return wzField(label, ctrl,
      icon: Icons.date_range_outlined, readOnly: true, onTap: pick);
}

/// Desplegable con estilo de la app (club/sede, etc.).
Widget wzDropdown({
  required String label,
  required String? value,
  required List<String> options,
  required void Function(String?) onChanged,
  IconData? icon,
}) =>
    DropdownButtonFormField<String>(
      value: value,
      dropdownColor: AppColors.navy2,
      style: const TextStyle(color: Colors.white),
      icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.white30),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon != null ? Icon(icon, color: AppColors.white30) : null,
      ),
      items: options
          .map((o) => DropdownMenuItem(value: o, child: Text(o)))
          .toList(),
      onChanged: onChanged,
    );

Widget wzChip(String label, bool active, VoidCallback onTap,
        {Color color = AppColors.blueBright}) =>
    GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: active ? color.withOpacity(0.2) : AppColors.white05,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: active ? color : AppColors.white10, width: active ? 2 : 1),
        ),
        child: Text(label,
            style: GoogleFonts.barlowCondensed(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: active ? Colors.white : AppColors.white30)),
      ),
    );

/// Chips de selección múltiple (clubes/sedes, sumas, etc.).
Widget wzMultiChips(
  List<String> options,
  List<String> selected,
  void Function(VoidCallback) setState, {
  Color color = AppColors.blueBright,
}) =>
    Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options
          .map((o) => wzChip(
                o,
                selected.contains(o),
                () => setState(() {
                  selected.contains(o) ? selected.remove(o) : selected.add(o);
                }),
                color: color,
              ))
          .toList(),
    );

/// Chips de categorías 1ra–8va con su color propio. Devuelve la lista ordenada.
Widget wzCategorias(List<int> cats, void Function(VoidCallback) setState) =>
    Wrap(
      spacing: 8,
      runSpacing: 8,
      children: List.generate(8, (i) {
        final cat = i + 1;
        final color = AppColors.categoryColor(cat);
        final active = cats.contains(cat);
        return GestureDetector(
          onTap: () => setState(() {
            active ? cats.remove(cat) : cats.add(cat);
            cats.sort();
          }),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: active ? color.withOpacity(0.2) : AppColors.white05,
              borderRadius: BorderRadius.circular(20),
              border:
                  Border.all(color: active ? color : AppColors.white10, width: active ? 2 : 1),
            ),
            child: Text(wzOrdinal(cat),
                style: GoogleFonts.barlowCondensed(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: active ? color : AppColors.white30)),
          ),
        );
      }),
    );

/// Contador con botones +/- (canchas, zonas, jornadas, etc.).
Widget wzCounter({
  required int value,
  required int min,
  required int max,
  required void Function(int) onChanged,
  String suffix = '',
  Color accent = AppColors.blueBright,
}) =>
    Row(children: [
      IconButton(
        onPressed: value > min ? () => onChanged(value - 1) : null,
        icon: Icon(Icons.remove_circle_outline,
            color: value > min ? accent : AppColors.white10),
      ),
      Container(
        width: 60,
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.white05,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.white10),
        ),
        child: Center(
            child: Text('$value',
                style: GoogleFonts.bebasNeue(fontSize: 24, color: Colors.white))),
      ),
      IconButton(
        onPressed: value < max ? () => onChanged(value + 1) : null,
        icon: Icon(Icons.add_circle_outline,
            color: value < max ? accent : AppColors.white10),
      ),
      if (suffix.isNotEmpty)
        Text(suffix,
            style: GoogleFonts.barlowCondensed(fontSize: 14, color: AppColors.white30)),
    ]);

/// Card de resumen para el último paso del wizard.
Widget wzResumen(Color accent, List<MapEntry<String, String>> items) => Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white05,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: accent.withOpacity(0.4)),
      ),
      child: Column(
        children: items
            .map((e) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(e.key.toUpperCase(),
                            style: GoogleFonts.barlowCondensed(
                                fontSize: 12, letterSpacing: 2, color: AppColors.white30)),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(e.value.isEmpty ? '—' : e.value,
                            textAlign: TextAlign.right,
                            style: GoogleFonts.barlowCondensed(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.white)),
                      ),
                    ],
                  ),
                ))
            .toList(),
      ),
    );

/// Ordinal de categoría: 1ra, 2da, 3ra, 4ta, 5ta, 6ta, 7ma, 8va.
String wzOrdinal(int c) => switch (c) {
      1 => '1ra',
      2 => '2da',
      3 => '3ra',
      7 => '7ma',
      8 => '8va',
      _ => '${c}ta', // 4ta, 5ta, 6ta
    };

String wzCatsTexto(List<int> cats) =>
    cats.isEmpty ? 'Todas' : cats.map(wzOrdinal).join(', ');