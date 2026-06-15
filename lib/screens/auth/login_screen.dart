import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../theme/app_colors.dart';
import '../../painters/diagonal_bg_painter.dart';
import '../home/home_screen.dart';
import '../fiscal/fiscal_login_screen.dart';
import '../torneos/organizador_login_screen.dart';
import '../invitado/invitado_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  bool _isLogin = true;
  bool _loading = false;
  bool _showPwd = false;
  final _dniCtrl    = TextEditingController();
  final _pwdCtrl    = TextEditingController();
  final _nombreCtrl = TextEditingController();
  final _apCtrl     = TextEditingController();
  final _emailCtrl  = TextEditingController();
  DateTime? _fechaNac;

  // ── Gradiente animado ──
  late AnimationController _gradientCtrl;
  late Animation<double>   _gradientAnim;
  late AnimationController _fadeCtrl;
  late Animation<double>   _fadeAnim;
  late Animation<Offset>   _slideAnim;

  final List<List<Color>> _gradients = [
    [const Color(0xFF0A0E1A), const Color(0xFF0D1B3E)],
    [const Color(0xFF0D1B3E), const Color(0xFF0A1628)],
    [const Color(0xFF0A1628), const Color(0xFF111827)],
    [const Color(0xFF111827), const Color(0xFF0A0E1A)],
  ];
  int _gradientIdx = 0;

  @override
  void initState() {
    super.initState();
    _gradientCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 3));
    _gradientAnim = CurvedAnimation(parent: _gradientCtrl, curve: Curves.easeInOut);
    _gradientCtrl.addStatusListener((s) {
      if (s == AnimationStatus.completed) {
        setState(() => _gradientIdx = (_gradientIdx + 1) % _gradients.length);
        _gradientCtrl.forward(from: 0);
      }
    });
    _gradientCtrl.forward();

    _fadeCtrl  = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    _fadeAnim  = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero)
        .animate(CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut));
    _fadeCtrl.forward();

    _loadSavedDni();
  }

  @override
  void dispose() {
    _gradientCtrl.dispose(); _fadeCtrl.dispose();
    _dniCtrl.dispose(); _pwdCtrl.dispose(); _nombreCtrl.dispose();
    _apCtrl.dispose(); _emailCtrl.dispose();
    super.dispose();
  }

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
    final next = _gradients[(_gradientIdx + 1) % _gradients.length];
    final curr = _gradients[_gradientIdx];

    return Scaffold(
      body: Stack(children: [

        // Gradiente animado
        AnimatedBuilder(
          animation: _gradientAnim,
          builder: (_, __) {
            final t  = _gradientAnim.value;
            final c1 = Color.lerp(curr[0], next[0], t)!;
            final c2 = Color.lerp(curr[1], next[1], t)!;
            return Container(
              decoration: BoxDecoration(gradient: LinearGradient(
                begin: Alignment.topLeft, end: Alignment.bottomRight,
                colors: [c1, c2],
              )),
            );
          },
        ),

        CustomPaint(painter: DiagonalBgPainter(), child: Container()),

        // Acento azul arriba derecha
        Positioned(top: -60, right: -60,
          child: Container(width: 220, height: 220,
            decoration: BoxDecoration(shape: BoxShape.circle,
              gradient: RadialGradient(colors: [AppColors.blue.withOpacity(0.18), Colors.transparent])))),

        // Acento amarillo abajo izquierda
        Positioned(bottom: -80, left: -80,
          child: Container(width: 280, height: 280,
            decoration: BoxDecoration(shape: BoxShape.circle,
              gradient: RadialGradient(colors: [AppColors.yellow.withOpacity(0.07), Colors.transparent])))),

        // Contenido
        SafeArea(
          child: FadeTransition(
            opacity: _fadeAnim,
            child: SlideTransition(
              position: _slideAnim,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                  // Logo
                  ShaderMask(
                    shaderCallback: (b) => const LinearGradient(
                      colors: [Colors.white, AppColors.blueBright, AppColors.yellow],
                    ).createShader(b),
                    child: Text('PADEL BA', style: GoogleFonts.bebasNeue(fontSize: 48, letterSpacing: 4, color: Colors.white)),
                  ),
                  Text('Buenos Aires · Padel',
                    style: GoogleFonts.barlowCondensed(fontSize: 13, letterSpacing: 5, color: AppColors.white30)),
                  const SizedBox(height: 28),

                  // Tab
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
                  const SizedBox(height: 20),

                  // Campos registro
                  if (!_isLogin) ...[
                    Row(children: [
                      Expanded(child: _input('Nombre', _nombreCtrl)),
                      const SizedBox(width: 10),
                      Expanded(child: _input('Apellido', _apCtrl)),
                    ]),
                    const SizedBox(height: 12),
                    _input('Email', _emailCtrl, type: TextInputType.emailAddress),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: _pickDate,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(color: AppColors.white05, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.white10)),
                        child: Row(children: [
                          Expanded(child: Text(
                            _fechaNac != null ? '${_fechaNac!.day}/${_fechaNac!.month}/${_fechaNac!.year}' : 'Fecha de nacimiento',
                            style: GoogleFonts.barlow(color: _fechaNac != null ? Colors.white : AppColors.white30, fontSize: 15),
                          )),
                          const Icon(Icons.calendar_today_outlined, color: AppColors.white30, size: 16),
                        ]),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],

                  _input('DNI', _dniCtrl, type: TextInputType.number, maxLen: 8),
                  const SizedBox(height: 12),

                  TextField(
                    controller: _pwdCtrl, obscureText: !_showPwd,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      suffixIcon: IconButton(
                        icon: Icon(_showPwd ? Icons.visibility_off : Icons.visibility, color: AppColors.white30),
                        onPressed: () => setState(() => _showPwd = !_showPwd),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Botón principal
                  ElevatedButton(
                    onPressed: _loading ? null : (_isLogin ? _doLogin : _doRegister),
                    child: _loading
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : Text(_isLogin ? 'INGRESAR' : 'CREAR CUENTA',
                            style: GoogleFonts.barlowCondensed(fontSize: 18, fontWeight: FontWeight.w700, letterSpacing: 2)),
                  ),
                  const SizedBox(height: 10),

                  // Google — compacto con ícono de colores
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
                      padding: const EdgeInsets.symmetric(vertical: 9),
                      decoration: BoxDecoration(
                        color: AppColors.white05,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.white10),
                      ),
                      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        SizedBox(width: 18, height: 18, child: CustomPaint(painter: _GoogleIconPainter())),
                        const SizedBox(width: 8),
                        Text('Continuar con Google',
                          style: GoogleFonts.barlowCondensed(fontSize: 14, color: AppColors.white30, letterSpacing: 0.5)),
                      ]),
                    ),
                  ),

                  // Accesos rápidos — solo en login
                  if (_isLogin) ...[
                    const SizedBox(height: 6),
                    Center(child: TextButton(
                      onPressed: () {},
                      child: Text('¿Olvidaste tu contraseña?',
                        style: GoogleFonts.barlowCondensed(color: AppColors.white30, letterSpacing: 1, fontSize: 13)),
                    )),
                    const Divider(color: AppColors.white10, height: 8),
                    const SizedBox(height: 8),

                    // 1. Invitado — verde, prominente
                    _accessBtn(
                      label: 'Ingresar como Invitado',
                      icon: Icons.visibility_outlined,
                      color: AppColors.green,
                      onTap: () => Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (_) => const InvitadoScreen())),
                    ),
                    const SizedBox(height: 8),

                    // 2. Crear Torneo — azul
                    _accessBtn(
                      label: 'Crear Torneo',
                      icon: Icons.emoji_events_outlined,
                      color: AppColors.blueBright,
                      onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const OrganizadorLoginScreen())),
                    ),
                    const SizedBox(height: 8),

                    // 3. Acceso Fiscal — amarillo
                    _accessBtn(
                      label: 'Acceso Fiscal',
                      icon: Icons.shield_outlined,
                      color: AppColors.yellow,
                      onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const FiscalLoginScreen())),
                    ),
                    const SizedBox(height: 8),
                  ],
                ]),
              ),
            ),
          ),
        ),
      ]),
    );
  }

  // _accessBtn con borde más visible
  Widget _accessBtn({required String label, required IconData icon, required Color color, required VoidCallback onTap}) =>
    GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 11),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.55), width: 1.3),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon, color: color, size: 15),
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
        style: GoogleFonts.barlowCondensed(fontSize: 15, fontWeight: FontWeight.w600, letterSpacing: 1,
          color: active ? Colors.white : AppColors.white30)),
    )),
  );

  Widget _input(String label, TextEditingController ctrl, {TextInputType type = TextInputType.text, int? maxLen}) =>
    TextField(controller: ctrl, keyboardType: type, maxLength: maxLen, style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(labelText: label, counterText: ''));
}

// Ícono G multicolor de Google
class _GoogleIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r  = size.width / 2;
    final paint = Paint()..style = PaintingStyle.fill;
    paint.color = const Color(0xFFEA4335);
    canvas.drawArc(Rect.fromCircle(center: Offset(cx, cy), radius: r), -1.57, 1.57, true, paint);
    paint.color = const Color(0xFFFBBC05);
    canvas.drawArc(Rect.fromCircle(center: Offset(cx, cy), radius: r), 0, 1.57, true, paint);
    paint.color = const Color(0xFF34A853);
    canvas.drawArc(Rect.fromCircle(center: Offset(cx, cy), radius: r), 1.57, 1.57, true, paint);
    paint.color = const Color(0xFF4285F4);
    canvas.drawArc(Rect.fromCircle(center: Offset(cx, cy), radius: r), 3.14, 1.57, true, paint);
    paint.color = const Color(0xFF0A0E1A);
    canvas.drawCircle(Offset(cx, cy), r * 0.55, paint);
  }
  @override
  bool shouldRepaint(_) => false;
}