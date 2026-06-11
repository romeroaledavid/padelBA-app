import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import 'wizard_widgets.dart';

/// Wizard de creación de torneo ROUND ROBIN (zonas de todos contra todos).
/// Solo lectura por ahora: no persiste en Supabase.
class RoundRobinWizard extends StatefulWidget {
  const RoundRobinWizard({super.key});

  @override
  State<RoundRobinWizard> createState() => _RoundRobinWizardState();
}

class _RoundRobinWizardState extends State<RoundRobinWizard> {
  static const _accent = AppColors.blueBright;

  final _nombreCtrl = TextEditingController();
  final _clubCtrl = TextEditingController();
  final _fechaCtrl = TextEditingController();

  int _zonas = 2;
  int _parejasPorZona = 4;
  String _modalidad = '2_sets_stb'; // mejor_3 | 2_sets_stb | 1_set
  final List<int> _cats = [];
  int _canchas = 2;

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _clubCtrl.dispose();
    _fechaCtrl.dispose();
    super.dispose();
  }

  String get _modalidadTexto => switch (_modalidad) {
        'mejor_3' => 'Mejor de 3 sets',
        '2_sets_stb' => '2 sets + super tie-break',
        _ => '1 set',
      };

  @override
  Widget build(BuildContext context) {
    return TorneoWizard(
      titulo: 'ROUND ROBIN',
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
          title: 'Zonas y modalidad',
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            wzLabel('CANTIDAD DE ZONAS', color: _accent),
            const SizedBox(height: 10),
            wzCounter(
              value: _zonas, min: 1, max: 8, accent: _accent, suffix: 'zonas',
              onChanged: (v) => setState(() => _zonas = v),
            ),
            const SizedBox(height: 20),
            wzLabel('PAREJAS POR ZONA', color: _accent),
            const SizedBox(height: 10),
            wzCounter(
              value: _parejasPorZona, min: 3, max: 6, accent: _accent, suffix: 'parejas',
              onChanged: (v) => setState(() => _parejasPorZona = v),
            ),
            const SizedBox(height: 20),
            wzLabel('MODALIDAD DE PARTIDOS', color: _accent),
            const SizedBox(height: 10),
            Wrap(spacing: 8, runSpacing: 8, children: [
              wzChip('Mejor de 3 sets', _modalidad == 'mejor_3',
                  () => setState(() => _modalidad = 'mejor_3'), color: _accent),
              wzChip('2 sets + super tie-break', _modalidad == '2_sets_stb',
                  () => setState(() => _modalidad = '2_sets_stb'), color: _accent),
              wzChip('1 set', _modalidad == '1_set',
                  () => setState(() => _modalidad = '1_set'), color: _accent),
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
              MapEntry('Formato', 'Round Robin'),
              MapEntry('Nombre', _nombreCtrl.text.trim()),
              MapEntry('Club / Sede', _clubCtrl.text.trim()),
              MapEntry('Fecha', _fechaCtrl.text.trim()),
              MapEntry('Zonas', '$_zonas'),
              MapEntry('Parejas por zona', '$_parejasPorZona'),
              MapEntry('Modalidad', _modalidadTexto),
              MapEntry('Categorías', wzCatsTexto(_cats)),
              MapEntry('Canchas', '$_canchas'),
            ]),
          ]),
        ),
      ],
    );
  }
}