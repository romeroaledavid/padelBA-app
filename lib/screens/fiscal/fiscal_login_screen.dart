import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../theme/app_colors.dart';
import '../../painters/diagonal_bg_painter.dart';
import '../home/home_screen.dart';
import '../auth/login_screen.dart';
import 'fiscal_screen.dart';

const List<String> _fiscalDnis = ['30366869'];
class FiscalLoginScreen extends StatefulWidget {
  const FiscalLoginScreen({super.key});
  @override
  State<FiscalLoginScreen> createState() => _FiscalLoginScreenState();
}

class _FiscalLoginScreenState extends State<FiscalLoginScreen> {
  final _dniCtrl = TextEditingController();
  final _pwdCtrl = TextEditingController();
  bool _loading  = false;
  bool _showPwd  = false;

  @override
  void initState() {
    super.initState();
    _loadSavedFiscalDni();
  }

  Future<void> _loadSavedFiscalDni() async {
    final prefs = await SharedPreferences.getInstance();
    final dni = prefs.getString('fiscal_dni') ?? '';
    final pwd = prefs.getString('fiscal_pwd') ?? '';
    if (mounted) setState(() {
      if (dni.isNotEmpty) _dniCtrl.text = dni;
      if (pwd.isNotEmpty) _pwdCtrl.text = pwd;
    });
  }

  @override
  void dispose() { _dniCtrl.dispose(); _pwdCtrl.dispose(); super.dispose(); }

  void _toast(String msg, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg, style: GoogleFonts.barlowCondensed(fontSize: 15)),
      backgroundColor: error ? AppColors.red : AppColors.green,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }

  Future<void> _ingresar() async {
    final dni = _dniCtrl.text.trim();
    final pwd = _pwdCtrl.text;
    if (!_fiscalDnis.contains(dni)) {
      _toast('DNI no autorizado para acceso fiscal', error: true); return;
    }
    if (pwd.length < 8) {
      _toast('Contrasena incorrecta', error: true); return;
    }
    setState(() => _loading = true);
    try {
      await Supabase.instance.client.auth.signInWithPassword(
        email: 'dni$dni@padelba.app', password: pwd,
      );
      // Save fiscal credentials
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('fiscal_dni', dni);
      await prefs.setString('fiscal_pwd', pwd);
      if (mounted) {
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (_) => FiscalScreen(onUpdate: () {}),
        ));
      }
    } catch (e) {
      _toast('DNI o contrasena incorrectos', error: true);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  static void _noOp() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Container(decoration: const BoxDecoration(gradient: LinearGradient(
          begin: Alignment.topCenter, end: Alignment.bottomCenter,
          colors: [AppColors.navy, AppColors.navy2],
        ))),
        CustomPaint(painter: DiagonalBgPainter(), child: Container()),
        SafeArea(child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(height: 16),
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios, color: AppColors.white30),
            ),
            const SizedBox(height: 24),
            Row(children: [
              Container(
                width: 52, height: 52,
                decoration: BoxDecoration(color: AppColors.yellow.withOpacity(0.15), borderRadius: BorderRadius.circular(14)),
                child: const Icon(Icons.admin_panel_settings, color: AppColors.yellow, size: 28),
              ),
              const SizedBox(width: 14),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('ACCESO FISCAL', style: GoogleFonts.bebasNeue(fontSize: 32, letterSpacing: 2, color: Colors.white)),
                Text('Restringido - Solo personal autorizado', style: GoogleFonts.barlowCondensed(fontSize: 11, letterSpacing: 2, color: AppColors.yellow.withOpacity(0.7))),
              ]),
            ]),
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.yellow.withOpacity(0.05),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.yellow.withOpacity(0.2)),
              ),
              child: Row(children: [
                const Icon(Icons.lock_outline, color: AppColors.yellow, size: 18),
                const SizedBox(width: 10),
                Expanded(child: Text('Solo los fiscales autorizados pueden ingresar. Tu DNI debe estar registrado en el sistema.',
                  style: GoogleFonts.barlow(fontSize: 12, color: AppColors.yellow.withOpacity(0.8)))),
              ]),
            ),
            const SizedBox(height: 28),
            TextField(
              controller: _dniCtrl,
              keyboardType: TextInputType.number,
              maxLength: 8,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'DNI del fiscal',
                prefixIcon: Icon(Icons.badge_outlined, color: AppColors.white30),
                counterText: '',
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _pwdCtrl,
              obscureText: !_showPwd,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Contrasena',
                prefixIcon: const Icon(Icons.lock_outline, color: AppColors.white30),
                suffixIcon: IconButton(
                  icon: Icon(_showPwd ? Icons.visibility_off : Icons.visibility, color: AppColors.white30),
                  onPressed: () => setState(() => _showPwd = !_showPwd),
                ),
              ),
            ),
            const SizedBox(height: 28),
            ElevatedButton(
              onPressed: _loading ? null : _ingresar,
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.yellow, foregroundColor: AppColors.navy),
              child: _loading
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: AppColors.navy, strokeWidth: 2))
                  : Text('INGRESAR AL PANEL', style: GoogleFonts.barlowCondensed(fontSize: 18, fontWeight: FontWeight.w700, letterSpacing: 2)),
            ),
          ]),
        )),
      ]),
    );
  }
}

// ===================== FISCAL =====================
