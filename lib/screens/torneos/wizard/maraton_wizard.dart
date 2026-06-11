import 'package:flutter/material.dart';
import 'wizard_widgets.dart';

/// Wizard de creación de torneo MARATÓN (jornada intensiva).
/// Solo lectura por ahora: no persiste en Supabase.
class MaratonWizard extends StatefulWidget {
  const MaratonWizard({super.key});

  @override
  State<MaratonWizard> createState() => _MaratonWizardState();
}

class _MaratonWizardState extends State<MaratonWizard> {
  static const _accent = Color(0xFFFF9447);

  final _nombreCtrl = TextEditingController();
  final _clubCtrl = TextEditingController();
  final _fechaCtrl = TextEditingController();

  int _duracionHs = 8;
  int _partidosGarantizados = 4;
  String _puntuacion = 'games'; // games | sets
  final List<int> _cats = [];
  int _canchas = 4;

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
      titulo: 'MARATÓN',
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
            wzLabel('DURACIÓN DE LA JORNADA', color: _accent),
            const SizedBox(height: 10),
            wzCounter(
              value: _duracionHs, min: 3, max: 24, accent: _accent, suffix: 'horas',
              onChanged: (v) => setState(() => _duracionHs = v),
            ),
            const SizedBox(height: 20),
            wzLabel('PARTIDOS GARANTIZADOS POR PAREJA', color: _accent),
            const SizedBox(height: 10),
            wzCounter(
              value: _partidosGarantizados, min: 2, max: 10, accent: _accent, suffix: 'partidos',
              onChanged: (v) => setState(() => _partidosGarantizados = v),
            ),
            const SizedBox(height: 20),
            wzLabel('PUNTUACIÓN', color: _accent),
            const SizedBox(height: 4),
            wzHint('Cómo se suman puntos para la tabla general'),
            const SizedBox(height: 8),
            Wrap(spacing: 8, runSpacing: 8, children: [
              wzChip('Por games ganados', _puntuacion == 'games',
                  () => setState(() => _puntuacion = 'games'), color: _accent),
              wzChip('Por sets ganados', _puntuacion == 'sets',
                  () => setState(() => _puntuacion = 'sets'), color: _accent),
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
              MapEntry('Formato', 'Maratón'),
              MapEntry('Nombre', _nombreCtrl.text.trim()),
              MapEntry('Club / Sede', _clubCtrl.text.trim()),
              MapEntry('Fecha', _fechaCtrl.text.trim()),
              MapEntry('Duración', '$_duracionHs horas'),
              MapEntry('Partidos garantizados', '$_partidosGarantizados'),
              MapEntry('Puntuación', _puntuacion == 'games' ? 'Por games' : 'Por sets'),
              MapEntry('Categorías', wzCatsTexto(_cats)),
              MapEntry('Canchas', '$_canchas'),
            ]),
          ]),
        ),
      ],
    );
  }
}