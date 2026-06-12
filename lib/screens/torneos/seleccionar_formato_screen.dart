import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../painters/diagonal_bg_painter.dart';
import 'wizard/torneo_clasico_wizard.dart';
import 'wizard/eliminatorias_wizard.dart';
import 'wizard/maraton_wizard.dart';
import 'wizard/ranking_wizard.dart';
import 'wizard/americano_wizard.dart';

/// Pantalla de acceso a "Crear torneo".
/// Card destacada (formato clasico) arriba a todo el ancho,
/// y debajo el grid con los otros 4 formatos.
class SeleccionarFormatoScreen extends StatelessWidget {
  const SeleccionarFormatoScreen({super.key});

  // Card destacada: el formato clasico de torneo.
  static const _destacado = _FormatoInfo(
    id: 'torneo_clasico',
    nombre: 'TORNEO CLASICO',
    descripcion:
        'Formato tradicional: fase de grupos y después cuadro eliminatorio.',
    icon: Icons.sync_alt_rounded,
    color: AppColors.blueBright,
  );

  static const List<_FormatoInfo> _formatos = [
    _FormatoInfo(
      id: 'eliminatorias',
      nombre: 'ELIMINATORIAS',
      descripcion: 'Cuadro de eliminación directa. El clásico: perdés, te vas.',
      icon: Icons.account_tree_outlined,
      color: AppColors.red,
    ),
    _FormatoInfo(
      id: 'maraton',
      nombre: 'MARATÓN',
      descripcion: 'Jornada intensiva con partidos garantizados por pareja.',
      icon: Icons.timer_outlined,
      color: Color(0xFFFF9447),
    ),
    _FormatoInfo(
      id: 'ranking',
      nombre: 'RANKING',
      descripcion: 'Competencia por jornadas con puntos, ascensos y descensos.',
      icon: Icons.leaderboard_outlined,
      color: Color(0xFFA06BFF),
    ),
    _FormatoInfo(
      id: 'americano',
      nombre: 'AMERICANO',
      descripcion: 'Parejas rotativas: jugás con y contra todos. Puro social.',
      icon: Icons.shuffle_rounded,
      color: AppColors.green,
    ),
  ];

  void _abrirWizard(BuildContext context, String id) {
    final Widget destino = switch (id) {
      'torneo_clasico' => const TorneoClasicoWizard(),
      'eliminatorias' => const EliminatoriasWizard(),
      'maraton' => const MaratonWizard(),
      'ranking' => const RankingWizard(),
      'americano' => const AmericanoWizard(),
      _ => const SizedBox.shrink(),
    };
    Navigator.push(context, MaterialPageRoute(builder: (_) => destino));
  }

  @override
  Widget build(BuildContext context) {
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
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_ios, color: AppColors.white30, size: 20),
                ),
                Text('CREAR TORNEO',
                    style: GoogleFonts.bebasNeue(fontSize: 28, letterSpacing: 2, color: Colors.white)),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 24),
              child: Text('Elegí el formato del torneo',
                  style: GoogleFonts.barlowCondensed(
                      fontSize: 12, letterSpacing: 2, color: AppColors.white30)),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                child: Column(children: [
                  _FeaturedCard(
                    info: _destacado,
                    onTap: () => _abrirWizard(context, _destacado.id),
                  ),
                  const SizedBox(height: 14),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                      childAspectRatio: 0.80,
                    ),
                    itemCount: _formatos.length,
                    itemBuilder: (ctx, i) => _FormatoCard(
                      info: _formatos[i],
                      onTap: () => _abrirWizard(context, _formatos[i].id),
                    ),
                  ),
                ]),
              ),
            ),
          ]),
        ),
      ]),
    );
  }
}

class _FormatoInfo {
  final String id;
  final String nombre;
  final String descripcion;
  final IconData icon;
  final Color color;
  const _FormatoInfo({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.icon,
    required this.color,
  });
}

/// Card destacada a todo el ancho (formato clasico).
class _FeaturedCard extends StatelessWidget {
  final _FormatoInfo info;
  final VoidCallback onTap;
  const _FeaturedCard({required this.info, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [info.color.withOpacity(0.18), AppColors.white05],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: info.color.withOpacity(0.6), width: 1.5),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: info.color.withOpacity(0.18),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: info.color.withOpacity(0.6)),
              ),
              child: Icon(info.icon, color: info.color, size: 30),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: info.color.withOpacity(0.18),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: info.color.withOpacity(0.6)),
              ),
              child: Text('TORNEO CLÁSICO',
                  style: GoogleFonts.barlowCondensed(
                      fontSize: 10,
                      letterSpacing: 2,
                      fontWeight: FontWeight.w700,
                      color: info.color)),
            ),
          ]),
          const SizedBox(height: 14),
          Text(info.nombre,
              style: GoogleFonts.bebasNeue(
                  fontSize: 26, letterSpacing: 1.5, color: Colors.white)),
          const SizedBox(height: 6),
          Text(info.descripcion,
              style: GoogleFonts.barlowCondensed(
                  fontSize: 14, height: 1.3, color: AppColors.white30)),
          const SizedBox(height: 12),
          Row(children: [
            Text('CONFIGURAR',
                style: GoogleFonts.barlowCondensed(
                    fontSize: 12,
                    letterSpacing: 2,
                    fontWeight: FontWeight.w700,
                    color: info.color)),
            const SizedBox(width: 4),
            Icon(Icons.arrow_forward_ios, size: 11, color: info.color),
          ]),
        ]),
      ),
    );
  }
}

/// Card chica del grid (formatos secundarios).
class _FormatoCard extends StatelessWidget {
  final _FormatoInfo info;
  final VoidCallback onTap;
  const _FormatoCard({required this.info, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white05,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.white10),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: info.color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: info.color.withOpacity(0.5)),
            ),
            child: Icon(info.icon, color: info.color, size: 22),
          ),
          const Spacer(),
          Text(info.nombre,
              style: GoogleFonts.bebasNeue(
                  fontSize: 20, letterSpacing: 1.5, color: Colors.white)),
          const SizedBox(height: 4),
          Flexible(
            child: Text(info.descripcion,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.barlowCondensed(
                    fontSize: 13, height: 1.25, color: AppColors.white30)),
          ),
          const SizedBox(height: 8),
          Row(children: [
            Text('CONFIGURAR',
                style: GoogleFonts.barlowCondensed(
                    fontSize: 11, letterSpacing: 2, fontWeight: FontWeight.w700, color: info.color)),
            const SizedBox(width: 4),
            Icon(Icons.arrow_forward_ios, size: 10, color: info.color),
          ]),
        ]),
      ),
    );
  }
}