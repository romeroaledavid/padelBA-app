import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

// ===================== DIAGONAL BG =====================
class DiagonalBgPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final pY = Paint()..color = const Color(0xFFF5C518).withOpacity(0.55)..strokeWidth = 3..style = PaintingStyle.stroke;
    final pB = Paint()..color = const Color(0xFF2D7FFF).withOpacity(0.45)..strokeWidth = 1.5..style = PaintingStyle.stroke;
    final pYt = Paint()..color = const Color(0xFFF5C518).withOpacity(0.25)..strokeWidth = 1..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(size.width * 0.55, -20), Offset(size.width * 1.1, size.height * 0.55), pY);
    canvas.drawLine(Offset(size.width * 0.62, -20), Offset(size.width * 1.15, size.height * 0.52), pB);
    canvas.drawLine(Offset(size.width * 0.48, -20), Offset(size.width * 1.05, size.height * 0.58), pYt);
    canvas.drawLine(Offset(-20, size.height * 0.65), Offset(size.width * 0.45, size.height * 1.05), pY);
    canvas.drawLine(Offset(-20, size.height * 0.72), Offset(size.width * 0.42, size.height * 1.1), pB);
    canvas.drawLine(Offset(-20, size.height * 0.58), Offset(size.width * 0.38, size.height * 0.98), pYt);
    final spot1 = Paint()..shader = RadialGradient(colors: [const Color(0xFF2D7FFF).withOpacity(0.18), Colors.transparent])
        .createShader(Rect.fromCircle(center: Offset(size.width * 0.15, size.height * 0.08), radius: size.width * 0.4));
    canvas.drawCircle(Offset(size.width * 0.15, size.height * 0.08), size.width * 0.4, spot1);
    final spot2 = Paint()..shader = RadialGradient(colors: [const Color(0xFF2D7FFF).withOpacity(0.15), Colors.transparent])
        .createShader(Rect.fromCircle(center: Offset(size.width * 0.85, size.height * 0.08), radius: size.width * 0.4));
    canvas.drawCircle(Offset(size.width * 0.85, size.height * 0.08), size.width * 0.4, spot2);
  }
  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

