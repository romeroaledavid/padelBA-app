import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';

class TorneosScreen extends StatelessWidget {
  const TorneosScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Icon(Icons.emoji_events_outlined, color: AppColors.white30, size: 60),
        const SizedBox(height: 16),
        Text('TORNEOS', style: GoogleFonts.bebasNeue(fontSize: 32, letterSpacing: 3, color: Colors.white)),
        Text('Próximamente', style: GoogleFonts.barlowCondensed(fontSize: 16, color: AppColors.white30, letterSpacing: 2)),
      ]),
    ));
  }
}


// ===================== JUGADORES SCREEN (read-only) =====================
