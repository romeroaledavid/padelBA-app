import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import 'wizard_widgets.dart';

/// Wizard de creación de torneo AMERICANO (parejas rotativas).
/// Solo lectura por ahora: no persiste en Supabase.
class AmericanoWizard extends StatefulWidget {
  const AmericanoWizard({super.key});

  @override
  State<AmericanoWizard> createState() => _AmericanoWizardState();
}

class _AmericanoWizardState extends State<AmericanoWizard> {
  static const _accent = AppColors.green;

  final _nombreCtrl = TextEditingController();
  final _clubCtrl = TextEditingController();
  final _fechaCtrl = TextEditingController();

  int _jugadores = 8;
  int _rondas = 7;
  int _puntosPorRonda = 24; // 16 | 21 | 24 | 32
  bool _mixto = false;
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
      titulo: 'AMERICANO',
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
          title: 'Configuración',
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            wzLabel('CANTIDAD DE JUGADORES', color: _accent),
            const SizedBox(height: 4),
            wzHint('En americano la inscripción es individual, las parejas rotan'),
            const SizedBox(height: 8),
            wzCounter(
              value: _jugadores, min: 4, max: 32, accent: _accent, suffix: 'jugadores',
              onChanged: (v) => setState(() => _jugadores = v),
            ),
            const SizedBox(height: 20),
            wzLabel('RONDAS', color: _accent),
            const SizedBox(height: 10),
            wzCounter(
              value: _rondas, min: 3, max: 15, accent: _accent, suffix: 'rondas',
              onChanged: (v) => setState(() => _rondas = v),
            ),
            const SizedBox(height: 20),
            wzLabel('PUNTOS POR RONDA', color: _accent),
            const SizedBox(height: 10),
            Wrap(spacing: 8, runSpacing: 8, children: [16, 21, 24, 32]
                .map((p) => wzChip('$p puntos', _puntosPorRonda == p,
                    () => setState(() => _puntosPorRonda = p), color: _accent))
                .toList()),
            const SizedBox(height: 20),
            wzLabel('MODALIDAD', color: _accent),
            const SizedBox(height: 10),
            Wrap(spacing: 8, runSpacing: 8, children: [
              wzChip('Abierto', !_mixto, () => setState(() => _mixto = false),
                  color: _accent),
              wzChip('Mixto', _mixto, () => setState(() => _mixto = true),
                  color: _accent),
            ]),
          ]),
        ),
        WizardStep(
          title: 'Canchas',
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            wzLabel('CANCHAS DISPONIBLES', color: _accent),
            const SizedBox(height: 4),
            wzHint('Tip: con ${_jugadores ~/ 4} canchas juegan todos a la vez'),
            const SizedBox(height: 8),
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
              MapEntry('Formato', 'Americano'),
              MapEntry('Nombre', _nombreCtrl.text.trim()),
              MapEntry('Club / Sede', _clubCtrl.text.trim()),
              MapEntry('Fecha', _fechaCtrl.text.trim()),
              MapEntry('Jugadores', '$_jugadores'),
              MapEntry('Rondas', '$_rondas'),
              MapEntry('Puntos por ronda', '$_puntosPorRonda'),
              MapEntry('Modalidad', _mixto ? 'Mixto' : 'Abierto'),
              MapEntry('Canchas', '$_canchas'),
            ]),
          ]),
        ),
      ],
    );
  }
}