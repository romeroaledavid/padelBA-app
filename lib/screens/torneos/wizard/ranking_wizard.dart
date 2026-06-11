import 'package:flutter/material.dart';
import 'wizard_widgets.dart';

/// Wizard de creación de torneo de RANKING (competencia por jornadas).
/// Solo lectura por ahora: no persiste en Supabase.
class RankingWizard extends StatefulWidget {
  const RankingWizard({super.key});

  @override
  State<RankingWizard> createState() => _RankingWizardState();
}

class _RankingWizardState extends State<RankingWizard> {
  static const _accent = Color(0xFFA06BFF);

  final _nombreCtrl = TextEditingController();
  final _clubCtrl = TextEditingController();
  final _fechaCtrl = TextEditingController();

  int _jornadas = 6;
  String _sistemaPuntos = 'estandar'; // estandar | escalado
  int _ascensos = 2;
  final List<int> _cats = [];

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
      titulo: 'RANKING',
      color: _accent,
      steps: [
        WizardStep(
          title: 'Datos del torneo',
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            wzField('Nombre del ranking', _nombreCtrl, icon: Icons.emoji_events_outlined),
            const SizedBox(height: 14),
            wzField('Club / Sede', _clubCtrl, icon: Icons.location_on_outlined),
            const SizedBox(height: 14),
            wzDateField(context, 'Fecha de inicio', _fechaCtrl, accent: _accent),
          ]),
        ),
        WizardStep(
          title: 'Configuración',
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            wzLabel('CANTIDAD DE JORNADAS', color: _accent),
            const SizedBox(height: 10),
            wzCounter(
              value: _jornadas, min: 2, max: 20, accent: _accent, suffix: 'jornadas',
              onChanged: (v) => setState(() => _jornadas = v),
            ),
            const SizedBox(height: 20),
            wzLabel('SISTEMA DE PUNTOS', color: _accent),
            const SizedBox(height: 4),
            wzHint('Estándar: mismos puntos por jornada · Escalado: las últimas valen más'),
            const SizedBox(height: 8),
            Wrap(spacing: 8, runSpacing: 8, children: [
              wzChip('Estándar', _sistemaPuntos == 'estandar',
                  () => setState(() => _sistemaPuntos = 'estandar'), color: _accent),
              wzChip('Escalado', _sistemaPuntos == 'escalado',
                  () => setState(() => _sistemaPuntos = 'escalado'), color: _accent),
            ]),
            const SizedBox(height: 20),
            wzLabel('ASCENSOS / DESCENSOS POR CATEGORÍA', color: _accent),
            const SizedBox(height: 10),
            wzCounter(
              value: _ascensos, min: 0, max: 6, accent: _accent, suffix: 'parejas',
              onChanged: (v) => setState(() => _ascensos = v),
            ),
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
          title: 'Resumen',
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            wzLabel('REVISÁ LA CONFIGURACIÓN', color: _accent),
            const SizedBox(height: 12),
            wzResumen(_accent, [
              MapEntry('Formato', 'Ranking'),
              MapEntry('Nombre', _nombreCtrl.text.trim()),
              MapEntry('Club / Sede', _clubCtrl.text.trim()),
              MapEntry('Fecha de inicio', _fechaCtrl.text.trim()),
              MapEntry('Jornadas', '$_jornadas'),
              MapEntry('Sistema de puntos',
                  _sistemaPuntos == 'estandar' ? 'Estándar' : 'Escalado'),
              MapEntry('Ascensos / descensos', '$_ascensos parejas'),
              MapEntry('Categorías', wzCatsTexto(_cats)),
            ]),
          ]),
        ),
      ],
    );
  }
}