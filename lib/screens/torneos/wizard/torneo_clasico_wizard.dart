import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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

  /// Clubes habilitados con su total de canchas.
  /// TODO: cuando el wizard persista, leer de la tabla `clubes` en Supabase.
  static const Map<String, int> _clubesCanchas = {
    'Golf Santa Teresita': 5,
    'P4 Padel Center': 4,
    'Zeus': 3,
    'Cortaderas': 4,
  };
  static final List<String> _clubes = _clubesCanchas.keys.toList();

  final List<String> _clubesSel = [];

  /// Canchas a usar POR DÍA y POR CLUB. Clave exterior: fecha 'yyyy-mm-dd'.
  /// Solo lo ve el organizador. Sirve de base para que la app después
  /// organice dónde y a qué hora juega cada grupo.
  final Map<String, Map<String, int>> _canchasPorDia = {};

  int _grupos = 2;
  int _parejasPorGrupo = 4;
  String _modalidad = '2_sets_stb'; // mejor_3 | 2_sets_stb | 1_set

  /// Categoría y suma son EXCLUYENTES.
  int? _cat;
  String? _suma;

  static const List<String> _sumasOpciones = [
    'Suma 3 (+3)',
    'Suma 5 (+5)',
    'Suma 7 (+7)',
    'Suma 9 (+9)',
    'Suma 11 (+11)',
    'Suma 13 (+13)',
  ];

  static const List<String> _diasSemana = [
    'LUNES', 'MARTES', 'MIÉRCOLES', 'JUEVES', 'VIERNES', 'SÁBADO', 'DOMINGO',
  ];
  static const List<String> _diasCortos = [
    'Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom',
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

  // ---------------------------------------------------------------------
  // Días del torneo y canchas por día
  // ---------------------------------------------------------------------

  List<DateTime> get _diasTorneo {
    final r = _rango;
    if (r == null) return [];
    final out = <DateTime>[];
    var d = DateTime(r.start.year, r.start.month, r.start.day);
    final end = DateTime(r.end.year, r.end.month, r.end.day);
    while (!d.isAfter(end)) {
      out.add(d);
      d = d.add(const Duration(days: 1));
    }
    return out;
  }

  String _k(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  String _diaLabel(DateTime d) =>
      '${_diasSemana[d.weekday - 1]} ${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}';

  String _diaCorto(DateTime d) =>
      '${_diasCortos[d.weekday - 1]} ${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}';

  /// Alinea _canchasPorDia con las fechas del paso 1 y los clubes elegidos.
  /// Días o clubes nuevos arrancan usando todas las canchas del club.
  void _syncCanchasPorDia() {
    final keys = _diasTorneo.map(_k).toSet();
    _canchasPorDia.removeWhere((k, _) => !keys.contains(k));
    for (final k in keys) {
      final dia = _canchasPorDia.putIfAbsent(k, () => {});
      dia.removeWhere((club, _) => !_clubesSel.contains(club));
      for (final club in _clubesSel) {
        dia.putIfAbsent(club, () => _clubesCanchas[club] ?? 1);
      }
    }
  }

  int _totalDia(String k) =>
      (_canchasPorDia[k] ?? {}).values.fold(0, (a, b) => a + b);

  String get _canchasResumen => _diasTorneo
      .map((d) => '${_diaCorto(d)}: ${_totalDia(_k(d))}c')
      .join(' · ');

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
          validate: () {
            if (_cat == null && _suma == null) {
              return 'Elegí una categoría o un torneo suma';
            }
            return null;
          },
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            wzLabel('CATEGORÍA DEL TORNEO', color: _accent),
            const SizedBox(height: 4),
            wzHint(_suma != null
                ? 'Bloqueado: elegiste un torneo suma'
                : 'Elegí UNA sola categoría'),
            const SizedBox(height: 8),
            wzCategoriaUnica(
              _cat,
              (v) => setState(() {
                _cat = v;
                if (v != null) _suma = null; // excluyente
              }),
              enabled: _suma == null,
            ),
            const SizedBox(height: 24),
            wzLabel('TORNEOS SUMA', color: _accent),
            const SizedBox(height: 4),
            wzHint(_cat != null
                ? 'Bloqueado: elegiste un torneo por categoría'
                : 'La suma de categorías de la pareja no puede superar el número'),
            const SizedBox(height: 8),
            wzSingleChips(
              _sumasOpciones,
              _suma,
              (v) => setState(() {
                _suma = v;
                if (v != null) _cat = null; // excluyente
              }),
              color: _accent,
              enabled: _cat == null,
            ),
          ]),
        ),
        WizardStep(
          title: 'Canchas',
          validate: () {
            if (_clubesSel.isEmpty) return 'Volvé al paso 1 y elegí al menos un club';
            if (_rango == null) return 'Volvé al paso 1 y elegí las fechas';
            for (final d in _diasTorneo) {
              if (_totalDia(_k(d)) < 1) {
                return 'Asigná al menos una cancha para el ${_diaCorto(d)}';
              }
            }
            return null;
          },
          child: Builder(builder: (context) {
            _syncCanchasPorDia();
            final dias = _diasTorneo;
            return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              wzLabel('CANCHAS POR DÍA', color: _accent),
              const SizedBox(height: 4),
              wzHint('Cuántas canchas de cada club se usan cada día. Dejá en 0 '
                  'los clubes que no se usen ese día. Esta info la ve solo el '
                  'organizador y define dónde y cuándo juega cada grupo.'),
              const SizedBox(height: 16),
              if (dias.isEmpty)
                wzHint('Elegí las fechas del torneo en el paso 1.')
              else
                for (final d in dias) ...[
                  Row(children: [
                    Expanded(
                      child: Text(_diaLabel(d),
                          style: GoogleFonts.bebasNeue(
                              fontSize: 17, letterSpacing: 1.5, color: _accent)),
                    ),
                    Text('${_totalDia(_k(d))} CANCHAS',
                        style: GoogleFonts.barlowCondensed(
                            fontSize: 12,
                            letterSpacing: 2,
                            color: AppColors.white30)),
                  ]),
                  const SizedBox(height: 8),
                  for (final club in _clubesSel)
                    wzClubCanchas(
                      club: club,
                      total: _clubesCanchas[club] ?? 1,
                      usar: _canchasPorDia[_k(d)]?[club] ?? 0,
                      accent: _accent,
                      min: 0,
                      onChanged: (v) => setState(
                          () => _canchasPorDia[_k(d)]![club] = v),
                    ),
                  const SizedBox(height: 14),
                ],
            ]);
          }),
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
              MapEntry('Tipo',
                  _suma != null ? _suma! : _cat != null ? 'Categoría ${wzOrdinal(_cat!)}' : '—'),
              MapEntry('Canchas por día',
                  _diasTorneo.isEmpty ? '—' : _canchasResumen),
            ]),
          ]),
        ),
      ],
    );
  }
}