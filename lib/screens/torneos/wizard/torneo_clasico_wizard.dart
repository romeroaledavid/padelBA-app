import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import 'wizard_widgets.dart';
import 'grupos_preview.dart';

/// Wizard de creación de TORNEO CLÁSICO (fase de grupos y eliminatorias).
/// Solo lectura por ahora: no persiste en Supabase.
class TorneoClasicoWizard extends StatefulWidget {
  const TorneoClasicoWizard({super.key});

  @override
  State<TorneoClasicoWizard> createState() => _TorneoClasicoWizardState();
}

class _TorneoClasicoWizardState extends State<TorneoClasicoWizard> {
  static const _accent = AppColors.blueBright;

  final _nombreCtrl = TextEditingController();
  final _fechasCtrl = TextEditingController();
  DateTimeRange? _rango;

  /// Clubes habilitados — la misma lista que usa el perfil del jugador.
  static const List<String> _clubes = [
    'Golf Santa Teresita',
    'P4 Padel Center',
    'Zeus Mar de Ajó',
    'Cortaderas Mar de Ajó',
  ];
  final List<String> _clubesSel = [];

  int _grupos = 2;
  int _parejasPorGrupo = 4;
  String _modalidad = '2_sets_stb'; // mejor_3 | 2_sets_stb | 1_set
  final List<int> _cats = [];
  final List<String> _sumas = []; // 'Suma 3 (+3)', etc.
  int _canchas = 2;

  static const List<String> _sumasOpciones = [
    'Suma 3 (+3)',
    'Suma 5 (+5)',
    'Suma 7 (+7)',
    'Suma 9 (+9)',
    'Suma 11 (+11)',
    'Suma 13 (+13)',
  ];

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _fechasCtrl.dispose();
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
      titulo: 'TORNEO CLÁSICO',
      color: _accent,
      steps: [
        WizardStep(
          title: 'Datos del torneo',
          validate: () {
            if (_nombreCtrl.text.trim().isEmpty) return 'Ingresá el nombre del torneo';
            if (_clubesSel.isEmpty) return 'Elegí al menos un club / sede';
            if (_rango == null) return 'Elegí las fechas del torneo';
            return null;
          },
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            wzField('Nombre del torneo', _nombreCtrl, icon: Icons.emoji_events_outlined),
            const SizedBox(height: 20),
            wzLabel('CLUBES / SEDES', color: _accent),
            const SizedBox(height: 4),
            wzHint('Podés elegir más de uno'),
            const SizedBox(height: 8),
            wzMultiChips(_clubes, _clubesSel, setState, color: _accent),
            const SizedBox(height: 20),
            wzDateRangeField(context, 'Fechas del torneo (inicio → cierre)', _fechasCtrl,
                accent: _accent, onPicked: (r) => setState(() => _rango = r)),
          ]),
        ),
        WizardStep(
          title: 'Grupos y modalidad',
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            wzLabel('CANTIDAD DE GRUPOS', color: _accent),
            const SizedBox(height: 10),
            wzCounter(
              value: _grupos, min: 1, max: 8, accent: _accent, suffix: 'grupos',
              onChanged: (v) => setState(() => _grupos = v),
            ),
            const SizedBox(height: 20),
            wzLabel('PAREJAS POR GRUPO', color: _accent),
            const SizedBox(height: 10),
            wzCounter(
              value: _parejasPorGrupo, min: 3, max: 6, accent: _accent, suffix: 'parejas',
              onChanged: (v) => setState(() => _parejasPorGrupo = v),
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
            const SizedBox(height: 24),
            wzLabel('PAREJAS ANOTADAS', color: _accent),
            const SizedBox(height: 4),
            wzHint('Posiciones por suma de puntos individuales'),
            const SizedBox(height: 8),
            const ParejasRanking(accent: _accent),
          ]),
        ),
        WizardStep(
          title: 'Vista previa de grupos',
          child: GruposPreview(grupos: _grupos, accent: _accent),
        ),
        WizardStep(
          title: 'Categorías',
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            wzLabel('CATEGORÍAS HABILITADAS', color: _accent),
            const SizedBox(height: 4),
            wzHint('Dejá vacío para todas'),
            const SizedBox(height: 8),
            wzCategorias(_cats, setState),
            const SizedBox(height: 24),
            wzLabel('TORNEOS SUMA', color: _accent),
            const SizedBox(height: 4),
            wzHint('La suma de categorías de la pareja no puede superar el número'),
            const SizedBox(height: 8),
            wzMultiChips(_sumasOpciones, _sumas, setState, color: _accent),
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
              MapEntry('Formato', 'Torneo clásico'),
              MapEntry('Nombre', _nombreCtrl.text.trim()),
              MapEntry('Clubes / Sedes', _clubesSel.join(', ')),
              MapEntry('Fechas', _fechasCtrl.text.trim()),
              MapEntry('Grupos', '$_grupos'),
              MapEntry('Parejas por grupo', '$_parejasPorGrupo'),
              MapEntry('Modalidad', _modalidadTexto),
              MapEntry('Categorías', wzCatsTexto(_cats)),
              MapEntry('Torneos suma', _sumas.isEmpty ? '—' : _sumas.join(', ')),
              MapEntry('Canchas', '$_canchas'),
            ]),
          ]),
        ),
      ],
    );
  }
}