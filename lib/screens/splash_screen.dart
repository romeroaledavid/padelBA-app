import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../theme/app_colors.dart';
import '../painters/diagonal_bg_painter.dart';
import 'auth/login_screen.dart';
import 'home/home_screen.dart';

// ===================== SPLASH =====================
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _ctrl.forward();
    _checkSession();
  }

  Future<void> _checkSession() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    final session = Supabase.instance.client.auth.currentSession;
    Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (_) => session != null ? const HomeScreen() : const LoginScreen(),
    ));
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Container(decoration: const BoxDecoration(gradient: RadialGradient(
          center: Alignment(0, 0.5), radius: 1.2,
          colors: [Color(0xFF1565E8), AppColors.navy], stops: [0.0, 0.7],
        ))),
        CustomPaint(painter: DiagonalBgPainter(), child: Container()),
        FadeTransition(opacity: _fade, child: Center(child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ShaderMask(
              shaderCallback: (b) => const LinearGradient(
                colors: [Colors.white, AppColors.blueBright, AppColors.yellow],
                begin: Alignment.topLeft, end: Alignment.bottomRight,
              ).createShader(b),
              child: Text('PADEL BA', style: GoogleFonts.bebasNeue(fontSize: 72, letterSpacing: 8, color: Colors.white)),
            ),
            const SizedBox(height: 8),
            Text('BUENOS AIRES', style: GoogleFonts.barlowCondensed(fontSize: 14, letterSpacing: 8, color: AppColors.white30)),
            const SizedBox(height: 48),
            const CircularProgressIndicator(color: AppColors.blueBright, strokeWidth: 2),
          ],
        ))),
      ]),
    );
  }
}

