import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../theme/app_colors.dart';
import 'wizard_widgets.dart';

/// Vista previa del armado de grupos en "víbora" (serpentina).
/// Lee las parejas demo de Supabase (vista_parejas_demo), las ordena por
/// puntos totales (más puntos = mejor siembra) y las reparte en la cantidad
/// de grupos que el organizador eligió en el paso anterior del wizard.
class GruposPreview extends StatefulWidget {
  final int grupos;
  final Color accent;
  const GruposPreview({super.key, required this.grupos, required this.accent});

  @override
  State<GruposPreview> createState() => _GruposPreviewState();
}

class _GruposPreviewState extends State<GruposPreview> {
  late final Future<List<Map<String, dynamic>>> _future;

  @override
  void initState() {
    super.initState();
    _future = Supabase.instance.client
        .from('vista_parejas_demo')
        .select()
        .order('puntos_total', ascending: false)
        .then((rows) => List<Map<String, dynamic>>.from(rows as List));
  }

  /// Reparto víbora: ida (G1→Gn), vuelta (Gn→G1), ida, vuelta...
  /// El índice de cada pareja en la lista ordenada es su siembra (0 = mejor).
  List<List<Map<String, dynamic>>> _vibora(
      List<Map<String, dynamic>> parejas, int z) {
    final grupos = List.generate(z, (_) => <Map<String, dynamic>>[]);
    for (var i = 0; i < parejas.length; i++) {
      final ronda = i ~/ z;
      final pos = i % z;
      final g = ronda.isEven ? pos : (z - 1 - pos); // ida o vuelta
      grupos[g].add({...parejas[i], 'seed': i + 1});
    }
    return grupos;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _future,
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Center(
                child: CircularProgressIndicator(color: widget.accent)),
          );
        }
        if (snap.hasError) {
          return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            wzLabel('ERROR AL CARGAR PAREJAS', color: AppColors.red),
            const SizedBox(height: 8),
            Text('${snap.error}',
                style: GoogleFonts.barlow(fontSize: 12, color: AppColors.white30)),
            const SizedBox(height: 8),
            wzHint('Verificá haber corrido seed_demo.sql en Supabase'),
          ]);
        }
        final parejas = snap.data ?? [];
        if (parejas.isEmpty) {
          return wzHint(
              'No hay parejas cargadas. Corré seed_demo.sql en el SQL Editor de Supabase.');
        }

        final grupos = _vibora(parejas, widget.grupos);

        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          wzLabel(
              'ARMADO VÍBORA · ${widget.grupos} GRUPOS · ${parejas.length} PAREJAS',
              color: widget.accent),
          const SizedBox(height: 4),
          wzHint('Siembra por suma de puntos individuales (mayor = mejor)'),
          const SizedBox(height: 14),
          ...List.generate(grupos.length, (g) {
            final letra = String.fromCharCode(65 + g); // A, B, C...
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.white05,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.white10),
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      color: widget.accent.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: widget.accent.withOpacity(0.6)),
                    ),
                    child: Center(
                        child: Text(letra,
                            style: GoogleFonts.bebasNeue(
                                fontSize: 16, color: widget.accent))),
                  ),
                  const SizedBox(width: 8),
                  Text('GRUPO $letra',
                      style: GoogleFonts.bebasNeue(
                          fontSize: 18, letterSpacing: 1.5, color: Colors.white)),
                  const Spacer(),
                  Text('${grupos[g].length} parejas',
                      style: GoogleFonts.barlowCondensed(
                          fontSize: 12, color: AppColors.white30)),
                ]),
                const SizedBox(height: 10),
                ...grupos[g].map((p) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(children: [
                        SizedBox(
                          width: 26,
                          child: Text('${p['seed']}',
                              style: GoogleFonts.barlowCondensed(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.white30)),
                        ),
                        Expanded(
                          child: Text(
                            '${p['apellido1']} / ${p['apellido2']}'.toUpperCase(),
                            style: GoogleFonts.barlowCondensed(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: widget.accent.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text('${p['puntos_total']} pts',
                              style: GoogleFonts.barlowCondensed(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: widget.accent)),
                        ),
                      ]),
                    )),
              ]),
            );
          }),
        ]);
      },
    );
  }
}

/// Tabla de posiciones de las parejas anotadas, ordenada por puntos.
/// Se muestra en el paso 2 del wizard, debajo de la modalidad de partidos.
class ParejasRanking extends StatefulWidget {
  final Color accent;
  const ParejasRanking({super.key, required this.accent});

  @override
  State<ParejasRanking> createState() => _ParejasRankingState();
}

class _ParejasRankingState extends State<ParejasRanking> {
  late final Future<List<Map<String, dynamic>>> _future;

  @override
  void initState() {
    super.initState();
    _future = Supabase.instance.client
        .from('vista_parejas_demo')
        .select()
        .order('puntos_total', ascending: false)
        .then((rows) => List<Map<String, dynamic>>.from(rows as List));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _future,
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Center(
                child: CircularProgressIndicator(color: widget.accent)),
          );
        }
        if (snap.hasError) {
          return wzHint('No se pudieron cargar las parejas: ${snap.error}');
        }
        final parejas = snap.data ?? [];
        if (parejas.isEmpty) {
          return wzHint('No hay parejas anotadas todavía.');
        }
        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.white05,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.white10),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              SizedBox(
                width: 34,
                child: Text('POS',
                    style: GoogleFonts.barlowCondensed(
                        fontSize: 11,
                        letterSpacing: 1,
                        fontWeight: FontWeight.w700,
                        color: AppColors.white30)),
              ),
              Expanded(
                child: Text('PAREJA',
                    style: GoogleFonts.barlowCondensed(
                        fontSize: 11,
                        letterSpacing: 1,
                        fontWeight: FontWeight.w700,
                        color: AppColors.white30)),
              ),
              Text('PTS',
                  style: GoogleFonts.barlowCondensed(
                      fontSize: 11,
                      letterSpacing: 1,
                      fontWeight: FontWeight.w700,
                      color: AppColors.white30)),
            ]),
            const SizedBox(height: 6),
            Container(height: 1, color: AppColors.white10),
            const SizedBox(height: 4),
            ...List.generate(parejas.length, (i) {
              final p = parejas[i];
              final destacado = i < 3; // top 3 resaltado
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(children: [
                  SizedBox(
                    width: 34,
                    child: Text('${i + 1}',
                        style: GoogleFonts.barlowCondensed(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: destacado ? widget.accent : AppColors.white30)),
                  ),
                  Expanded(
                    child: Text(
                      '${p['apellido1']} / ${p['apellido2']}'.toUpperCase(),
                      style: GoogleFonts.barlowCondensed(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                  ),
                  Text('${p['puntos_total']}',
                      style: GoogleFonts.barlowCondensed(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: destacado ? widget.accent : AppColors.white30)),
                ]),
              );
            }),
          ]),
        );
      },
    );
  }
}