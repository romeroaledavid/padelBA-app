import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../theme/app_colors.dart';
import '../../painters/diagonal_bg_painter.dart';
import '../home/home_screen.dart';
import '../fiscal/fiscal_login_screen.dart';
import 'package:padel_ba/screens/torneos/crear_torneo_screen.dart';
import 'package:padel_ba/screens/fiscal/fiscal_login_screen.dart';
import '../torneos/seleccionar_formato_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLogin = true;
  bool _loading = false;
  bool _showPwd = false;
  final _dniCtrl    = TextEditingController();
  final _pwdCtrl    = TextEditingController();
  final _nombreCtrl = TextEditingController();
  final _apCtrl     = TextEditingController();
  final _emailCtrl  = TextEditingController();
  DateTime? _fechaNac;

  @override
  void initState() { super.initState(); _loadSavedDni(); }

  Future<void> _loadSavedDni() async {
    final prefs = await SharedPreferences.getInstance();
    final savedDni = prefs.getString('saved_dni') ?? '';
    final savedPwd = prefs.getString('saved_pwd') ?? '';
    if (mounted) setState(() {
      if (savedDni.isNotEmpty) _dniCtrl.text = savedDni;
      if (savedPwd.isNotEmpty) _pwdCtrl.text = savedPwd;
    });
  }

  Future<void> _saveCredentials(String dni, String pwd) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('saved_dni', dni);
    await prefs.setString('saved_pwd', pwd);
  }

  @override
  void dispose() {
    _dniCtrl.dispose(); _pwdCtrl.dispose(); _nombreCtrl.dispose();
    _apCtrl.dispose(); _emailCtrl.dispose();
    super.dispose();
  }

  void _toast(String msg, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg, style: GoogleFonts.barlowCondensed(fontSize: 15)),
      backgroundColor: error ? AppColors.red : AppColors.blue,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }

  Future<void> _doLogin() async {
    final dni = _dniCtrl.text.trim();
    final pwd = _pwdCtrl.text;
    if (!RegExp(r'^\d{7,8}$').hasMatch(dni)) { _toast('DNI invalido', error: true); return; }
    if (pwd.length < 8) { _toast('Contrasena incorrecta', error: true); return; }
    setState(() => _loading = true);
    try {
      await Supabase.instance.client.auth.signInWithPassword(email: 'dni$dni@padelba.app', password: pwd);
      await _saveCredentials(dni, pwd);
      if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
    } catch (e) {
      _toast('DNI o contrasena incorrectos', error: true);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _doRegister() async {
    final nombre   = _nombreCtrl.text.trim();
    final apellido = _apCtrl.text.trim();
    final dni      = _dniCtrl.text.trim();
    final email    = _emailCtrl.text.trim();
    final pwd      = _pwdCtrl.text;
    if (nombre.length < 2)   { _toast('Ingresa tu nombre', error: true); return; }
    if (apellido.length < 2) { _toast('Ingresa tu apellido', error: true); return; }
    if (!RegExp(r'^\d{7,8}$').hasMatch(dni)) { _toast('DNI invalido', error: true); return; }
    if (!email.contains('@')) { _toast('Email invalido', error: true); return; }
    if (_fechaNac == null)    { _toast('Ingresa tu fecha de nacimiento', error: true); return; }
    if (pwd.length < 8 || !pwd.contains(RegExp(r'[A-Z]')) || !pwd.contains(RegExp(r'[0-9]'))) {
      _toast('Contrasena: 8+ caracteres, mayuscula y numero', error: true); return;
    }
    setState(() => _loading = true);
    try {
      final res = await Supabase.instance.client.auth.signUp(email: 'dni$dni@padelba.app', password: pwd);
      if (res.user != null) {
        final fechaStr = '${_fechaNac!.year}-${_fechaNac!.month.toString().padLeft(2,'0')}-${_fechaNac!.day.toString().padLeft(2,'0')}';
        await Supabase.instance.client.from('usuarios').upsert({
          'id': res.user!.id, 'dni': dni, 'nombre': nombre, 'apellido': apellido,
          'email': email, 'fecha_nacimiento': fechaStr, 'rol': 'jugador',
        });
        if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
      }
    } catch (e) {
      _toast('Error al registrarse: $e', error: true);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(1990),
      firstDate: DateTime(1920),
      lastDate: DateTime.now().subtract(const Duration(days: 365 * 5)),
      builder: (ctx, child) => Theme(
        data: ThemeData.dark().copyWith(colorScheme: const ColorScheme.dark(primary: AppColors.blue, surface: AppColors.navy2)),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _fechaNac = picked);
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
            const SizedBox(height: 32),
            ShaderMask(
              shaderCallback: (b) => const LinearGradient(colors: [Colors.white, AppColors.blueBright, AppColors.yellow]).createShader(b),
              child: Text('PADEL BA', style: GoogleFonts.bebasNeue(fontSize: 48, letterSpacing: 4, color: Colors.white)),
            ),
            Text('Buenos Aires - Padel', style: GoogleFonts.barlowCondensed(fontSize: 13, letterSpacing: 5, color: AppColors.white30)),
            const SizedBox(height: 40),
            Container(
              decoration: BoxDecoration(color: AppColors.white05, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.white10)),
              padding: const EdgeInsets.all(4),
              child: Row(children: [
                _tabBtn('Ingresar', _isLogin, () => setState(() => _isLogin = true)),
                _tabBtn('Registrarse', !_isLogin, () => setState(() {
                  _isLogin = false;
                  _nombreCtrl.clear(); _apCtrl.clear(); _emailCtrl.clear();
                  _dniCtrl.clear(); _pwdCtrl.clear(); _fechaNac = null;
                })),
              ]),
            ),
            const SizedBox(height: 28),
            if (!_isLogin) ...[
              Row(children: [
                Expanded(child: _input('Nombre', _nombreCtrl)),
                const SizedBox(width: 10),
                Expanded(child: _input('Apellido', _apCtrl)),
              ]),
              const SizedBox(height: 14),
              _input('Email', _emailCtrl, type: TextInputType.emailAddress),
              const SizedBox(height: 14),
              GestureDetector(
                onTap: _pickDate,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  decoration: BoxDecoration(color: AppColors.white05, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.white10)),
                  child: Row(children: [
                    Expanded(child: Text(
                      _fechaNac != null ? '${_fechaNac!.day}/${_fechaNac!.month}/${_fechaNac!.year}' : 'Fecha de nacimiento',
                      style: GoogleFonts.barlow(color: _fechaNac != null ? Colors.white : AppColors.white30, fontSize: 16),
                    )),
                    const Icon(Icons.calendar_today_outlined, color: AppColors.white30, size: 18),
                  ]),
                ),
              ),
              const SizedBox(height: 14),
            ],
            _input('DNI', _dniCtrl, type: TextInputType.number, maxLen: 8),
            const SizedBox(height: 14),
            TextField(
              controller: _pwdCtrl, obscureText: !_showPwd,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Contrasena',
                suffixIcon: IconButton(
                  icon: Icon(_showPwd ? Icons.visibility_off : Icons.visibility, color: AppColors.white30),
                  onPressed: () => setState(() => _showPwd = !_showPwd),
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loading ? null : (_isLogin ? _doLogin : _doRegister),
              child: _loading
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : Text(_isLogin ? 'INGRESAR' : 'CREAR CUENTA',
                      style: GoogleFonts.barlowCondensed(fontSize: 18, fontWeight: FontWeight.w700, letterSpacing: 2)),
            ),
            const SizedBox(height: 12),
            // Google login
            GestureDetector(
              onTap: () => showDialog(context: context, builder: (ctx) => AlertDialog(
                backgroundColor: AppColors.navy2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                title: Row(children: [
                  const Icon(Icons.g_mobiledata, color: Colors.white, size: 22),
                  const SizedBox(width: 10),
                  Text('Ingresar con Google', style: GoogleFonts.barlowCondensed(fontSize: 18, color: Colors.white)),
                ]),
                content: Column(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.construction_outlined, color: AppColors.yellow, size: 48),
                  const SizedBox(height: 12),
                  Text('Próximamente', style: GoogleFonts.bebasNeue(fontSize: 24, color: AppColors.yellow, letterSpacing: 2)),
                  const SizedBox(height: 8),
                  Text('El inicio de sesión con Google estará disponible en la próxima actualización.',
                    style: GoogleFonts.barlow(fontSize: 13, color: AppColors.white30), textAlign: TextAlign.center),
                ]),
                actions: [TextButton(onPressed: () => Navigator.pop(ctx),
                  child: Text('Entendido', style: GoogleFonts.barlowCondensed(fontSize: 15, color: AppColors.blueBright)))],
              )),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 13),
                decoration: BoxDecoration(color: AppColors.white05, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.white10)),
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Icon(Icons.g_mobiledata, color: AppColors.white30, size: 22),
                  const SizedBox(width: 8),
                  Text('Ingresar con Google', style: GoogleFonts.barlowCondensed(fontSize: 15, color: AppColors.white30, letterSpacing: 0.5)),
                ]),
              ),
            ),
            if (_isLogin) ...[
              const SizedBox(height: 8),
              Center(child: TextButton(
                onPressed: () {},
                child: Text('Olvidaste tu contrasena?', style: GoogleFonts.barlowCondensed(color: AppColors.white30, letterSpacing: 1)),
              )),
              const SizedBox(height: 4),
              const Divider(color: AppColors.white10),
              const SizedBox(height: 8),
              // Crear torneo
              _accessBtn(
                label: 'Crear Torneo',
                icon: Icons.emoji_events_outlined,
                color: AppColors.blueBright,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SeleccionarFormatoScreen())),
              ),
              const SizedBox(height: 8),
              // Acceso fiscal
              _accessBtn(
                label: 'Acceso Fiscal',
                icon: Icons.shield_outlined,
                color: AppColors.yellow,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FiscalLoginScreen())),
              ),
            ],
          ]),
        )),
      ]),
    );
  }

  Widget _accessBtn({required String label, required IconData icon, required Color color, required VoidCallback onTap}) =>
    GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 13),
        decoration: BoxDecoration(
          color: color.withOpacity(0.06),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 8),
          Text(label, style: GoogleFonts.barlowCondensed(fontSize: 14, color: color, letterSpacing: 1)),
        ]),
      ),
    );

  Widget _tabBtn(String label, bool active, VoidCallback onTap) => Expanded(
    child: GestureDetector(onTap: onTap, child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(color: active ? AppColors.blue : Colors.transparent, borderRadius: BorderRadius.circular(8)),
      child: Text(label, textAlign: TextAlign.center,
        style: GoogleFonts.barlowCondensed(fontSize: 15, fontWeight: FontWeight.w600, letterSpacing: 1, color: active ? Colors.white : AppColors.white30)),
    )),
  );

  Widget _input(String label, TextEditingController ctrl, {TextInputType type = TextInputType.text, int? maxLen}) =>
    TextField(controller: ctrl, keyboardType: type, maxLength: maxLen, style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(labelText: label, counterText: ''));
}