import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

// ===================== PROFILE AVATAR =====================
class _GradientBorderPainter extends CustomPainter {
  final List<Color> colors;
  final double strokeWidth;
  _GradientBorderPainter({required this.colors, required this.strokeWidth});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = SweepGradient(colors: [...colors, colors.first]).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(size.center(Offset.zero), size.width / 2 - strokeWidth / 2, paint);
  }
  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

class ProfileAvatar extends StatelessWidget {
  final String? fotoUrl;
  final String initials;
  final int categoria;
  final int? categoriaObservada;
  final double radius;

  const ProfileAvatar({
    super.key,
    required this.fotoUrl,
    required this.initials,
    required this.categoria,
    this.categoriaObservada,
    required this.radius,
  });

  @override
  Widget build(BuildContext context) {
    final bool enObs = categoriaObservada != null && categoriaObservada != categoria;
    final catColor = categoria > 0 ? AppColors.categoryColor(categoria) : AppColors.blueBright;
    final List<Color> borderColors = enObs
        ? [AppColors.categoryColor(categoria), AppColors.categoryColor(categoriaObservada!)]
        : [catColor];
    final String badge = enObs ? '$categoria/$categoriaObservada' : categoria > 0 ? '$categoria' : '';
    final totalSize = radius * 2 + 8;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        SizedBox(
          width: totalSize, height: totalSize,
          child: CustomPaint(
            painter: enObs ? _GradientBorderPainter(colors: borderColors, strokeWidth: 3) : null,
            child: Container(
              margin: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: enObs ? null : Border.all(color: catColor, width: 2.5),
                boxShadow: [BoxShadow(color: catColor.withOpacity(0.4), blurRadius: 10, spreadRadius: 1)],
              ),
              child: CircleAvatar(
                radius: radius,
                backgroundColor: AppColors.navy3,
                backgroundImage: fotoUrl != null ? NetworkImage(fotoUrl!) : null,
                child: fotoUrl == null
                    ? Text(initials, style: GoogleFonts.bebasNeue(fontSize: radius * 0.8, color: Colors.white))
                    : null,
              ),
            ),
          ),
        ),
        if (badge.isNotEmpty)
          Positioned(
            top: -4, right: -4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              decoration: BoxDecoration(
                gradient: enObs ? LinearGradient(colors: borderColors) : null,
                color: enObs ? null : catColor,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.navy, width: 1.5),
              ),
              child: Text(badge, style: GoogleFonts.bebasNeue(fontSize: enObs ? 9 : 11, color: AppColors.navy)),
            ),
          ),
      ],
    );
  }
}

