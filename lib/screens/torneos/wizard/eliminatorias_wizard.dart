import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import 'wizard_widgets.dart';

/// Wizard de creación de torneo de ELIMINATORIAS (cuadro de eliminación directa).
/// Solo lectura por ahora: no persiste en Supabase.
class EliminatoriasWizard extends StatefulWidget {
  const EliminatoriasWizard({super.key});

  @override
  State<EliminatoriasWizard> createState() => _EliminatoriasWizardState();
}

class _EliminatoriasWizardState extends State<EliminatoriasWizard> {
  static const _accent = AppColors.red;

  final _nombreCtrl = TextEditingController();
  final _clubCtrl = TextEditingController();
  final _fechaCtrl = TextEditingController();

  int _cuadro = 16; // 8 | 16 | 32 | 64
  bool _consolacion = true;
  String _siembra = 'ranking'; // ranking | sorteo
  final List<int> _cats = [];
  int _canchas = 2;

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _clubCtrl.dispose();
    _fechaCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TorneoWizard(
      titulo: 'ELIMINATORIAS',
      color: _accent,
      steps: [
        WizardStep(
          title: 'Datos del torneo',
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            wzField('Nombre del torneo', _nombreCtrl, icon: Icons.emoji_events_outlined),
            const SizedBox(height: 14),
            wzField('Club / Sede', _clubCtrl, icon: Icons.location_on_outlined),
            const SizedBox(height: 14),
            wzDateField(context, 'Fecha', _fechaCtrl, accent: _accent),
          ]),
        ),
        WizardStep(
          title: 'Cuadro',
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            wzLabel('TAMAÑO DEL CUADRO', color: _accent),
            const SizedBox(height: 10),
            Wrap(spacing: 8, runSpacing: 8, children: [8, 16, 32, 64]
                .map((n) => wzChip('$n parejas', _cuadro == n,
                    () => setState(() => _cuadro = n), color: _accent))
                .toList()),
            const SizedBox(height: 20),
            wzLabel('SIEMBRA', color: _accent),
            const SizedBox(height: 10),
            Wrap(spacing: 8, runSpacing: 8, children: [
              wzChip('Por ranking', _siembra == 'ranking',
                  () => setState(() => _siembra = 'ranking'), color: _accent),
              wzChip('Sorteo', _siembra == 'sorteo',
                  () => setState(() => _siembra = 'sorteo'), color: _accent),
            ]),
            const SizedBox(height: 20),
            wzLabel('CONSOLACIÓN', color: _accent),
            const SizedBox(height: 4),
            wzHint('Los que pierden en primera ronda juegan un cuadro paralelo'),
            const SizedBox(height: 8),
            Wrap(spacing: 8, runSpacing: 8, children: [
              wzChip('Con consolación', _consolacion,
                  () => setState(() => _consolacion = true), color: _accent),
              wzChip('Sin consolación', !_consolacion,
                  () => setState(() => _consolacion = false), color: _accent),
            ]),
          ]),
        ),
        WizardStep(
          title: 'Categorías',
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            wzLabel('CATEGORÍAS HABILITADAS', color: _accent),
            const SizedBox(height: 4),
            wzHint('Dejá vacío para todas'),
            const SizedBox(height: 8),
            wzCategorias(_cats, setState),
          ]),
        ),
        WizardStep(
          title: 'Canchas',
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            wzLabel('CANCHAS DISPONIBLES', color: _accent),
            const SizedBox(height: 10),
            wzCounter(
              value: _canchas, min: 1, max: 20, accent: _accent, suffix: 'canchas',
              onChanged: (v) => setState(() => _canchas = v),
            ),
          ]),
        ),
        WizardStep(
          title: 'Resumen',
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            wzLabel('REVISÁ LA CONFIGURACIÓN', color: _accent),
            const SizedBox(height: 12),
            wzResumen(_accent, [
              MapEntry('Formato', 'Eliminación directa'),
              MapEntry('Nombre', _nombreCtrl.text.trim()),
              MapEntry('Club / Sede', _clubCtrl.text.trim()),
              MapEntry('Fecha', _fechaCtrl.text.trim()),
              MapEntry('Cuadro', '$_cuadro parejas'),
              MapEntry('Siembra', _siembra == 'ranking' ? 'Por ranking' : 'Sorteo'),
              MapEntry('Consolación', _consolacion ? 'Sí' : 'No'),
              MapEntry('Categorías', wzCatsTexto(_cats)),
              MapEntry('Canchas', '$_canchas'),
            ]),
          ]),
        ),
      ],
    );
  }
}