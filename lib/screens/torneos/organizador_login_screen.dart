import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../theme/app_colors.dart';
import '../../painters/diagonal_bg_painter.dart';
import 'contrato_organizador_screen.dart';

class OrganizadorLoginScreen extends StatefulWidget {
  const OrganizadorLoginScreen({super.key});
  @override
  State<OrganizadorLoginScreen> createState() => _OrganizadorLoginScreenState();
}

class _OrganizadorLoginScreenState extends State<OrganizadorLoginScreen> {
  final _dniCtrl = TextEditingController();
  final _pwdCtrl = TextEditingController();
  bool _loading  = false;
  bool _showPwd  = false;

  @override
  void initState() {
    super.initState();
    _loadSaved();
  }

  Future<void> _loadSaved() async {
    final prefs = await SharedPreferences.getInstance();
    final dni = prefs.getString('org_dni') ?? '';
    final pwd = prefs.getString('org_pwd') ?? '';
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
    if (dni.isEmpty || pwd.length < 8) {
      _toast('Ingresá tu DNI y contraseña', error: true); return;
    }
    setState(() => _loading = true);
    try {
      // 1. Verificar rol en Supabase
      final response = await Supabase.instance.client
          .from('usuarios')
          .select('id, nombre, apellido, rol, clubes')
          .eq('dni', dni)
          .maybeSingle();

      if (response == null) {
        _toast('DNI no encontrado en el sistema', error: true); return;
      }

      final rol = response['rol'] as String?;
      if (rol != 'organizador' && rol != 'fiscal') {
        _toast('DNI no autorizado para crear torneos', error: true); return;
      }

      // 2. Login con Supabase Auth
      await Supabase.instance.client.auth.signInWithPassword(
        email: 'dni$dni@padelba.app',
        password: pwd,
      );

      // 3. Guardar credenciales
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('org_dni', dni);
      await prefs.setString('org_pwd', pwd);

      if (!mounted) return;

      // 4. Ir al contrato
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (_) => ContratoOrganizadorScreen(perfil: response),
      ));

    } catch (e) {
      _toast('DNI o contraseña incorrectos', error: true);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

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

            // Header
            Row(children: [
              Container(
                width: 52, height: 52,
                decoration: BoxDecoration(
                  color: AppColors.blueBright.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.emoji_events_outlined, color: AppColors.blueBright, size: 28),
              ),
              const SizedBox(width: 14),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('CREAR TORNEO', style: GoogleFonts.bebasNeue(fontSize: 32, letterSpacing: 2, color: Colors.white)),
                Text('Acceso para organizadores autorizados',
                  style: GoogleFonts.barlowCondensed(fontSize: 11, letterSpacing: 2, color: AppColors.blueBright.withOpacity(0.7))),
              ]),
            ]),
            const SizedBox(height: 36),

            // Info box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.blueBright.withOpacity(0.06),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.blueBright.withOpacity(0.2)),
              ),
              child: Row(children: [
                const Icon(Icons.info_outline, color: AppColors.blueBright, size: 18),
                const SizedBox(width: 10),
                Expanded(child: Text(
                  'Solo organizadores autorizados por PadelBA pueden crear torneos. Tu DNI debe estar registrado en el sistema.',
                  style: GoogleFonts.barlow(fontSize: 12, color: AppColors.blueBright.withOpacity(0.8)),
                )),
              ]),
            ),
            const SizedBox(height: 28),

            // DNI
            TextField(
              controller: _dniCtrl,
              keyboardType: TextInputType.number,
              maxLength: 8,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'DNI del organizador',
                prefixIcon: Icon(Icons.badge_outlined, color: AppColors.white30),
                counterText: '',
              ),
            ),
            const SizedBox(height: 14),

            // Contraseña
            TextField(
              controller: _pwdCtrl,
              obscureText: !_showPwd,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Contraseña',
                prefixIcon: const Icon(Icons.lock_outline, color: AppColors.white30),
                suffixIcon: IconButton(
                  icon: Icon(_showPwd ? Icons.visibility_off : Icons.visibility, color: AppColors.white30),
                  onPressed: () => setState(() => _showPwd = !_showPwd),
                ),
              ),
            ),
            const SizedBox(height: 28),

            // Botón
            ElevatedButton(
              onPressed: _loading ? null : _ingresar,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.blueBright,
                foregroundColor: AppColors.navy,
              ),
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