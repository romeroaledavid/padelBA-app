import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));
  await Supabase.initialize(
    url: 'https://hyqcreklktcxvvtqbfda.supabase.co',
    anonKey: 'sb_publishable_Sx-LDrvCO7hP3NtKcC3qgw_o6jymfMf',
  );
  runApp(const PadelBAApp());
}

// ===================== COLORS =====================
class AppColors {
  static const navy      = Color(0xFF050D1A);
  static const navy2     = Color(0xFF0A1628);
  static const navy3     = Color(0xFF0F1F38);
  static const blue      = Color(0xFF1565E8);
  static const blueBright= Color(0xFF2D7FFF);
  static const yellow    = Color(0xFFF5C518);
  static const green     = Color(0xFF22C55E);
  static const red       = Color(0xFFEF4444);
  static const white30   = Color(0x4DFFFFFF);
  static const white10   = Color(0x1AFFFFFF);
  static const white05   = Color(0x0DFFFFFF);

  static Color categoryColor(int cat) {
    switch (cat) {
      case 1: return const Color(0xFFFFD700);
      case 2: return const Color(0xFFFFF176);
      case 3: return const Color(0xFF2D7FFF);
      case 4: return const Color(0xFF22C55E);
      case 5: return const Color(0xFFFF7A00);
      case 6: return const Color(0xFFAB5CF7);
      case 7: return const Color(0xFFEF4444);
      case 8: return const Color(0xFF9CA3AF);
      default: return const Color(0xFF9CA3AF);
    }
  }
}

// ===================== APP =====================
class PadelBAApp extends StatelessWidget {
  const PadelBAApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Padel BA',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.navy,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.blue,
          secondary: AppColors.yellow,
          surface: AppColors.navy2,
        ),
        textTheme: GoogleFonts.barlowTextTheme(ThemeData.dark().textTheme),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.white05,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.white10)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.white10)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.blueBright, width: 2)),
          labelStyle: const TextStyle(color: AppColors.white30),
          hintStyle: const TextStyle(color: AppColors.white30),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.blue,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 52),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('es', 'AR')],
      locale: const Locale('es', 'AR'),
      home: const SplashScreen(),
    );
  }
}


// ===================== LOCALIDADES BA =====================
const List<String> kLocalidadesBA = [
  'Adolfo Alsina', 'Adolfo Gonzales Chaves', 'Aguas Verdes', 'Alberti',
  'Aldo Bonzi', 'Azul', 'Bahia Blanca', 'Balcarce', 'Baradero',
  'Berazategui', 'Berisso', 'Bernal', 'Bolivar', 'Bragado',
  'Buenos Aires (CABA)', 'Cañuelas', 'Castelar', 'Chacabuco',
  'Chascomus', 'Chivilcoy', 'Cipolletti', 'Colon', 'Coronel Dorrego',
  'Coronel Pringles', 'Coronel Rosales', 'Coronel Suarez',
  'Daireaux', 'Dolores', 'Don Torcuato', 'Ensenada',
  'Escobar', 'Esteban Echeverria', 'Ezeiza', 'Florencio Varela',
  'Florentino Ameghino', 'General Alvarado', 'General Alvear',
  'General Arenales', 'General Belgrano', 'General Guido',
  'General Juan Madariaga', 'General La Madrid', 'General Las Heras',
  'General Lavalle', 'General Paz', 'General Pinto', 'General Pueyrredon',
  'General Rodriguez', 'General Roca', 'General Sarmiento',
  'General Viamonte', 'General Villegas', 'Gonzalez Catan',
  'Guamini', 'Guernica', 'Haedo', 'Hipolito Yrigoyen',
  'Hurlingham', 'Ituzaingo', 'Jose C. Paz', 'Junin',
  'La Costa', 'La Matanza', 'La Plata', 'Lanús', 'Laprida',
  'Las Flores', 'Lavalle', 'Leandro N. Alem', 'Lincoln',
  'Loberia', 'Lobos', 'Lomas de Zamora', 'Lomas del Mirador',
  'Lujan', 'Magdalena', 'Maipu', 'Mar Chiquita', 'Mar de Ajo',
  'Mar de las Pampas', 'Mar del Plata', 'Mar del Tuyu',
  'Marcos Paz', 'Mercedes', 'Merlo', 'Monte', 'Monte Hermoso',
  'Moreno', 'Moron', 'Navarro', 'Necochea', 'Nueve de Julio',
  'Olavarria', 'Patagones', 'Pehuajo', 'Pellegrini', 'Pergamino',
  'Pila', 'Pilar', 'Pinamar', 'Presidente Peron', 'Puan',
  'Punta Indio', 'Quilmes', 'Ramallo', 'Rauch', 'Rivadavia',
  'Rojas', 'Roque Perez', 'Saavedra', 'Saladillo', 'Saliqllo',
  'Salto', 'San Andres de Giles', 'San Antonio de Areco',
  'San Cayetano', 'San Fernando', 'San Isidro', 'San Martin',
  'San Miguel', 'San Miguel del Monte', 'San Nicolas',
  'San Pedro', 'San Vicente', 'Santa Teresita', 'Suipacha',
  'Tandil', 'Tapalque', 'Tigre', 'Tordillo', 'Tornquist',
  'Trenque Lauquen', 'Tres Arroyos', 'Tres de Febrero',
  'Tres Lomas', 'Twenty-five de Mayo', 'Vicente Lopez',
  'Villa Ballester', 'Villa Gesell', 'Villarino', 'Zarate',
];

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
    // Always logout on app start - every user must login each time
    await Supabase.instance.client.auth.signOut();
    Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (_) => const LoginScreen(),
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

// ===================== LOGIN =====================
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
    if (_fechaNac == null) { _toast('Ingresa tu fecha de nacimiento', error: true); return; }
    if (pwd.length < 8 || !pwd.contains(RegExp(r'[A-Z]')) || !pwd.contains(RegExp(r'[0-9]'))) {
      _toast('Contrasena: 8+ caracteres, mayuscula y numero', error: true); return;
    }
    setState(() => _loading = true);
    try {
      final res = await Supabase.instance.client.auth.signUp(email: 'dni$dni@padelba.app', password: pwd);
      if (res.user != null) {
        final fechaStr = '${_fechaNac!.year}-${_fechaNac!.month.toString().padLeft(2,'0')}-${_fechaNac!.day.toString().padLeft(2,'0')}';
        await Supabase.instance.client.from('usuarios').upsert({
          'id': res.user!.id,
          'dni': dni,
          'nombre': nombre,
          'apellido': apellido,
          'email': email,
          'fecha_nacimiento': fechaStr,
          'rol': 'jugador',
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
                _tabBtn('Registrarse', !_isLogin, () => setState(() => _isLogin = false)),
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
                      _fechaNac != null
                          ? '${_fechaNac!.day}/${_fechaNac!.month}/${_fechaNac!.year}'
                          : 'Fecha de nacimiento',
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
            if (_isLogin) ...[
              const SizedBox(height: 16),
              Center(child: TextButton(
                onPressed: () {},
                child: Text('Olvidaste tu contrasena?', style: GoogleFonts.barlowCondensed(color: AppColors.white30, letterSpacing: 1)),
              )),
            ],
          ]),
        )),
      ]),
    );
  }

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

// ===================== HOME =====================
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _navIndex = 0;
  Map<String, dynamic>? _perfil;

  @override
  void initState() { super.initState(); _loadPerfil(); }

  Future<void> _loadPerfil() async {
    final uid = Supabase.instance.client.auth.currentUser?.id;
    if (uid == null) return;
    final data = await Supabase.instance.client.from('usuarios').select().eq('id', uid).single();
    if (mounted) setState(() => _perfil = data);
  }

  String get _firstName => (_perfil?['nombre'] as String? ?? 'JUGADOR').toUpperCase();
  String get _initials {
    final n = _perfil?['nombre'] as String? ?? '';
    final a = _perfil?['apellido'] as String? ?? '';
    if (n.isEmpty) return 'J';
    return '${n[0]}${a.isNotEmpty ? a[0] : ''}'.toUpperCase();
  }
  int get _categoria => (_perfil?['categoria'] as int?) ?? 0;
  int? get _catObs {
    final obs = _perfil?['categoria_observada'] as int?;
    return (obs != null && obs != _categoria) ? obs : null;
  }
  bool get _esFiscal => (_perfil?['rol'] as String?) == 'fiscal';

  @override
  Widget build(BuildContext context) {
    final screens = [
      _homeBody(),
      const Center(child: Text('Torneos - Proximamente', style: TextStyle(color: Colors.white))),
      PerfilScreen(perfil: _perfil, onSaved: _loadPerfil),
      const SizedBox(), // logout placeholder
    ];

    const navItems = [
      BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'INICIO'),
      BottomNavigationBarItem(icon: Icon(Icons.emoji_events_outlined), activeIcon: Icon(Icons.emoji_events), label: 'TORNEOS'),
      BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'PERFIL'),
      BottomNavigationBarItem(icon: Icon(Icons.logout), label: 'SALIR'),
    ];

    return Scaffold(
      body: Stack(children: [
        Container(decoration: const BoxDecoration(gradient: RadialGradient(
          center: Alignment(0, 1), radius: 1.5, colors: [Color(0x4D1565E8), AppColors.navy],
        ))),
        CustomPaint(painter: DiagonalBgPainter(), child: Container()),
        screens[_navIndex.clamp(0, screens.length - 1)],
      ]),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(border: Border(top: BorderSide(color: AppColors.white10))),
        child: BottomNavigationBar(
          currentIndex: _navIndex.clamp(0, navItems.length - 1),
          onTap: (i) async {
            if (i == 3) {
              await Supabase.instance.client.auth.signOut();
              if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
            } else {
              setState(() => _navIndex = i);
            }
          },
          backgroundColor: AppColors.navy2,
          selectedItemColor: AppColors.blueBright,
          unselectedItemColor: AppColors.white30,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: GoogleFonts.barlowCondensed(fontSize: 10, letterSpacing: 1),
          unselectedLabelStyle: GoogleFonts.barlowCondensed(fontSize: 10, letterSpacing: 1),
          items: navItems,
        ),
      ),
    );
  }

  void _goFiscal() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const FiscalLoginScreen()));
  }

  Widget _homeBody() => SafeArea(child: Column(children: [
    Padding(
      padding: const EdgeInsets.fromLTRB(28, 24, 28, 24),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('BIENVENIDO', style: GoogleFonts.barlowCondensed(fontSize: 13, letterSpacing: 3, color: AppColors.white30)),
          Text(_firstName, style: GoogleFonts.bebasNeue(fontSize: 32, letterSpacing: 2, color: Colors.white)),
        ]),
        GestureDetector(
          onTap: () => setState(() => _navIndex = 2),
          child: ProfileAvatar(fotoUrl: _perfil?['foto_url'] as String?, initials: _initials, categoria: _categoria, categoriaObservada: _catObs, radius: 24),
        ),
      ]),
    ),
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Container(
        height: 140,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(colors: [AppColors.blue, AppColors.navy3], begin: Alignment.topLeft, end: Alignment.bottomRight),
          border: Border.all(color: AppColors.white10),
        ),
        padding: const EdgeInsets.all(20),
        child: Stack(children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.end, children: [
            Text('PROXIMO TORNEO', style: GoogleFonts.barlowCondensed(fontSize: 11, letterSpacing: 4, color: AppColors.yellow)),
            Text('Open de Invierno', style: GoogleFonts.bebasNeue(fontSize: 26, letterSpacing: 2, color: Colors.white)),
            Text('15 Jun - Club Palermo - 8 grupos', style: GoogleFonts.barlow(fontSize: 12, color: AppColors.white30)),
          ]),
          Positioned(top: 0, right: 0, child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: AppColors.yellow, borderRadius: BorderRadius.circular(6)),
            child: Text('INSCRIBITE', style: GoogleFonts.barlowCondensed(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.navy)),
          )),
        ]),
      ),
    ),
    const SizedBox(height: 28),
    Padding(padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Align(alignment: Alignment.centerLeft,
        child: Text('MENU', style: GoogleFonts.barlowCondensed(fontSize: 12, letterSpacing: 4, color: AppColors.white30)))),
    const SizedBox(height: 14),
    Expanded(child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.count(
        crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _menuCard('Torneos', 'Ver y crear', Icons.emoji_events_outlined, AppColors.blue, () => setState(() => _navIndex = 1)),
          _menuCard('Jugadores', 'Gestionar', Icons.sports_tennis, AppColors.yellow, () {}),
          _menuCard('Ranking', 'Posiciones', Icons.leaderboard_outlined, AppColors.blue, () {}),
          _menuCard('Clubes', 'Canchas y sedes', Icons.location_on_outlined, AppColors.blueBright, () {}),
        ],
      ),
    )),
    _fiscalAccessBtn(),
    const SizedBox(height: 8),
  ]));

  Widget _fiscalAccessBtn() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: GestureDetector(
      onTap: _goFiscal,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.yellow.withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.yellow.withOpacity(0.25)),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(Icons.admin_panel_settings_outlined, color: AppColors.yellow, size: 16),
          const SizedBox(width: 8),
          Text('Acceso Fiscal', style: GoogleFonts.barlowCondensed(fontSize: 13, color: AppColors.yellow, letterSpacing: 1)),
        ]),
      ),
    ),
  );

  Widget _menuCard(String title, String sub, IconData icon, Color color, VoidCallback onTap) =>
    GestureDetector(onTap: onTap, child: Container(
      decoration: BoxDecoration(color: AppColors.white05, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.white10)),
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(width: 46, height: 46,
          decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: color, size: 26)),
        const Spacer(),
        Text(title, style: GoogleFonts.bebasNeue(fontSize: 20, letterSpacing: 1, color: Colors.white)),
        Text(sub, style: GoogleFonts.barlow(fontSize: 11, color: AppColors.white30)),
      ]),
    ));
}

// ===================== PERFIL =====================
class PerfilScreen extends StatefulWidget {
  final Map<String, dynamic>? perfil;
  final VoidCallback onSaved;
  const PerfilScreen({super.key, required this.perfil, required this.onSaved});
  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  final _nombreCtrl    = TextEditingController();
  final _apellidoCtrl  = TextEditingController();
  final _emailCtrl     = TextEditingController();
  final _residenciaCtrl= TextEditingController();
  final _clubesCtrl    = TextEditingController();
  String _ladoCancha     = '';
  String _manoHabil      = '';
  List<String> _selectedClubes = [];
  String? _fotoUrl;
  bool _loading          = false;
  bool _uploading        = false;

  @override
  void initState() { super.initState(); _loadData(); }

  void _loadData() {
    final p = widget.perfil;
    if (p == null) return;
    _nombreCtrl.text     = p['nombre'] ?? '';
    _apellidoCtrl.text   = p['apellido'] ?? '';
    _emailCtrl.text      = p['email'] ?? '';
    _residenciaCtrl.text = p['residencia'] ?? '';
    _clubesCtrl.text     = p['clubes'] ?? '';
    _ladoCancha          = p['lado_cancha'] ?? '';
    _manoHabil           = p['mano_habil'] ?? '';
    final rawClubes = p['clubes_ids'];
    if (rawClubes != null) {
      _selectedClubes = List<String>.from(rawClubes);
    }
  }

  @override
  void didUpdateWidget(PerfilScreen old) { super.didUpdateWidget(old); if (widget.perfil != old.perfil) _loadData(); }

  @override
  void dispose() { _nombreCtrl.dispose(); _apellidoCtrl.dispose(); _emailCtrl.dispose(); _residenciaCtrl.dispose(); _clubesCtrl.dispose(); super.dispose(); }

  int _calcEdad(String? fecha) {
    if (fecha == null || fecha.isEmpty) return 0;
    try {
      final nac = DateTime.parse(fecha);
      final hoy = DateTime.now();
      int edad = hoy.year - nac.year;
      if (hoy.month < nac.month || (hoy.month == nac.month && hoy.day < nac.day)) edad--;
      return edad;
    } catch (_) { return 0; }
  }

  Future<void> _pickFoto() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
      maxWidth: 800,
      maxHeight: 800,
    );
    if (picked == null) return;
    final uid = Supabase.instance.client.auth.currentUser?.id;
    if (uid == null) return;
    setState(() => _uploading = true);
    try {
      final file = File(picked.path);
      final ext = picked.path.split('.').last;
      final finalPath = 'avatars/$uid.$ext';
      await Supabase.instance.client.storage.from('avatars').upload(
        finalPath, file, fileOptions: const FileOptions(upsert: true));
      final url = Supabase.instance.client.storage.from('avatars').getPublicUrl(finalPath);
      await Supabase.instance.client.from('usuarios').update({'foto_url': url}).eq('id', uid);
      setState(() => _fotoUrl = '$url?t=${DateTime.now().millisecondsSinceEpoch}');
      widget.onSaved();
      _toast('Foto actualizada!');
    } catch (e) {
      _toast('Error al subir foto: $e', error: true);
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  Future<void> _guardar() async {
    final uid = Supabase.instance.client.auth.currentUser?.id;
    if (uid == null) return;
    setState(() => _loading = true);
    try {
      await Supabase.instance.client.from('usuarios').update({
        'nombre': _nombreCtrl.text.trim(),
        'apellido': _apellidoCtrl.text.trim(),
        'email': _emailCtrl.text.trim(),
        'residencia': _residenciaCtrl.text.trim(),
        'clubes': _clubesCtrl.text.trim(),
        'lado_cancha': _ladoCancha.isNotEmpty ? _ladoCancha : null,
        'mano_habil': _manoHabil.isNotEmpty ? _manoHabil : null,
        'clubes_ids': _selectedClubes.isNotEmpty ? _selectedClubes : null,
      }).eq('id', uid);
      // Navigate back to home after saving
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Perfil guardado!', style: GoogleFonts.barlowCondensed(fontSize: 15)),
          backgroundColor: AppColors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          duration: const Duration(seconds: 2),
        ));
      }
      widget.onSaved();
      if (mounted) {
        _toast('Perfil guardado!');
        await Future.delayed(const Duration(milliseconds: 800));
        // Navigate to home tab (index 0)
        if (mounted) {
          final homeState = context.findAncestorStateOfType<_HomeScreenState>();
          homeState?.setState(() => homeState._navIndex = 0);
        }
      }
    } catch (e) {
      _toast('Error al guardar: $e', error: true);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _toast(String msg, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg, style: GoogleFonts.barlowCondensed(fontSize: 15)),
      backgroundColor: error ? AppColors.red : AppColors.green,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.perfil;
    final nombre   = p?['nombre'] as String? ?? '';
    final apellido = p?['apellido'] as String? ?? '';
    final dni      = p?['dni'] as String? ?? '';
    final fecha    = p?['fecha_nacimiento'] as String? ?? '';
    final edad     = _calcEdad(fecha);
    final categoria= (p?['categoria'] as int?) ?? 0;
    final catObs   = p?['categoria_observada'] as int?;
    final initials = nombre.isNotEmpty ? '${nombre[0]}${apellido.isNotEmpty ? apellido[0] : ''}'.toUpperCase() : 'J';

    return SafeArea(child: SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(height: 8),
        Text('MI PERFIL', style: GoogleFonts.bebasNeue(fontSize: 32, letterSpacing: 2, color: Colors.white)),
        Text('Tu informacion personal', style: GoogleFonts.barlowCondensed(fontSize: 12, letterSpacing: 3, color: AppColors.white30)),
        const SizedBox(height: 28),

        // Avatar con foto
        Center(child: Column(children: [
          Stack(children: [
            ProfileAvatar(fotoUrl: _fotoUrl ?? p?['foto_url'] as String?, initials: initials, categoria: categoria,
              categoriaObservada: catObs != null && catObs != categoria ? catObs : null, radius: 50),
            Positioned(bottom: 0, right: 0,
              child: GestureDetector(
                onTap: _pickFoto,
                child: Container(
                  width: 30, height: 30,
                  decoration: BoxDecoration(
                    color: AppColors.blue,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.navy, width: 2),
                  ),
                  child: const Icon(Icons.camera_alt, color: Colors.white, size: 15),
                ),
              ),
            ),
          ]),
          const SizedBox(height: 12),
          Text(
            _nombreCtrl.text.isNotEmpty ? '${_nombreCtrl.text} ${_apellidoCtrl.text}'.trim() : 'Tu nombre',
            style: GoogleFonts.bebasNeue(fontSize: 24, letterSpacing: 1, color: Colors.white)),
          if (edad > 0)
            Text('$edad anos', style: GoogleFonts.barlowCondensed(fontSize: 14, color: AppColors.blueBright, letterSpacing: 1)),
        ])),
        const SizedBox(height: 28),

        // DNI y fecha NO editables
        _sectionTitle('DATOS FIJOS'),
        const SizedBox(height: 4),
        Text('DNI y fecha de nacimiento no pueden modificarse', style: GoogleFonts.barlow(fontSize: 11, color: AppColors.white30)),
        const SizedBox(height: 12),
        _infoTile(Icons.badge_outlined, 'DNI', dni),
        const SizedBox(height: 8),
        _infoTile(Icons.cake_outlined, 'Fecha de nacimiento', fecha.isNotEmpty ? fecha : 'No registrada'),
        const SizedBox(height: 20),
        // Nombre y apellido SÍ editables
        _sectionTitle('DATOS PERSONALES'),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(child: TextField(controller: _nombreCtrl, style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(labelText: 'Nombre'))),
          const SizedBox(width: 10),
          Expanded(child: TextField(controller: _apellidoCtrl, style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(labelText: 'Apellido'))),
        ]),
        const SizedBox(height: 28),

        // Categoria (solo lectura, la asigna el Fiscal)
        _sectionTitle('CATEGORIA'),
        const SizedBox(height: 4),
        Text('Asignada por el Fiscal', style: GoogleFonts.barlow(fontSize: 11, color: AppColors.white30)),
        const SizedBox(height: 12),
        if (categoria > 0) ...[
          Row(children: [
            Container(
              width: 48, height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.categoryColor(categoria).withOpacity(0.15),
                border: Border.all(color: AppColors.categoryColor(categoria), width: 2),
              ),
              child: Center(child: Text('${categoria}a',
                style: GoogleFonts.bebasNeue(fontSize: 16, color: AppColors.categoryColor(categoria)))),
            ),
            const SizedBox(width: 12),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Categoria ${categoria}a', style: GoogleFonts.barlowCondensed(fontSize: 16, color: Colors.white, letterSpacing: 0.5)),
              if (catObs != null && catObs != categoria)
                Row(children: [
                  const Icon(Icons.trending_up, color: AppColors.yellow, size: 14),
                  const SizedBox(width: 4),
                  Text('En observacion para ${catObs}a',
                    style: GoogleFonts.barlowCondensed(fontSize: 13, color: AppColors.yellow, letterSpacing: 0.5)),
                ]),
            ]),
          ]),
        ] else
          _infoTile(Icons.sports_tennis, 'Categoria', 'Pendiente de asignacion'),
        const SizedBox(height: 28),

        // Datos editables
        _sectionTitle('DATOS DE JUEGO'),
        const SizedBox(height: 12),
        TextField(controller: _emailCtrl, keyboardType: TextInputType.emailAddress,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(labelText: 'Email')),
        const SizedBox(height: 14),
        _LocalidadAutocomplete(
          controller: _residenciaCtrl,
          label: 'Localidad de residencia',
        ),
        const SizedBox(height: 16),
        _chipLabel('Lado de cancha'),
        const SizedBox(height: 8),
        Wrap(spacing: 8, children: [
          _chip('Drive', _ladoCancha == 'drive', () => setState(() => _ladoCancha = 'drive')),
          _chip('Reves', _ladoCancha == 'reves', () => setState(() => _ladoCancha = 'reves')),
          _chip('Ambos', _ladoCancha == 'ambos', () => setState(() => _ladoCancha = 'ambos')),
        ]),
        const SizedBox(height: 16),
        _chipLabel('Mano habil'),
        const SizedBox(height: 8),
        Wrap(spacing: 8, children: [
          _chip('Derecha', _manoHabil == 'derecha', () => setState(() => _manoHabil = 'derecha')),
          _chip('Zurda', _manoHabil == 'zurda', () => setState(() => _manoHabil = 'zurda')),
        ]),
        const SizedBox(height: 16),
        _ClubesSelector(
          selectedClubes: _selectedClubes,
          onChanged: (list) => setState(() => _selectedClubes = list),
        ),
        const SizedBox(height: 28),

        // Estadisticas
        _sectionTitle('ESTADISTICAS'),
        const SizedBox(height: 12),
        Row(children: [
          _statCard('0', 'Torneos'),
          const SizedBox(width: 10),
          _statCard('0', 'Victorias'),
          const SizedBox(width: 10),
          _statCard('—', 'Ranking'),
        ]),
        const SizedBox(height: 28),

        ElevatedButton(
          onPressed: _loading ? null : _guardar,
          child: _loading
              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
              : Text('GUARDAR', style: GoogleFonts.barlowCondensed(fontSize: 18, fontWeight: FontWeight.w700, letterSpacing: 2)),
        ),
        const SizedBox(height: 16),
      ]),
    ));
  }

  Widget _sectionTitle(String t) => Text(t,
    style: GoogleFonts.barlowCondensed(fontSize: 11, letterSpacing: 3, color: AppColors.blueBright));

  Widget _chipLabel(String t) => Text(t,
    style: GoogleFonts.barlowCondensed(fontSize: 12, letterSpacing: 1, color: AppColors.white30));

  Widget _infoTile(IconData icon, String label, String value) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    decoration: BoxDecoration(color: AppColors.white05, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.white10)),
    child: Row(children: [
      Icon(icon, color: AppColors.white30, size: 18),
      const SizedBox(width: 12),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: GoogleFonts.barlowCondensed(fontSize: 11, color: AppColors.white30, letterSpacing: 1)),
        Text(value, style: GoogleFonts.barlow(fontSize: 15, color: Colors.white)),
      ]),
    ]),
  );

  Widget _chip(String label, bool active, VoidCallback onTap) => GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: active ? AppColors.blue.withOpacity(0.2) : AppColors.white05,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: active ? AppColors.blueBright : AppColors.white10, width: active ? 2 : 1),
      ),
      child: Text(label, style: GoogleFonts.barlowCondensed(fontSize: 14, fontWeight: FontWeight.w600,
        color: active ? Colors.white : AppColors.white30)),
    ),
  );

  Widget _statCard(String value, String label) => Expanded(child: Container(
    padding: const EdgeInsets.symmetric(vertical: 16),
    decoration: BoxDecoration(color: AppColors.white05, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.white10)),
    child: Column(children: [
      Text(value, style: GoogleFonts.bebasNeue(fontSize: 28, color: Colors.white)),
      Text(label, style: GoogleFonts.barlowCondensed(fontSize: 11, color: AppColors.white30, letterSpacing: 1)),
    ]),
  ));
}



// ===================== LOCALIDAD AUTOCOMPLETE =====================
class _LocalidadAutocomplete extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  const _LocalidadAutocomplete({required this.controller, required this.label});
  @override
  State<_LocalidadAutocomplete> createState() => _LocalidadAutocompleteState();
}

class _LocalidadAutocompleteState extends State<_LocalidadAutocomplete> {
  List<String> _suggestions = [];
  bool _showSuggestions = false;

  void _onChanged(String val) {
    if (val.length < 2) {
      setState(() { _suggestions = []; _showSuggestions = false; });
      return;
    }
    final q = val.toLowerCase();
    final matches = kLocalidadesBA.where((l) => l.toLowerCase().contains(q)).take(6).toList();
    setState(() { _suggestions = matches; _showSuggestions = matches.isNotEmpty; });
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      TextField(
        controller: widget.controller,
        style: const TextStyle(color: Colors.white),
        onChanged: _onChanged,
        decoration: InputDecoration(
          labelText: widget.label,
          prefixIcon: const Icon(Icons.location_on_outlined, color: AppColors.white30),
          suffixIcon: widget.controller.text.isNotEmpty
              ? IconButton(icon: const Icon(Icons.clear, color: AppColors.white30, size: 18),
                  onPressed: () { widget.controller.clear(); setState(() { _suggestions = []; _showSuggestions = false; }); })
              : null,
        ),
      ),
      if (_showSuggestions)
        Container(
          margin: const EdgeInsets.only(top: 4),
          decoration: BoxDecoration(
            color: AppColors.navy3,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.white10),
          ),
          child: Column(
            children: _suggestions.map((s) => InkWell(
              onTap: () {
                widget.controller.text = s;
                setState(() { _suggestions = []; _showSuggestions = false; });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(children: [
                  const Icon(Icons.location_city_outlined, color: AppColors.white30, size: 16),
                  const SizedBox(width: 10),
                  Text(s, style: GoogleFonts.barlow(fontSize: 14, color: Colors.white)),
                ]),
              ),
            )).toList(),
          ),
        ),
    ]);
  }
}

// ===================== CLUBES SELECTOR =====================
class _ClubesSelector extends StatefulWidget {
  final List<String> selectedClubes;
  final ValueChanged<List<String>> onChanged;
  const _ClubesSelector({required this.selectedClubes, required this.onChanged});
  @override
  State<_ClubesSelector> createState() => _ClubesSelectorState();
}

class _ClubesSelectorState extends State<_ClubesSelector> {
  List<Map<String, dynamic>> _clubes = [];
  bool _loading = true;
  bool _showDropdown = false;
  final _searchCtrl = TextEditingController();
  List<Map<String, dynamic>> _filtered = [];

  @override
  void initState() { super.initState(); _loadClubes(); }

  @override
  void dispose() { _searchCtrl.dispose(); super.dispose(); }

  Future<void> _loadClubes() async {
    try {
      final res = await Supabase.instance.client.from('clubes').select().eq('activo', true).order('nombre');
      if (mounted) setState(() {
        _clubes = List<Map<String, dynamic>>.from(res);
        _filtered = _clubes;
        _loading = false;
      });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _onSearch(String val) {
    setState(() {
      _filtered = val.isEmpty
          ? _clubes
          : _clubes.where((c) => (c['nombre'] as String).toLowerCase().contains(val.toLowerCase()) ||
              ((c['localidad'] as String? ?? '').toLowerCase().contains(val.toLowerCase()))).toList();
    });
  }

  void _select(Map<String, dynamic> club) {
    final id = club['id'] as String;
    final list = List<String>.from(widget.selectedClubes);
    if (!list.contains(id)) list.add(id);
    widget.onChanged(list);
    setState(() { _showDropdown = false; _searchCtrl.clear(); _filtered = _clubes; });
  }

  void _remove(String id) {
    final list = List<String>.from(widget.selectedClubes);
    list.remove(id);
    widget.onChanged(list);
  }

  String _nombreById(String id) {
    final c = _clubes.firstWhere((c) => c['id'] == id, orElse: () => {});
    if (c.isEmpty) return id;
    final loc = c['localidad'] as String? ?? '';
    return loc.isNotEmpty ? '${c['nombre']} · $loc' : c['nombre'] as String;
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Clubes donde juego', style: GoogleFonts.barlowCondensed(fontSize: 12, letterSpacing: 1, color: AppColors.white30)),
      const SizedBox(height: 8),
      // Selected clubs as chips
      if (widget.selectedClubes.isNotEmpty)
        Wrap(spacing: 8, runSpacing: 8, children: widget.selectedClubes.map((id) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.blue.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.blueBright, width: 1.5),
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.sports_tennis, color: AppColors.blueBright, size: 13),
            const SizedBox(width: 6),
            Text(_nombreById(id), style: GoogleFonts.barlowCondensed(fontSize: 13, color: Colors.white)),
            const SizedBox(width: 6),
            GestureDetector(onTap: () => _remove(id),
              child: const Icon(Icons.close, color: AppColors.white30, size: 14)),
          ]),
        )).toList()),
      const SizedBox(height: 8),
      // Add club button
      GestureDetector(
        onTap: () => setState(() => _showDropdown = !_showDropdown),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          decoration: BoxDecoration(
            color: AppColors.white05,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _showDropdown ? AppColors.blueBright : AppColors.white10),
          ),
          child: Row(children: [
            const Icon(Icons.add_circle_outline, color: AppColors.white30, size: 18),
            const SizedBox(width: 10),
            Text('Agregar club', style: GoogleFonts.barlow(fontSize: 15, color: AppColors.white30)),
            const Spacer(),
            Icon(_showDropdown ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: AppColors.white30, size: 18),
          ]),
        ),
      ),
      if (_showDropdown) ...[
        const SizedBox(height: 4),
        Container(
          decoration: BoxDecoration(
            color: AppColors.navy3,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.white10),
          ),
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: TextField(
                controller: _searchCtrl,
                onChanged: _onSearch,
                autofocus: true,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Buscar club...',
                  hintStyle: const TextStyle(color: AppColors.white30, fontSize: 14),
                  prefixIcon: const Icon(Icons.search, color: AppColors.white30, size: 18),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  filled: true, fillColor: AppColors.white05,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                ),
              ),
            ),
            if (_loading)
              const Padding(padding: EdgeInsets.all(16), child: CircularProgressIndicator(color: AppColors.blueBright, strokeWidth: 2))
            else
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 200),
                child: ListView(shrinkWrap: true, children: _filtered.where((c) => !widget.selectedClubes.contains(c['id'])).map((c) {
                  final localidad = c['localidad'] as String? ?? '';
                  return InkWell(
                    onTap: () => _select(c),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(children: [
                        const Icon(Icons.sports_tennis_outlined, color: AppColors.white30, size: 16),
                        const SizedBox(width: 10),
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(c['nombre'] as String, style: GoogleFonts.barlowCondensed(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
                          if (localidad.isNotEmpty)
                            Text(localidad, style: GoogleFonts.barlow(fontSize: 12, color: AppColors.white30)),
                        ])),
                        const Icon(Icons.add, color: AppColors.blueBright, size: 16),
                      ]),
                    ),
                  );
                }).toList()),
              ),
          ]),
        ),
      ],
    ]);
  }
}

// ===================== FISCAL LOGIN =====================
// Authorized DNIs that can access fiscal panel
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
      if (mounted) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const FiscalScreen(onUpdate: _noOp)));
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
class FiscalScreen extends StatefulWidget {
  final VoidCallback onUpdate;
  const FiscalScreen({super.key, required this.onUpdate});
  @override
  State<FiscalScreen> createState() => _FiscalScreenState();
}

class _FiscalScreenState extends State<FiscalScreen> with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;
  // Search state
  final _buscarCtrl = TextEditingController();
  String _filtroMano = '';
  String _filtroLado = '';
  int _filtroCat = 0;
  List<Map<String, dynamic>> _resultados = [];
  bool _buscando = false;
  Map<String, dynamic>? _jugadorSel;
  int _nuevaCat = 0;
  int _catObs   = 0;
  bool _guardando = false;
  // Fiscal profile
  Map<String, dynamic>? _fiscalPerfil;
  // Torneo state
  final _tornNombreCtrl = TextEditingController();
  final _tornClubCtrl   = TextEditingController();
  final _tornFechaCtrl  = TextEditingController();
  String _tornFormato   = 'grupos';
  List<int> _tornCats   = [];
  int _tornCanchas      = 2;
  bool _creandoTorneo   = false;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
    _loadFiscalPerfil();
  }

  Future<void> _loadFiscalPerfil() async {
    final uid = Supabase.instance.client.auth.currentUser?.id;
    if (uid == null) return;
    final data = await Supabase.instance.client.from('usuarios').select().eq('id', uid).single();
    if (mounted) setState(() => _fiscalPerfil = data);
  }

  Future<void> _buscar() async {
    final q = _buscarCtrl.text.trim();
    setState(() { _buscando = true; _resultados = []; _jugadorSel = null; });
    try {
      var query = Supabase.instance.client.from('usuarios').select();
      if (RegExp(r'^\d{4,8}$').hasMatch(q)) {
        query = query.ilike('dni', '%$q%') as dynamic;
      } else if (q.isNotEmpty) {
        query = query.or('nombre.ilike.%$q%,apellido.ilike.%$q%') as dynamic;
      }
      if (_filtroMano.isNotEmpty) query = query.eq('mano_habil', _filtroMano) as dynamic;
      if (_filtroLado.isNotEmpty) query = query.eq('lado_cancha', _filtroLado) as dynamic;
      if (_filtroCat > 0) query = query.eq('categoria', _filtroCat) as dynamic;
      final res = await query.order('nombre').limit(20);
      if (mounted) setState(() => _resultados = List<Map<String, dynamic>>.from(res));
    } catch (e) {
      _toast('Error al buscar: $e', error: true);
    } finally {
      if (mounted) setState(() => _buscando = false);
    }
  }

  void _selJugador(Map<String, dynamic> j) {
    setState(() {
      _jugadorSel = j;
      _nuevaCat = (j['categoria'] as int?) ?? 0;
      _catObs   = (j['categoria_observada'] as int?) ?? 0;
    });
  }

  Future<void> _guardarCategoria() async {
    if (_jugadorSel == null) return;
    setState(() => _guardando = true);
    try {
      await Supabase.instance.client.from('usuarios').update({
        'categoria': _nuevaCat > 0 ? _nuevaCat : null,
        'categoria_observada': _catObs > 0 ? _catObs : null,
      }).eq('id', _jugadorSel!['id']);
      _toast('Categoria actualizada!');
      widget.onUpdate();
      _buscar();
      setState(() => _jugadorSel = null);
    } catch (e) {
      _toast('Error: $e', error: true);
    } finally {
      if (mounted) setState(() => _guardando = false);
    }
  }

  Future<void> _crearTorneo() async {
    if (_tornNombreCtrl.text.trim().isEmpty) { _toast('Ingresa el nombre del torneo', error: true); return; }
    if (_tornFechaCtrl.text.trim().isEmpty)  { _toast('Ingresa la fecha del torneo', error: true); return; }
    setState(() => _creandoTorneo = true);
    try {
      final uid = Supabase.instance.client.auth.currentUser?.id;
      await Supabase.instance.client.from('torneos').insert({
        'nombre': _tornNombreCtrl.text.trim(),
        'club': _tornClubCtrl.text.trim(),
        'fecha': _tornFechaCtrl.text.trim(),
        'formato': _tornFormato,
        'categorias': _tornCats.isNotEmpty ? _tornCats : null,
        'canchas': _tornCanchas,
        'creado_por': uid,
        'estado': 'pendiente',
      });
      _toast('Torneo creado!');
      _tornNombreCtrl.clear(); _tornClubCtrl.clear(); _tornFechaCtrl.clear();
      setState(() { _tornCats = []; _tornFormato = 'grupos'; _tornCanchas = 2; });
    } catch (e) {
      _toast('Error al crear torneo: $e', error: true);
    } finally {
      if (mounted) setState(() => _creandoTorneo = false);
    }
  }

  Future<void> _pickFecha() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
      builder: (ctx, child) => Theme(
        data: ThemeData.dark().copyWith(colorScheme: const ColorScheme.dark(primary: AppColors.blue, surface: AppColors.navy2)),
        child: child!,
      ),
    );
    if (picked != null) {
      _tornFechaCtrl.text = '${picked.year}-${picked.month.toString().padLeft(2,'0')}-${picked.day.toString().padLeft(2,'0')}';
    }
  }

  void _toast(String msg, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg, style: GoogleFonts.barlowCondensed(fontSize: 15)),
      backgroundColor: error ? AppColors.red : AppColors.green,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }

  @override
  void dispose() {
    _tabCtrl.dispose(); _buscarCtrl.dispose();
    _tornNombreCtrl.dispose(); _tornClubCtrl.dispose(); _tornFechaCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fiscalNombre = _fiscalPerfil?['nombre'] as String? ?? 'Fiscal';
    final fiscalAp     = _fiscalPerfil?['apellido'] as String? ?? '';
    final fiscalFoto   = _fiscalPerfil?['foto_url'] as String?;
    final fiscalInitials = fiscalNombre.isNotEmpty ? '${fiscalNombre[0]}${fiscalAp.isNotEmpty ? fiscalAp[0] : ''}'.toUpperCase() : 'F';

    return Scaffold(
      body: Stack(children: [
        Container(decoration: const BoxDecoration(gradient: LinearGradient(
          begin: Alignment.topCenter, end: Alignment.bottomCenter,
          colors: [AppColors.navy, AppColors.navy2],
        ))),
        CustomPaint(painter: DiagonalBgPainter(), child: Container()),
        SafeArea(child: Column(children: [
          // Header fiscal
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Row(children: [
              ProfileAvatar(fotoUrl: fiscalFoto, initials: fiscalInitials, categoria: 0, radius: 22),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('PANEL FISCAL', style: GoogleFonts.bebasNeue(fontSize: 24, letterSpacing: 2, color: Colors.white)),
                Text('$fiscalNombre $fiscalAp'.trim(),
                  style: GoogleFonts.barlowCondensed(fontSize: 13, color: AppColors.yellow, letterSpacing: 1)),
              ])),
              TextButton.icon(
                onPressed: () async {
                  await Supabase.instance.client.auth.signOut();
                  if (context.mounted) Navigator.pushAndRemoveUntil(context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()), (_) => false);
                },
                icon: const Icon(Icons.logout, color: AppColors.white30, size: 16),
                label: Text('Salir', style: GoogleFonts.barlowCondensed(color: AppColors.white30, fontSize: 13)),
              ),
            ]),
          ),
          // Tabs
          TabBar(
            controller: _tabCtrl,
            indicatorColor: AppColors.yellow,
            labelColor: AppColors.yellow,
            unselectedLabelColor: AppColors.white30,
            labelStyle: GoogleFonts.barlowCondensed(fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 1),
            tabs: const [
              Tab(text: 'JUGADORES'),
              Tab(text: 'CREAR TORNEO'),
            ],
          ),
          Expanded(child: TabBarView(controller: _tabCtrl, children: [
            _tabJugadores(),
            _tabCrearTorneo(),
          ])),
        ])),
      ]),
    );
  }

  Widget _tabJugadores() => SingleChildScrollView(
    padding: const EdgeInsets.all(20),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // Buscador
      TextField(
        controller: _buscarCtrl,
        style: const TextStyle(color: Colors.white),
        onChanged: (_) => _buscar(),
        decoration: InputDecoration(
          labelText: 'Buscar por nombre, apellido o DNI',
          prefixIcon: const Icon(Icons.search, color: AppColors.white30),
          suffixIcon: _buscarCtrl.text.isNotEmpty
              ? IconButton(icon: const Icon(Icons.clear, color: AppColors.white30), onPressed: () { _buscarCtrl.clear(); _buscar(); })
              : null,
        ),
      ),
      const SizedBox(height: 14),
      // Filtros
      Text('FILTROS', style: GoogleFonts.barlowCondensed(fontSize: 11, letterSpacing: 3, color: AppColors.blueBright)),
      const SizedBox(height: 8),
      SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: [
        _filtroChip('Derecha', _filtroMano == 'derecha', () => setState(() { _filtroMano = _filtroMano == 'derecha' ? '' : 'derecha'; _buscar(); })),
        const SizedBox(width: 6),
        _filtroChip('Zurda', _filtroMano == 'zurda', () => setState(() { _filtroMano = _filtroMano == 'zurda' ? '' : 'zurda'; _buscar(); })),
        const SizedBox(width: 6),
        _filtroChip('Drive', _filtroLado == 'drive', () => setState(() { _filtroLado = _filtroLado == 'drive' ? '' : 'drive'; _buscar(); })),
        const SizedBox(width: 6),
        _filtroChip('Reves', _filtroLado == 'reves', () => setState(() { _filtroLado = _filtroLado == 'reves' ? '' : 'reves'; _buscar(); })),
        const SizedBox(width: 6),
        _filtroChip('Ambos', _filtroLado == 'ambos', () => setState(() { _filtroLado = _filtroLado == 'ambos' ? '' : 'ambos'; _buscar(); })),
        const SizedBox(width: 6),
        ...List.generate(8, (i) {
          final cat = i + 1;
          return Padding(
            padding: const EdgeInsets.only(right: 6),
            child: _filtroChip('${cat}a', _filtroCat == cat,
              () => setState(() { _filtroCat = _filtroCat == cat ? 0 : cat; _buscar(); }),
              color: AppColors.categoryColor(cat),
            ),
          );
        }),
      ])),
      const SizedBox(height: 16),
      // Resultados
      if (_buscando)
        const Center(child: Padding(padding: EdgeInsets.all(24), child: CircularProgressIndicator(color: AppColors.blueBright, strokeWidth: 2)))
      else if (_resultados.isEmpty && _buscarCtrl.text.isNotEmpty)
        Center(child: Padding(padding: const EdgeInsets.all(24),
          child: Text('Sin resultados', style: GoogleFonts.barlowCondensed(fontSize: 15, color: AppColors.white30))))
      else
        ..._resultados.map((j) => _jugadorTile(j)),

      // Panel edicion categoría
      if (_jugadorSel != null) ...[
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: AppColors.white05, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.yellow.withOpacity(0.3))),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('ASIGNAR CATEGORIA', style: GoogleFonts.barlowCondensed(fontSize: 13, letterSpacing: 2, color: AppColors.yellow)),
              IconButton(onPressed: () => setState(() => _jugadorSel = null), icon: const Icon(Icons.close, color: AppColors.white30, size: 18)),
            ]),
            Text('${_jugadorSel!['nombre'] ?? ''} ${_jugadorSel!['apellido'] ?? ''} · DNI ${_jugadorSel!['dni'] ?? ''}',
              style: GoogleFonts.barlow(fontSize: 14, color: Colors.white)),
            const SizedBox(height: 14),
            Text('Categoria actual', style: GoogleFonts.barlowCondensed(fontSize: 11, letterSpacing: 2, color: AppColors.white30)),
            const SizedBox(height: 8),
            Wrap(spacing: 8, runSpacing: 8, children: List.generate(8, (i) {
              final cat = i + 1;
              final color = AppColors.categoryColor(cat);
              final active = _nuevaCat == cat;
              return GestureDetector(
                onTap: () => setState(() => _nuevaCat = cat),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: active ? color.withOpacity(0.2) : AppColors.white05,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: active ? color : AppColors.white10, width: active ? 2 : 1),
                  ),
                  child: Text('${cat}a', style: GoogleFonts.barlowCondensed(fontSize: 14, fontWeight: FontWeight.w600, color: active ? color : AppColors.white30)),
                ),
              );
            })),
            const SizedBox(height: 14),
            Text('En observacion para ascenso', style: GoogleFonts.barlowCondensed(fontSize: 11, letterSpacing: 2, color: AppColors.white30)),
            const SizedBox(height: 8),
            Wrap(spacing: 8, runSpacing: 8, children: [
              GestureDetector(onTap: () => setState(() => _catObs = 0), child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(color: _catObs == 0 ? AppColors.white10 : AppColors.white05, borderRadius: BorderRadius.circular(20), border: Border.all(color: _catObs == 0 ? Colors.white : AppColors.white10, width: _catObs == 0 ? 2 : 1)),
                child: Text('Ninguna', style: GoogleFonts.barlowCondensed(fontSize: 14, fontWeight: FontWeight.w600, color: _catObs == 0 ? Colors.white : AppColors.white30)),
              )),
              ...List.generate(8, (i) {
                final cat = i + 1;
                final color = AppColors.categoryColor(cat);
                final active = _catObs == cat;
                return GestureDetector(onTap: () => setState(() => _catObs = cat), child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(color: active ? color.withOpacity(0.2) : AppColors.white05, borderRadius: BorderRadius.circular(20), border: Border.all(color: active ? color : AppColors.white10, width: active ? 2 : 1)),
                  child: Text('${cat}a', style: GoogleFonts.barlowCondensed(fontSize: 14, fontWeight: FontWeight.w600, color: active ? color : AppColors.white30)),
                ));
              }),
            ]),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _guardando ? null : _guardarCategoria,
              child: _guardando
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : Text('GUARDAR', style: GoogleFonts.barlowCondensed(fontSize: 16, fontWeight: FontWeight.w700, letterSpacing: 2)),
            ),
          ]),
        ),
      ],
    ]),
  );

  Widget _jugadorTile(Map<String, dynamic> j) {
    final nombre   = j['nombre'] as String? ?? '';
    final apellido = j['apellido'] as String? ?? '';
    final dni      = j['dni'] as String? ?? '';
    final cat      = (j['categoria'] as int?) ?? 0;
    final catObs   = j['categoria_observada'] as int?;
    final mano     = j['mano_habil'] as String? ?? '';
    final lado     = j['lado_cancha'] as String? ?? '';
    final residencia = j['residencia'] as String? ?? '';
    final initials = nombre.isNotEmpty ? '${nombre[0]}${apellido.isNotEmpty ? apellido[0] : ''}'.toUpperCase() : 'J';
    final selected = _jugadorSel?['id'] == j['id'];

    return GestureDetector(
      onTap: () => _selJugador(j),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? AppColors.blue.withOpacity(0.15) : AppColors.white05,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: selected ? AppColors.blueBright : AppColors.white10, width: selected ? 1.5 : 1),
        ),
        child: Row(children: [
          ProfileAvatar(fotoUrl: j['foto_url'] as String?, initials: initials, categoria: cat,
            categoriaObservada: catObs != null && catObs != cat ? catObs : null, radius: 22),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('$nombre $apellido', style: GoogleFonts.barlowCondensed(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white)),
            Text('DNI: $dni', style: GoogleFonts.barlow(fontSize: 12, color: AppColors.white30)),
            if (mano.isNotEmpty || lado.isNotEmpty || residencia.isNotEmpty)
              Text('${mano.isNotEmpty ? mano : ''}${lado.isNotEmpty ? ' · $lado' : ''}${residencia.isNotEmpty ? ' · $residencia' : ''}',
                style: GoogleFonts.barlow(fontSize: 11, color: AppColors.white30)),
          ])),
          const Icon(Icons.chevron_right, color: AppColors.white30, size: 18),
        ]),
      ),
    );
  }

  Widget _tabCrearTorneo() => SingleChildScrollView(
    padding: const EdgeInsets.all(20),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('NUEVO TORNEO', style: GoogleFonts.bebasNeue(fontSize: 28, letterSpacing: 2, color: Colors.white)),
      Text('Completa la informacion del torneo', style: GoogleFonts.barlowCondensed(fontSize: 12, letterSpacing: 2, color: AppColors.white30)),
      const SizedBox(height: 24),
      TextField(controller: _tornNombreCtrl, style: const TextStyle(color: Colors.white),
        decoration: const InputDecoration(labelText: 'Nombre del torneo', prefixIcon: Icon(Icons.emoji_events_outlined, color: AppColors.white30))),
      const SizedBox(height: 14),
      TextField(controller: _tornClubCtrl, style: const TextStyle(color: Colors.white),
        decoration: const InputDecoration(labelText: 'Club / Sede', prefixIcon: Icon(Icons.location_on_outlined, color: AppColors.white30))),
      const SizedBox(height: 14),
      GestureDetector(
        onTap: _pickFecha,
        child: AbsorbPointer(child: TextField(controller: _tornFechaCtrl, style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(labelText: 'Fecha', prefixIcon: Icon(Icons.calendar_today_outlined, color: AppColors.white30)))),
      ),
      const SizedBox(height: 20),
      Text('FORMATO', style: GoogleFonts.barlowCondensed(fontSize: 11, letterSpacing: 3, color: AppColors.blueBright)),
      const SizedBox(height: 10),
      Wrap(spacing: 8, children: [
        _tornChip('Grupos', _tornFormato == 'grupos', () => setState(() => _tornFormato = 'grupos')),
        _tornChip('Grupos + Eliminacion', _tornFormato == 'grupos_elim', () => setState(() => _tornFormato = 'grupos_elim')),
        _tornChip('Americano', _tornFormato == 'americano', () => setState(() => _tornFormato = 'americano')),
        _tornChip('Eliminacion directa', _tornFormato == 'eliminacion', () => setState(() => _tornFormato = 'eliminacion')),
      ]),
      const SizedBox(height: 20),
      Text('CATEGORIAS HABILITADAS', style: GoogleFonts.barlowCondensed(fontSize: 11, letterSpacing: 3, color: AppColors.blueBright)),
      const SizedBox(height: 4),
      Text('Deja vacio para todas las categorias', style: GoogleFonts.barlow(fontSize: 11, color: AppColors.white30)),
      const SizedBox(height: 10),
      Wrap(spacing: 8, runSpacing: 8, children: List.generate(8, (i) {
        final cat = i + 1;
        final color = AppColors.categoryColor(cat);
        final active = _tornCats.contains(cat);
        return GestureDetector(
          onTap: () => setState(() => active ? _tornCats.remove(cat) : _tornCats.add(cat)),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: active ? color.withOpacity(0.2) : AppColors.white05,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: active ? color : AppColors.white10, width: active ? 2 : 1),
            ),
            child: Text('${cat}a', style: GoogleFonts.barlowCondensed(fontSize: 14, fontWeight: FontWeight.w600, color: active ? color : AppColors.white30)),
          ),
        );
      })),
      const SizedBox(height: 20),
      Text('CANCHAS DISPONIBLES', style: GoogleFonts.barlowCondensed(fontSize: 11, letterSpacing: 3, color: AppColors.blueBright)),
      const SizedBox(height: 10),
      Row(children: [
        IconButton(onPressed: () => setState(() { if (_tornCanchas > 1) _tornCanchas--; }),
          icon: const Icon(Icons.remove_circle_outline, color: AppColors.white30)),
        Container(
          width: 60, height: 48,
          decoration: BoxDecoration(color: AppColors.white05, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.white10)),
          child: Center(child: Text('$_tornCanchas', style: GoogleFonts.bebasNeue(fontSize: 24, color: Colors.white))),
        ),
        IconButton(onPressed: () => setState(() { if (_tornCanchas < 20) _tornCanchas++; }),
          icon: const Icon(Icons.add_circle_outline, color: AppColors.blueBright)),
        const SizedBox(width: 8),
        Text('canchas', style: GoogleFonts.barlowCondensed(fontSize: 14, color: AppColors.white30)),
      ]),
      const SizedBox(height: 28),
      ElevatedButton(
        onPressed: _creandoTorneo ? null : _crearTorneo,
        child: _creandoTorneo
            ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
            : Text('CREAR TORNEO', style: GoogleFonts.barlowCondensed(fontSize: 18, fontWeight: FontWeight.w700, letterSpacing: 2)),
      ),
      const SizedBox(height: 20),
    ]),
  );

  Widget _filtroChip(String label, bool active, VoidCallback onTap, {Color? color}) {
    final c = color ?? AppColors.blueBright;
    return GestureDetector(onTap: onTap, child: AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: active ? c.withOpacity(0.2) : AppColors.white05,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: active ? c : AppColors.white10, width: active ? 1.5 : 1),
      ),
      child: Text(label, style: GoogleFonts.barlowCondensed(fontSize: 13, fontWeight: FontWeight.w600, color: active ? c : AppColors.white30)),
    ));
  }

  Widget _tornChip(String label, bool active, VoidCallback onTap) => GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: active ? AppColors.blue.withOpacity(0.2) : AppColors.white05,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: active ? AppColors.blueBright : AppColors.white10, width: active ? 2 : 1),
      ),
      child: Text(label, style: GoogleFonts.barlowCondensed(fontSize: 14, fontWeight: FontWeight.w600, color: active ? Colors.white : AppColors.white30)),
    ),
  );
}