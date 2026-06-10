import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../theme/app_colors.dart';
import '../../painters/diagonal_bg_painter.dart';
import '../../widgets/profile_avatar.dart';
import '../auth/login_screen.dart';
import '../perfil/perfil_screen.dart';
import '../jugadores/jugadores_screen.dart';
import '../ranking/ranking_screen.dart';
import '../torneos/torneos_screen.dart';
import '../fiscal/fiscal_login_screen.dart';

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
      const TorneosScreen(),
      PerfilScreen(perfil: _perfil, onSaved: _loadPerfil),
      const FiscalLoginScreen(),
      const SizedBox(), // logout at index 4
    ];

    const navItems = [
      BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'INICIO'),
      BottomNavigationBarItem(icon: Icon(Icons.emoji_events_outlined), activeIcon: Icon(Icons.emoji_events), label: 'TORNEOS'),
      BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'PERFIL'),
      BottomNavigationBarItem(icon: Icon(Icons.shield_outlined), activeIcon: Icon(Icons.shield), label: 'FISCAL'),
      BottomNavigationBarItem(icon: Icon(Icons.logout), label: 'SALIR'),
    ];

    return Scaffold(
      body: Stack(children: [
        Container(decoration: const BoxDecoration(gradient: RadialGradient(
          center: Alignment(0, 1), radius: 1.5, colors: [Color(0x4D1565E8), AppColors.navy],
        ))),
        CustomPaint(painter: DiagonalBgPainter(), child: Container()),
        screens[_navIndex.clamp(0, 4)],
      ]),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(border: Border(top: BorderSide(color: AppColors.white10))),
        child: BottomNavigationBar(
          currentIndex: _navIndex.clamp(0, 4),
          onTap: (i) async {
            if (i == 4) {
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
    // Tournament cards - horizontal scroll
    SizedBox(
      height: 148,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          _torneoCard(
            titulo: 'Copa Punto de Oro',
            subtitulo: 'Zona Centro · 19, 20 y 21 de Junio',
            badge: 'INSCRIPCIONES',
            badgeColor: AppColors.green,
            gradient: [AppColors.blue, const Color(0xFF0A1628)],
            icon: Icons.emoji_events,
          ),
          const SizedBox(width: 12),
          _torneoCard(
            titulo: 'Torneo MPC Pares',
            subtitulo: 'Zona Sur · 29, 30 y 31 de Mayo',
            badge: 'FINALIZADO',
            badgeColor: AppColors.white30,
            gradient: [const Color(0xFF0F1F38), const Color(0xFF050D1A)],
            icon: Icons.emoji_events_outlined,
            extra: 'Ver resultados',
          ),
          const SizedBox(width: 12),
          _torneoCard(
            titulo: 'Open de Invierno',
            subtitulo: 'Zona Norte · 15 de Junio',
            badge: 'PRÓXIMAMENTE',
            badgeColor: AppColors.yellow,
            gradient: [const Color(0xFF1a3a7a), AppColors.navy],
            icon: Icons.stars_outlined,
          ),
        ],
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
          _menuCard('Jugadores', 'Buscar', Icons.sports_tennis, AppColors.yellow, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const JugadoresScreen()))),
          _menuCard('Ranking', 'Posiciones', Icons.leaderboard_outlined, AppColors.blue, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RankingScreen()))),
          _menuCard('Clubes', 'Canchas y sedes', Icons.location_on_outlined, AppColors.blueBright, () {}),
        ],
      ),
    )),
    const SizedBox(height: 8),
  ]));

  Widget _torneoCard({
    required String titulo,
    required String subtitulo,
    required String badge,
    required Color badgeColor,
    required List<Color> gradient,
    required IconData icon,
    String? extra,
  }) {
    return Container(
      width: 260,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(colors: gradient, begin: Alignment.topLeft, end: Alignment.bottomRight),
        border: Border.all(color: AppColors.white10),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Icon(icon, color: Colors.white.withOpacity(0.4), size: 22),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(color: badgeColor.withOpacity(0.2), borderRadius: BorderRadius.circular(6), border: Border.all(color: badgeColor.withOpacity(0.5))),
            child: Text(badge, style: GoogleFonts.barlowCondensed(fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1, color: badgeColor)),
          ),
        ]),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(titulo, style: GoogleFonts.bebasNeue(fontSize: 22, letterSpacing: 1, color: Colors.white)),
          Text(subtitulo, style: GoogleFonts.barlow(fontSize: 11, color: AppColors.white30)),
          if (extra != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Row(children: [
                const Icon(Icons.arrow_forward, color: AppColors.blueBright, size: 12),
                const SizedBox(width: 4),
                Text(extra, style: GoogleFonts.barlowCondensed(fontSize: 12, color: AppColors.blueBright, letterSpacing: 0.5)),
              ]),
            ),
        ]),
      ]),
    );
  }



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

