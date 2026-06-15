import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import 'wizard_widgets.dart';

/// Datos DEMO de jugadores anotados. Hardcodeado hasta que exista el flujo
/// real de inscripción: torneo creado → banner en el perfil del jugador →
/// inscripción → el organizador revisa los anotados.
/// TODO: reemplazar por tabla `inscripciones` en Supabase.
class JugadorDemo {
  final String nombre;
  final int categoria;
  final int puntos;
  const JugadorDemo(this.nombre, this.categoria, this.puntos);
}

class ParejaDemo {
  final JugadorDemo a;
  final JugadorDemo b;
  const ParejaDemo(this.a, this.b);
  int get puntos => a.puntos + b.puntos;
  int get sumaCategorias => a.categoria + b.categoria;
}

/// 48 jugadores / 24 parejas: 34 de 4ta (70%) y 14 de 5ta (30%).
/// Alcanza justo para simular 8 grupos × 3 parejas.
const List<ParejaDemo> kParejasDemo = [
  // Parejas 4ta + 4ta
  ParejaDemo(JugadorDemo('Paternostro', 4, 28), JugadorDemo('Romero', 4, 26)),
  ParejaDemo(JugadorDemo('Galarza', 4, 27), JugadorDemo('Benítez', 4, 24)),
  ParejaDemo(JugadorDemo('Sosa', 4, 25), JugadorDemo('Acosta', 4, 23)),
  ParejaDemo(JugadorDemo('Medina', 4, 24), JugadorDemo('Ferreyra', 4, 22)),
  ParejaDemo(JugadorDemo('Cabrera', 4, 23), JugadorDemo('Ríos', 4, 21)),
  ParejaDemo(JugadorDemo('Ledesma', 4, 21), JugadorDemo('Vega', 4, 20)),
  ParejaDemo(JugadorDemo('Coronel', 4, 20), JugadorDemo('Ojeda', 4, 19)),
  ParejaDemo(JugadorDemo('Aguirre', 4, 19), JugadorDemo('Maidana', 4, 18)),
  ParejaDemo(JugadorDemo('Quiroga', 4, 18), JugadorDemo('Bustos', 4, 17)),
  ParejaDemo(JugadorDemo('Pereyra', 4, 17), JugadorDemo('Núñez', 4, 16)),
  ParejaDemo(JugadorDemo('Villalba', 4, 16), JugadorDemo('Cáceres', 4, 15)),
  ParejaDemo(JugadorDemo('Godoy', 4, 15), JugadorDemo('Mansilla', 4, 14)),
  // Parejas 4ta + 5ta
  ParejaDemo(JugadorDemo('Toledo', 4, 26), JugadorDemo('Barrios', 5, 16)),
  ParejaDemo(JugadorDemo('Moyano', 4, 24), JugadorDemo('Ponce', 5, 14)),
  ParejaDemo(JugadorDemo('Luna', 4, 22), JugadorDemo('Vera', 5, 13)),
  ParejaDemo(JugadorDemo('Chaves', 4, 20), JugadorDemo('Ibarra', 5, 12)),
  ParejaDemo(JugadorDemo('Roldán', 4, 19), JugadorDemo('Funes', 5, 11)),
  ParejaDemo(JugadorDemo('Gauto', 4, 18), JugadorDemo('Insaurralde', 5, 10)),
  ParejaDemo(JugadorDemo('Almada', 4, 16), JugadorDemo('Duarte', 5, 9)),
  ParejaDemo(JugadorDemo('Escobar', 4, 15), JugadorDemo('Farías', 5, 8)),
  ParejaDemo(JugadorDemo('Gómez', 4, 14), JugadorDemo('Herrera', 5, 7)),
  ParejaDemo(JugadorDemo('Juárez', 4, 14), JugadorDemo('Leiva', 5, 6)),
  // Parejas 5ta + 5ta
  ParejaDemo(JugadorDemo('Molina', 5, 12), JugadorDemo('Navarro', 5, 10)),
  ParejaDemo(JugadorDemo('Ortiz', 5, 9), JugadorDemo('Paz', 5, 7)),
];

List<ParejaDemo> _ordenadas() {
  final l = [...kParejasDemo];
  l.sort((x, y) => y.puntos.compareTo(x.puntos));
  return l;
}

/// Fila de una pareja para el ranking del paso 2: ambos jugadores con su
/// avatar (aro + badge del color de su categoría) y "Nombre (XXp)", más el
/// total de la pareja a la derecha.
class _ParejaRow extends StatelessWidget {
  final int posicion;
  final ParejaDemo pareja;
  final Color accent;
  const _ParejaRow(
      {required this.posicion, required this.pareja, required this.accent});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.white05,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.white10),
      ),
      child: Row(children: [
        SizedBox(
          width: 22,
          child: Text('$posicion',
              style: GoogleFonts.bebasNeue(fontSize: 18, color: accent)),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              wzJugadorCat(
                  nombre: pareja.a.nombre,
                  categoria: pareja.a.categoria,
                  puntos: pareja.a.puntos),
              const SizedBox(height: 6),
              wzJugadorCat(
                  nombre: pareja.b.nombre,
                  categoria: pareja.b.categoria,
                  puntos: pareja.b.puntos),
            ],
          ),
        ),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text('${pareja.puntos}',
              style: GoogleFonts.bebasNeue(fontSize: 22, color: Colors.white)),
          Text('PTS',
              style: GoogleFonts.barlowCondensed(
                  fontSize: 9, letterSpacing: 2, color: AppColors.white30)),
        ]),
      ]),
    );
  }
}

/// Tabla de parejas anotadas, ordenadas por suma de puntos individuales.
class ParejasRanking extends StatelessWidget {
  final Color accent;
  const ParejasRanking({super.key, required this.accent});

  @override
  Widget build(BuildContext context) {
    final parejas = _ordenadas();
    return Column(
      children: [
        for (var i = 0; i < parejas.length; i++)
          _ParejaRow(posicion: i + 1, pareja: parejas[i], accent: accent),
      ],
    );
  }
}

/// Fila de pareja dentro de un grupo: a la izquierda la POSICIÓN del
/// ranking del paso 2, y la pareja en una línea:
/// "Paternostro (28p) — Romero (26p)", con avatar de categoría cada uno.
/// Esta es la vista que verían los jugadores anotados desde su perfil.
class _ParejaGrupoRow extends StatelessWidget {
  final int posicion; // posición en el ranking de parejas anotadas (paso 2)
  final ParejaDemo pareja;
  final Color accent;
  const _ParejaGrupoRow(
      {required this.posicion, required this.pareja, required this.accent});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(children: [
        Container(
          width: 26,
          height: 26,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: accent.withOpacity(0.12),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: accent.withOpacity(0.4)),
          ),
          child: Text('$posicion',
              style: GoogleFonts.bebasNeue(fontSize: 14, color: accent)),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: wzJugadorCat(
              nombre: pareja.a.nombre,
              categoria: pareja.a.categoria,
              puntos: pareja.a.puntos,
              radius: 11),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text('—',
              style: GoogleFonts.barlowCondensed(
                  fontSize: 14, color: AppColors.white30)),
        ),
        Expanded(
          child: wzJugadorCat(
              nombre: pareja.b.nombre,
              categoria: pareja.b.categoria,
              puntos: pareja.b.puntos,
              radius: 11),
        ),
      ]),
    );
  }
}

/// Vista previa de grupos: reparte las parejas anotadas en N grupos en
/// serpentina (la mejor al A, la 2da al B... y vuelve) para que los grupos
/// queden parejos en nivel. Cada pareja muestra su posición del ranking
/// del paso 2 y una línea separadora con la siguiente.
class GruposPreview extends StatelessWidget {
  final int grupos;
  final Color accent;
  const GruposPreview({super.key, required this.grupos, required this.accent});

  @override
  Widget build(BuildContext context) {
    final parejas = _ordenadas();

    // Posición de cada pareja en el ranking del paso 2 (1 = mejor).
    final posiciones = {
      for (var i = 0; i < parejas.length; i++) parejas[i]: i + 1
    };

    // Reparto en serpentina.
    final List<List<ParejaDemo>> g = List.generate(grupos, (_) => []);
    var idx = 0;
    var dir = 1;
    for (final p in parejas) {
      g[idx].add(p);
      idx += dir;
      if (idx == grupos) {
        idx = grupos - 1;
        dir = -1;
      } else if (idx < 0) {
        idx = 0;
        dir = 1;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        wzLabel('ASÍ QUEDARÍAN LOS GRUPOS', color: accent),
        const SizedBox(height: 4),
        wzHint('El número indica la posición de la pareja en el ranking de '
            'anotados. Reparto en serpentina para grupos parejos.'),
        const SizedBox(height: 12),
        for (var i = 0; i < g.length; i++)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 6),
            decoration: BoxDecoration(
              color: AppColors.white05,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: accent.withOpacity(0.35)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('GRUPO ${String.fromCharCode(65 + i)}',
                    style: GoogleFonts.bebasNeue(
                        fontSize: 18, letterSpacing: 2, color: accent)),
                const SizedBox(height: 2),
                if (g[i].isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: wzHint('Sin parejas para este grupo'),
                  )
                else
                  for (var j = 0; j < g[i].length; j++) ...[
                    _ParejaGrupoRow(
                        posicion: posiciones[g[i][j]]!,
                        pareja: g[i][j],
                        accent: accent),
                    // Línea separadora entre parejas del grupo.
                    if (j < g[i].length - 1)
                      Container(height: 1, color: AppColors.white10),
                  ],
              ],
            ),
          ),
      ],
    );
  }
}