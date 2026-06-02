import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';
import 'package:shared_preferences/shared_preferences.dart';
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


// ===================== DISTRITOS Y LOCALIDADES BA =====================
const Map<String, List<String>> kDistritosBA = {
  'Almirante Brown': ['Adrogué','Burzaco','Claypole','Don Orione','Glew','José Mármol','Longchamps','Malvinas Argentinas','Ministro Rivadavia','Rafael Calzada','San Francisco de Asís','San José'],
  'Avellaneda': ['Avellaneda','Crucecita','Dock Sud','Gerli','Piñeiro','Sarandí','Villa Domínico'],
  'Azul': ['Azul','Cacharí','Chillar','16 de Julio'],
  'Bahía Blanca': ['Bahía Blanca','Cabildo','Cerri','General Daniel Cerri','Ingeniero White','Loma Paraguaya','Villa Bordeau'],
  'Balcarce': ['Balcarce','Los Pinos','Napaleofu','Ramos Otero','San Agustín'],
  'Baradero': ['Baradero','Ireneo Portela','Portela','Santa Coloma'],
  'Benito Juárez': ['Benito Juárez','Barker','López','Tedín Uriburu'],
  'Berazategui': ['Berazategui','Bosques','El Pato','Guillermo Enrique Hudson','Juan María Gutiérrez','Pereyra','Plátanos','Ranelagh','Villa España'],
  'Bolívar': ['Bolívar','Hinojo','Pirovano','Urdampilleta'],
  'Bragado': ['Bragado','Comodoro Py','La Limpia','O Brien','Olascoaga','Mechita'],
  'Brandsen': ['Brandsen','Gorchs','Jeppener','La Bodega','Oliden'],
  'Campana': ['Campana','Ing. Leandro N. Alem','Otamendi'],
  'Cañuelas': ['Cañuelas','Máximo Paz','Santa Rosa'],
  'Capitán Sarmiento': ['Capitán Sarmiento','El Arbolito','Franklin'],
  'Carlos Casares': ['Carlos Casares','Colonia Mauricio','Hortensia','La Sofía','Mauricio'],
  'Carlos Tejedor': ['Carlos Tejedor','Colonia Seré','Curaru','Moctezuma','Timote'],
  'Carmen de Areco': ['Carmen de Areco','Cañada Seca','Parada Robles'],
  'Castelli': ['Castelli','La Luisa'],
  'Chacabuco': ['Chacabuco','La Invencible','O Higgins','Rafael Obligado'],
  'Chascomús': ['Chascomús','Adela','Gándara','General Paz','Lezama'],
  'Chivilcoy': ['Chivilcoy','Emilio Ayarza','La Rica','Moquehuá','Ramón Biaus'],
  'Colón': ['Colón','Pearson','Villa Moll'],
  'Coronel Dorrego': ['Coronel Dorrego','Oriente','San Román'],
  'Coronel Pringles': ['Coronel Pringles','Indio Rico','Lartigau'],
  'Coronel Rosales': ['Punta Alta','Bajo Hondo','Caleta Cordova'],
  'Coronel Suárez': ['Coronel Suárez','Cura Malal','D Orbigny','Huanguelen','Mayor Buratovich','San José'],
  'Daireaux': ['Daireaux','Blaquier','Casbas','La Campiña'],
  'Dolores': ['Dolores','Sevigny','Verónica'],
  'Ensenada': ['Ensenada','Punta Lara'],
  'Escobar': ['Escobar','Belén de Escobar','Garín','Ingeniero Maschwitz','Maquinista Savio','Matheu','Open Door'],
  'Esteban Echeverría': ['El Jagüel','La Unión','Luis Guillón','Monte Grande','San José'],
  'Exaltación de la Cruz': ['Capilla del Señor','Los Cardales','Parada Robles','Suipacha'],
  'Ezeiza': ['Carlos Spegazzini','Ezeiza','La Unión','Tristán Suárez'],
  'Florencio Varela': ['Florencio Varela','Ingeniero Juan Allan','Los Hornos','Gobernador Costa','Villa Brown'],
  'Florentino Ameghino': ['Florentino Ameghino','Smith'],
  'General Alvarado': ['Miramar','Mar del Sud','Mechongué'],
  'General Alvear': ['General Alvear','Polvaredas'],
  'General Arenales': ['General Arenales','Ascensión','Ariel','Fontezuela'],
  'General Belgrano': ['General Belgrano','Gorchs','Roque Pérez'],
  'General Guido': ['General Guido','Labardén'],
  'General Juan Madariaga': ['General Juan Madariaga','Costa del Este','Mar de Cobo'],
  'General La Madrid': ['General La Madrid','Aldecoa','El Divisorio'],
  'General Las Heras': ['General Las Heras','González Moreno','Plomer'],
  'General Lavalle': ['General Lavalle','Pavón'],
  'General Paz': ['Ranchos','Villanueva'],
  'General Pinto': ['General Pinto','Germania','Moras','Villa Francia'],
  'General Pueyrredón': ['Mar del Plata','Batán','Sierra de los Padres'],
  'General Rodríguez': ['General Rodríguez'],
  'General San Martín': ['Billinghurst','General San Martín','José León Suárez','Villa Ballester','Villa Lynch','Villa Maipú','Villa Raffo'],
  'General Sarmiento': ['Los Polvorines','Bella Vista','Grand Bourg','José C. Paz','Malvinas Argentinas','Muñiz','Tortuguitas'],
  'General Viamonte': ['Los Toldos','Bunge','Garre','Moctezuma','Zavalía'],
  'General Villegas': ['General Villegas','Banderaló','Carlos Salas','Coronel Charlone','Dos Algarrobos','Mayor Enrique Krausse','Piedritas'],
  'Guaminí': ['Guaminí','Álvaro Barros','Casbas','Laguna Alsina'],
  'Hipólito Yrigoyen': ['Henderson','Casbas','Pedernales'],
  'Hurlingham': ['Hurlingham','Villa Tesei','Villa Luzuriaga','El Palomar'],
  'Ituzaingó': ['Ituzaingó','Haedo'],
  'José C. Paz': ['José C. Paz'],
  'Junín': ['Junín','Agustina','Fortín Tiburcio','Morse','Roberts'],
  'La Costa': ['San Clemente del Tuyú','Las Toninas','Santa Teresita','Mar del Tuyú','Costa del Este','Aguas Verdes','La Lucila del Mar','San Bernardo','Mar de Ajó','Nueva Atlantis'],
  'La Matanza': ['San Justo','Ramos Mejía','González Catán','Laferrère','Lomas del Mirador','Tapiales','Isidro Casanova','Ciudad Evita','Aldo Bonzi'],
  'La Plata': ['La Plata','Abasto','Arturo Seguí','City Bell','El Peligro','Gorina','Hernández','Joaquín Gorina','Los Hornos','Melchor Romero','Olmos','Ringuelet','Romero','Tolosa'],
  'Lanús': ['Lanús','Gerli','Monte Chingolo','Remedios de Escalada','Valentín Alsina'],
  'Laprida': ['Laprida','Pueblo Nuevo'],
  'Las Flores': ['Las Flores','Álvarez de Toledo'],
  'Leandro N. Alem': ['Leandro N. Alem','Alberdi','Arribeños','Carabelas','La Pinta'],
  'Lincoln': ['Lincoln','Arenaza','Bermúdez','Carlos María Naón','El Triunfo','Pasteur','Roberts'],
  'Lobería': ['Lobería','Arenas Verdes','Tamangueyu'],
  'Lobos': ['Lobos','Elvira','La Paz','Lucila','Zapiola'],
  'Lomas de Zamora': ['Lomas de Zamora','Banfield','Temperley','Turdera','Villa Centenario','Villa Fiorito'],
  'Luján': ['Luján','Carlos Keen','Cortínez','Jáuregui','Open Door','Torres'],
  'Magdalena': ['Magdalena','Atalaya','Bartolomé Bavio','General Mansilla','Vergara'],
  'Maipú': ['Maipú','Ayacucho','Coronel Vidal','Las Armas'],
  'Malvinas Argentinas': ['Los Polvorines','Grand Bourg','Ing. Adolfo Sourdeaux','Tortuguitas','Villa de Mayo'],
  'Mar Chiquita': ['Mar Chiquita','Camet','La Caleta','Mechongué','Santa Clara del Mar'],
  'Marcos Paz': ['Marcos Paz'],
  'Mercedes': ['Mercedes','Gowland','Gándara'],
  'Merlo': ['Merlo','Libertad','Mariano Acosta','Pontevedra','San Antonio de Padua'],
  'Monte': ['Monte','Alejandro Korn'],
  'Monte Hermoso': ['Monte Hermoso'],
  'Moreno': ['Moreno','Cuartel V','Francisco Álvarez','La Reja','Trujui'],
  'Morón': ['Morón','El Palomar','Castelar','Haedo'],
  'Navarro': ['Navarro'],
  'Necochea': ['Necochea','Quequén','Nicanor Olivera'],
  'Nueve de Julio': ['Nueve de Julio','Alfredo Demarchi','Carlos Salas','La Niña','Patricios','Quiroga','Ramón Biaus','Sheridan'],
  'Olavarría': ['Olavarría','Espigas','Hinojo','Loma Negra','Recalde','Sierra Chica'],
  'Patagones': ['Carmen de Patagones','Stroeder','Villalonga'],
  'Pehuajó': ['Pehuajó','Colonia Barón','Francisco Madero','Mones Cazón','Nueva Plata'],
  'Pellegrini': ['Pellegrini','Urdampilleta'],
  'Pergamino': ['Pergamino','Acevedo','Fontezuela','Guerrico','Rancagua','Urquiza'],
  'Pila': ['Pila'],
  'Pilar': ['Pilar','Del Viso','Fátima','Manzanares','Manuel Alberti','Presidente Derqui','Zelaya'],
  'Pinamar': ['Pinamar','Cariló','Ostende','Valeria del Mar'],
  'Presidente Perón': ['Guernica','Alejandro Korn'],
  'Puán': ['Puán','Bordenave','Darregueira','Felipe Solá','Pigüé'],
  'Punta Indio': ['Verónica','Pipinas','Álvarez Jonte'],
  'Quilmes': ['Quilmes','Bernal','Don Bosco','Ezpeleta','La Florida','San Francisco Solano','Villa La Florida'],
  'Ramallo': ['Ramallo','Villa Ramallo'],
  'Rauch': ['Rauch','Egaña'],
  'Rivadavia': ['América','Sansinena','Fortín Olavarría'],
  'Rojas': ['Rojas','Carabelas','Los Indios','Vuelta de Obligado'],
  'Roque Pérez': ['Roque Pérez','Cazón'],
  'Saavedra': ['Pigüé','Espartillar','Goyena','Lartigau','Dufaur'],
  'Saladillo': ['Saladillo','Alvear','Del Carril','Polvaredas'],
  'Salliqueló': ['Salliqueló','Quenumá'],
  'Salto': ['Salto','Arrecifes','Buen Retiro','Inés Indart'],
  'San Andrés de Giles': ['San Andrés de Giles','Azcuénaga','Cucullú','Giles','Franklin','Villanueva'],
  'San Antonio de Areco': ['San Antonio de Areco','Duggan','Villa Lía'],
  'San Cayetano': ['San Cayetano','Ochandio','Orense'],
  'San Fernando': ['San Fernando','Virreyes','Victoria'],
  'San Isidro': ['San Isidro','Acassuso','Beccar','La Lucila','Martínez','Rincón de Milberg','Talar de Pacheco'],
  'San Miguel': ['San Miguel','Campo de Mayo','Muñiz','Santa María'],
  'San Nicolás': ['San Nicolás de los Arroyos','Conesa','General Lagos','Ramallo'],
  'San Pedro': ['San Pedro','Gobernador Castro','Lima','Obligado','Río Tala'],
  'San Vicente': ['San Vicente','Alejandro Korn','Domselaar'],
  'Suipacha': ['Suipacha'],
  'Tandil': ['Tandil','Gardey','Los Aromos','María Ignacia-Vela'],
  'Tapalqué': ['Tapalqué','Crotto','Velloso'],
  'Tigre': ['Tigre','Don Torcuato','El Talar','General Pacheco','Dique Luján','La Lonja','Nordelta','Rincón de Milberg','Ricardo Rojas','Villa la Ñata'],
  'Tordillo': ['General Conesa','La Postrera'],
  'Tornquist': ['Tornquist','Chasicó','Pehuen-Co','Sierra de la Ventana','Saldungaray','Villa Ventana'],
  'Trenque Lauquen': ['Trenque Lauquen','30 de Agosto','Girodías','La Zanja','Moctezuma','Nueva Plata','Tronge'],
  'Tres Arroyos': ['Tres Arroyos','Claromecó','Copetonas','De la Garma','González Moreno','Irene','Micaela Cascallares','Orense','San Francisco de Bellocq'],
  'Tres de Febrero': ['Caseros','Ciudadela','El Palomar','Pablo Podestá','Santos Lugares','Villa Bosch','Villa del Parque','Villa Raffo'],
  'Tres Lomas': ['Tres Lomas','Algarrobo'],
  'Veinticinco de Mayo': ['Veinticinco de Mayo','Del Valle','Ernestina','Gobernador Ugarte','La Invernada','Norberto de la Riestra','Roberto Cano','Valdés'],
  'Vicente López': ['Vicente López','Carapachay','Florida','Munro','Olivos','Villa Adelina','Villa Martelli'],
  'Villa Gesell': ['Villa Gesell','Mar de las Pampas','Las Gaviotas','Mar Azul'],
  'Villarino': ['Médanos','Hilario Ascasubi','Mayor Buratovich','Teniente Origone','Pedro Luro'],
  'Zárate': ['Zárate','Campana','Lima'],
};

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
  void initState() {
    super.initState();
    _loadSavedDni();
  }

  Future<void> _loadSavedDni() async {
    final prefs = await SharedPreferences.getInstance();
    final savedDni = prefs.getString('saved_dni') ?? '';
    final savedPwd = prefs.getString('saved_pwd') ?? '';
    if (mounted) {
      setState(() {
        if (savedDni.isNotEmpty) _dniCtrl.text = savedDni;
        if (savedPwd.isNotEmpty) _pwdCtrl.text = savedPwd;
      });
    }
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
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    backgroundColor: AppColors.navy2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    title: Row(children: [
                      Image.network('https://www.google.com/favicon.ico', width: 20, height: 20,
                        errorBuilder: (_, __, ___) => const Icon(Icons.g_mobiledata, color: Colors.white, size: 20)),
                      const SizedBox(width: 10),
                      Text('Ingresar con Google', style: GoogleFonts.barlowCondensed(fontSize: 18, color: Colors.white, letterSpacing: 0.5)),
                    ]),
                    content: Column(mainAxisSize: MainAxisSize.min, children: [
                      const Icon(Icons.construction_outlined, color: AppColors.yellow, size: 48),
                      const SizedBox(height: 12),
                      Text('Próximamente', style: GoogleFonts.bebasNeue(fontSize: 24, color: AppColors.yellow, letterSpacing: 2)),
                      const SizedBox(height: 8),
                      Text('El inicio de sesión con Google estará disponible en la próxima actualización.',
                        style: GoogleFonts.barlow(fontSize: 13, color: AppColors.white30),
                        textAlign: TextAlign.center),
                    ]),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: Text('Entendido', style: GoogleFonts.barlowCondensed(fontSize: 15, color: AppColors.blueBright, letterSpacing: 1)),
                      ),
                    ],
                  ),
                );
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.white05,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.white10),
                ),
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Container(
                    width: 22, height: 22,
                    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                    child: ClipOval(child: Image.network(
                      'https://www.google.com/favicon.ico',
                      width: 16, height: 16,
                      errorBuilder: (_, __, ___) => const Center(child: Text('G', style: TextStyle(color: Color(0xFF4285F4), fontSize: 14, fontWeight: FontWeight.bold))),
                    )),
                  ),
                  const SizedBox(width: 10),
                  Text('Ingresar con Google',
                    style: GoogleFonts.barlowCondensed(fontSize: 15, color: AppColors.white30, letterSpacing: 0.5)),
                ]),
              ),
            ),
            if (_isLogin) ...[
              const SizedBox(height: 8),
              Center(child: TextButton(
                onPressed: () {},
                child: Text('¿Olvidaste tu contraseña?', style: GoogleFonts.barlowCondensed(color: AppColors.white30, letterSpacing: 1)),
              )),
              const SizedBox(height: 8),
              const Divider(color: AppColors.white10),
              const SizedBox(height: 8),
              // Fiscal access
              GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FiscalLoginScreen())),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  decoration: BoxDecoration(
                    color: AppColors.yellow.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.yellow.withOpacity(0.25)),
                  ),
                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    const Icon(Icons.shield_outlined, color: AppColors.yellow, size: 16),
                    const SizedBox(width: 8),
                    Text('Acceso Fiscal', style: GoogleFonts.barlowCondensed(fontSize: 14, color: AppColors.yellow, letterSpacing: 1)),
                  ]),
                ),
              ),
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
  String _distrito       = '';
  String _localidad      = '';
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
    _emailCtrl.text = p['email'] ?? '';
    _distrito       = p['distrito'] ?? '';
    _localidad      = p['localidad'] ?? '';
    _ladoCancha     = p['lado_cancha'] ?? '';
    _manoHabil      = p['mano_habil'] ?? '';
    final rawClubes = p['clubes_ids'];
    if (rawClubes != null) {
      _selectedClubes = List<String>.from(rawClubes);
    }
  }

  @override
  void didUpdateWidget(PerfilScreen old) { super.didUpdateWidget(old); if (widget.perfil != old.perfil) _loadData(); }

  @override
  void dispose() { _nombreCtrl.dispose(); _apellidoCtrl.dispose(); _emailCtrl.dispose(); super.dispose(); }

  String _formatFecha(String isoDate) {
    try {
      final d = DateTime.parse(isoDate).toLocal();
      return '${d.day.toString().padLeft(2,'0')}/${d.month.toString().padLeft(2,'0')}/${d.year}';
    } catch (_) { return isoDate; }
  }

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
      final nombreTrim = _nombreCtrl.text.trim();
      final apellidoTrim = _apellidoCtrl.text.trim();
      if (nombreTrim.isEmpty) {
        _toast('Ingresa tu nombre', error: true);
        setState(() => _loading = false);
        return;
      }
      await Supabase.instance.client.from('usuarios').update({
        'nombre': nombreTrim,
        'apellido': apellidoTrim,
        'email': _emailCtrl.text.trim(),
        'distrito': _distrito.isNotEmpty ? _distrito : null,
        'localidad': _localidad.isNotEmpty ? _localidad : null,
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
            Text('$edad años', style: GoogleFonts.barlowCondensed(fontSize: 14, color: AppColors.blueBright, letterSpacing: 1)),
        ])),
        const SizedBox(height: 28),

        // DNI y fecha NO editables
        _sectionTitle('DATOS FIJOS'),
        const SizedBox(height: 4),
        Text('DNI y fecha de nacimiento no pueden modificarse', style: GoogleFonts.barlow(fontSize: 11, color: AppColors.white30)),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(child: _infoTile(Icons.badge_outlined, 'DNI', dni)),
          const SizedBox(width: 10),
          Expanded(child: _infoTile(Icons.cake_outlined, 'Fecha nac.', fecha.isNotEmpty ? fecha : '—')),
        ]),
        const SizedBox(height: 20),
        // Show distrito/localidad
        if (p?['distrito'] != null || p?['localidad'] != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _infoTile(Icons.location_on_outlined, 'Ubicación',
              [p?['localidad'], p?['distrito']].where((e) => e != null && e.toString().isNotEmpty).join(', ')),
          ),
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
        if (categoria > 0)
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Categoría ${categoria}a', style: GoogleFonts.barlowCondensed(fontSize: 16, color: Colors.white, letterSpacing: 0.5)),
              const SizedBox(height: 2),
              Row(children: [
                const Icon(Icons.verified_user_outlined, color: AppColors.white30, size: 13),
                const SizedBox(width: 4),
                Text('Asignada por: ', style: GoogleFonts.barlowCondensed(fontSize: 12, color: AppColors.white30, letterSpacing: 0.5)),
                Flexible(child: RichText(
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    style: GoogleFonts.barlowCondensed(fontSize: 12, color: AppColors.blueBright, fontWeight: FontWeight.w600),
                    children: [
                      TextSpan(text: p?['categorizado_por_nombre'] != null && p!['categorizado_por_nombre'].toString().isNotEmpty
                          ? p['categorizado_por_nombre'].toString() : 'Fiscal'),
                      if (p?['categorizado_fecha'] != null)
                        TextSpan(
                          text: ' (${_formatFecha(p!['categorizado_fecha'].toString())})',
                          style: GoogleFonts.barlow(fontSize: 11, color: AppColors.white30, fontWeight: FontWeight.normal),
                        ),
                    ],
                  ),
                )),
              ]),
              if (catObs != null && catObs != categoria)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Row(children: [
                    const Icon(Icons.trending_up, color: AppColors.yellow, size: 14),
                    const SizedBox(width: 4),
                    Text('En observación para ${catObs}a',
                      style: GoogleFonts.barlowCondensed(fontSize: 13, color: AppColors.yellow, letterSpacing: 0.5)),
                  ]),
                ),
            ])),
          ])
        else
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.white05,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.white10),
            ),
            child: Row(children: [
              const Icon(Icons.hourglass_empty_outlined, color: AppColors.white30, size: 18),
              const SizedBox(width: 10),
              Text('Categoría aún no asignada', style: GoogleFonts.barlowCondensed(fontSize: 14, color: AppColors.white30, letterSpacing: 0.5)),
            ]),
          ),
        const SizedBox(height: 28),

        // Datos editables
        _sectionTitle('DATOS DE JUEGO'),
        const SizedBox(height: 12),
        TextField(controller: _emailCtrl, keyboardType: TextInputType.emailAddress,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(labelText: 'Email')),
        const SizedBox(height: 14),
        _DistritoLocalidadSelector(
          distrito: _distrito.isNotEmpty ? _distrito : null,
          localidad: _localidad.isNotEmpty ? _localidad : null,
          onDistritoChanged: (v) => setState(() { _distrito = v ?? ''; _localidad = ''; }),
          onLocalidadChanged: (v) => setState(() => _localidad = v ?? ''),
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



// ===================== DISTRITO / LOCALIDAD SELECTOR =====================
class _DistritoLocalidadSelector extends StatefulWidget {
  final String? distrito;
  final String? localidad;
  final ValueChanged<String?> onDistritoChanged;
  final ValueChanged<String?> onLocalidadChanged;
  const _DistritoLocalidadSelector({
    required this.distrito,
    required this.localidad,
    required this.onDistritoChanged,
    required this.onLocalidadChanged,
  });
  @override
  State<_DistritoLocalidadSelector> createState() => _DistritoLocalidadSelectorState();
}

class _DistritoLocalidadSelectorState extends State<_DistritoLocalidadSelector> {
  final _distCtrl = TextEditingController();
  final _locCtrl  = TextEditingController();
  List<String> _distSuggestions = [];
  List<String> _locSuggestions  = [];
  bool _showDist = false;
  bool _showLoc  = false;

  @override
  void initState() {
    super.initState();
    if (widget.distrito != null) _distCtrl.text = widget.distrito!;
    if (widget.localidad != null) _locCtrl.text = widget.localidad!;
  }

  @override
  void dispose() { _distCtrl.dispose(); _locCtrl.dispose(); super.dispose(); }

  void _onDistChanged(String val) {
    final q = val.toLowerCase();
    final matches = kDistritosBA.keys.where((d) => d.toLowerCase().contains(q)).take(8).toList();
    setState(() { _distSuggestions = matches; _showDist = matches.isNotEmpty && val.isNotEmpty; });
    if (val.isEmpty) { widget.onDistritoChanged(null); widget.onLocalidadChanged(null); _locCtrl.clear(); }
  }

  void _selectDist(String d) {
    _distCtrl.text = d;
    _locCtrl.clear();
    widget.onDistritoChanged(d);
    widget.onLocalidadChanged(null);
    setState(() { _showDist = false; _distSuggestions = []; });
  }

  void _onLocChanged(String val) {
    final dist = widget.distrito;
    if (dist == null) return;
    final locs = kDistritosBA[dist] ?? [];
    final q = val.toLowerCase();
    final matches = locs.where((l) => l.toLowerCase().contains(q)).take(8).toList();
    setState(() { _locSuggestions = matches; _showLoc = matches.isNotEmpty && val.isNotEmpty; });
  }

  void _selectLoc(String l) {
    _locCtrl.text = l;
    widget.onLocalidadChanged(l);
    setState(() { _showLoc = false; _locSuggestions = []; });
  }

  Widget _suggestionList(List<String> items, ValueChanged<String> onTap, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(top: 2),
      decoration: BoxDecoration(color: AppColors.navy3, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.white10)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 200),
        child: ListView(shrinkWrap: true, children: items.map((s) => InkWell(
          onTap: () => onTap(s),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
            child: Row(children: [
              Icon(icon, color: AppColors.white30, size: 15),
              const SizedBox(width: 10),
              Text(s, style: GoogleFonts.barlow(fontSize: 14, color: Colors.white)),
            ]),
          ),
        )).toList()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasDistrict = widget.distrito != null && widget.distrito!.isNotEmpty;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // Distrito
      TextField(
        controller: _distCtrl,
        style: const TextStyle(color: Colors.white),
        onChanged: _onDistChanged,
        decoration: InputDecoration(
          labelText: 'Distrito / Partido',
          prefixIcon: const Icon(Icons.map_outlined, color: AppColors.white30),
          suffixIcon: _distCtrl.text.isNotEmpty
              ? IconButton(icon: const Icon(Icons.clear, color: AppColors.white30, size: 18),
                  onPressed: () { _distCtrl.clear(); _locCtrl.clear(); widget.onDistritoChanged(null); widget.onLocalidadChanged(null); setState(() { _showDist = false; _showLoc = false; }); })
              : null,
        ),
      ),
      if (_showDist) _suggestionList(_distSuggestions, _selectDist, Icons.location_city_outlined),
      const SizedBox(height: 12),
      // Localidad
      TextField(
        controller: _locCtrl,
        style: TextStyle(color: hasDistrict ? Colors.white : AppColors.white30),
        enabled: hasDistrict,
        onChanged: _onLocChanged,
        decoration: InputDecoration(
          labelText: hasDistrict ? 'Localidad' : 'Primero elegí el distrito',
          prefixIcon: const Icon(Icons.location_on_outlined, color: AppColors.white30),
          suffixIcon: _locCtrl.text.isNotEmpty
              ? IconButton(icon: const Icon(Icons.clear, color: AppColors.white30, size: 18),
                  onPressed: () { _locCtrl.clear(); widget.onLocalidadChanged(null); setState(() => _showLoc = false); })
              : null,
        ),
      ),
      if (_showLoc) _suggestionList(_locSuggestions, _selectLoc, Icons.place_outlined),
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


// ===================== TORNEOS SCREEN =====================
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
class JugadoresScreen extends StatefulWidget {
  const JugadoresScreen({super.key});
  @override
  State<JugadoresScreen> createState() => _JugadoresScreenState();
}

class _JugadoresScreenState extends State<JugadoresScreen> {
  final _buscarCtrl = TextEditingController();
  List<Map<String, dynamic>> _resultados = [];
  bool _buscando = false;
  bool _showFiltros = false;
  String _filtroMano = '';
  String _filtroLado = '';
  int _filtroCat = 0;

  @override
  void dispose() { _buscarCtrl.dispose(); super.dispose(); }

  Future<void> _buscar() async {
    final q = _buscarCtrl.text.trim();
    if (q.isEmpty && _filtroMano.isEmpty && _filtroLado.isEmpty && _filtroCat == 0) {
      setState(() => _resultados = []);
      return;
    }
    setState(() => _buscando = true);
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
      final res = await query.order('nombre').limit(30);
      if (mounted) setState(() { _resultados = List<Map<String, dynamic>>.from(res); _buscando = false; });
    } catch (_) { if (mounted) setState(() => _buscando = false); }
  }

  @override
  Widget build(BuildContext context) {
    final hayFiltros = _filtroMano.isNotEmpty || _filtroLado.isNotEmpty || _filtroCat > 0;
    return Scaffold(
      backgroundColor: AppColors.navy,
      body: Stack(children: [
        CustomPaint(painter: DiagonalBgPainter(), child: Container()),
        SafeArea(child: Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                IconButton(onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_ios, color: AppColors.white30, size: 20)),
                Text('JUGADORES', style: GoogleFonts.bebasNeue(fontSize: 28, letterSpacing: 2, color: Colors.white)),
              ]),
              const SizedBox(height: 8),
              TextField(
                controller: _buscarCtrl,
                style: const TextStyle(color: Colors.white),
                onChanged: (_) { setState(() {}); _buscar(); },
                decoration: InputDecoration(
                  labelText: 'Buscar por nombre, apellido o DNI',
                  prefixIcon: const Icon(Icons.search, color: AppColors.white30),
                  suffixIcon: _buscarCtrl.text.isNotEmpty
                      ? IconButton(icon: const Icon(Icons.clear, color: AppColors.white30),
                          onPressed: () { _buscarCtrl.clear(); _buscar(); setState(() {}); })
                      : null,
                ),
              ),
              const SizedBox(height: 8),
              _filtrosWidget(hayFiltros),
            ]),
          ),
          const SizedBox(height: 8),
          Expanded(child: _buscando
            ? const Center(child: CircularProgressIndicator(color: AppColors.blueBright, strokeWidth: 2))
            : _resultados.isEmpty
              ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Icon(Icons.search, color: AppColors.white30, size: 48),
                  const SizedBox(height: 8),
                  Text('Buscá un jugador', style: GoogleFonts.barlowCondensed(fontSize: 15, color: AppColors.white30)),
                  Text('o usá los filtros', style: GoogleFonts.barlow(fontSize: 12, color: AppColors.white30)),
                ]))
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  itemCount: _resultados.length,
                  itemBuilder: (_, i) => _jugadorTile(_resultados[i]),
                ),
          ),
        ])),
      ]),
    );
  }

  Widget _filtrosWidget(bool hayFiltros) => Column(children: [
    GestureDetector(
      onTap: () => setState(() => _showFiltros = !_showFiltros),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: hayFiltros ? AppColors.blue.withOpacity(0.15) : AppColors.white05,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: hayFiltros ? AppColors.blueBright : AppColors.white10),
        ),
        child: Row(children: [
          Icon(Icons.filter_list, color: hayFiltros ? AppColors.blueBright : AppColors.white30, size: 16),
          const SizedBox(width: 8),
          Text(hayFiltros ? 'Filtros activos' : 'Filtros',
            style: GoogleFonts.barlowCondensed(fontSize: 13, color: hayFiltros ? AppColors.blueBright : AppColors.white30, letterSpacing: 1)),
          const Spacer(),
          Icon(_showFiltros ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: AppColors.white30, size: 16),
        ]),
      ),
    ),
    if (_showFiltros) ...[
      const SizedBox(height: 6),
      Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: AppColors.navy3, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.white10)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Mano', style: GoogleFonts.barlowCondensed(fontSize: 10, letterSpacing: 2, color: AppColors.white30)),
          const SizedBox(height: 4),
          Wrap(spacing: 6, children: [
            _chip('Todas', _filtroMano.isEmpty, () => setState(() { _filtroMano = ''; _buscar(); })),
            _chip('Derecha', _filtroMano == 'derecha', () => setState(() { _filtroMano = 'derecha'; _buscar(); })),
            _chip('Zurda', _filtroMano == 'zurda', () => setState(() { _filtroMano = 'zurda'; _buscar(); })),
          ]),
          const SizedBox(height: 8),
          Text('Lado', style: GoogleFonts.barlowCondensed(fontSize: 10, letterSpacing: 2, color: AppColors.white30)),
          const SizedBox(height: 4),
          Wrap(spacing: 6, children: [
            _chip('Todos', _filtroLado.isEmpty, () => setState(() { _filtroLado = ''; _buscar(); })),
            _chip('Drive', _filtroLado == 'drive', () => setState(() { _filtroLado = 'drive'; _buscar(); })),
            _chip('Revés', _filtroLado == 'reves', () => setState(() { _filtroLado = 'reves'; _buscar(); })),
            _chip('Ambos', _filtroLado == 'ambos', () => setState(() { _filtroLado = 'ambos'; _buscar(); })),
          ]),
          const SizedBox(height: 8),
          Text('Categoría', style: GoogleFonts.barlowCondensed(fontSize: 10, letterSpacing: 2, color: AppColors.white30)),
          const SizedBox(height: 4),
          Wrap(spacing: 6, runSpacing: 4, children: [
            _chip('Todas', _filtroCat == 0, () => setState(() { _filtroCat = 0; _buscar(); })),
            ...List.generate(8, (i) { final cat = i+1; return _chip('${cat}a', _filtroCat == cat,
              () => setState(() { _filtroCat = cat == _filtroCat ? 0 : cat; _buscar(); }),
              color: AppColors.categoryColor(cat)); }),
          ]),
        ]),
      ),
    ],
  ]);

  Widget _jugadorTile(Map<String, dynamic> j) {
    final nombre = j['nombre'] as String? ?? '';
    final apellido = j['apellido'] as String? ?? '';
    final cat = (j['categoria'] as int?) ?? 0;
    final catObs = j['categoria_observada'] as int?;
    final mano = j['mano_habil'] as String? ?? '';
    final lado = j['lado_cancha'] as String? ?? '';
    final localidad = j['localidad'] as String? ?? '';
    final distrito = j['distrito'] as String? ?? '';
    final initials = nombre.isNotEmpty ? '${nombre[0]}${apellido.isNotEmpty ? apellido[0] : ''}'.toUpperCase() : 'J';
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppColors.white05, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.white10)),
      child: Row(children: [
        ProfileAvatar(fotoUrl: j['foto_url'] as String?, initials: initials, categoria: cat,
          categoriaObservada: catObs != null && catObs != cat ? catObs : null, radius: 22),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('$nombre $apellido', style: GoogleFonts.barlowCondensed(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white)),
          if (localidad.isNotEmpty || distrito.isNotEmpty)
            Text([if (localidad.isNotEmpty) localidad, if (distrito.isNotEmpty) distrito].join(', '),
              style: GoogleFonts.barlow(fontSize: 11, color: AppColors.white30)),
          if (mano.isNotEmpty || lado.isNotEmpty)
            Text([if (mano.isNotEmpty) mano, if (lado.isNotEmpty) lado].join(' · '),
              style: GoogleFonts.barlow(fontSize: 11, color: AppColors.white30)),
        ])),
        if (cat > 0) Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(color: AppColors.categoryColor(cat).withOpacity(0.15), borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.categoryColor(cat))),
          child: Text('${cat}a', style: GoogleFonts.bebasNeue(fontSize: 14, color: AppColors.categoryColor(cat))),
        ),
      ]),
    );
  }

  Widget _chip(String label, bool active, VoidCallback onTap, {Color? color}) {
    final c = color ?? AppColors.blueBright;
    return GestureDetector(onTap: onTap, child: AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: active ? c.withOpacity(0.2) : AppColors.white05, borderRadius: BorderRadius.circular(14), border: Border.all(color: active ? c : AppColors.white10, width: active ? 1.5 : 1)),
      child: Text(label, style: GoogleFonts.barlowCondensed(fontSize: 12, fontWeight: FontWeight.w600, color: active ? c : AppColors.white30)),
    ));
  }
}

// ===================== RANKING SCREEN =====================
class RankingScreen extends StatefulWidget {
  const RankingScreen({super.key});
  @override
  State<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  // Filters
  String? _filtroDistrito;
  String? _filtroLocalidad;
  String? _filtroClubId;
  int _filtroCat = 0;
  bool _showFiltros = true;
  List<Map<String, dynamic>> _clubes = [];
  List<Map<String, dynamic>> _jugadores = [];
  bool _buscando = false;
  final _distCtrl = TextEditingController();
  final _locCtrl  = TextEditingController();
  List<String> _distSug = [];
  List<String> _locSug  = [];
  bool _showDistSug = false;
  bool _showLocSug  = false;

  @override
  void initState() { super.initState(); _loadClubes(); }

  @override
  void dispose() { _distCtrl.dispose(); _locCtrl.dispose(); super.dispose(); }

  Future<void> _loadClubes() async {
    try {
      final res = await Supabase.instance.client.from('clubes').select().eq('activo', true).order('nombre');
      if (mounted) setState(() => _clubes = List<Map<String, dynamic>>.from(res));
    } catch (_) {}
  }

  Future<void> _buscar() async {
    setState(() => _buscando = true);
    try {
      var query = Supabase.instance.client.from('usuarios').select();
      if (_filtroDistrito != null && _filtroDistrito!.isNotEmpty)
        query = query.eq('distrito', _filtroDistrito!) as dynamic;
      if (_filtroLocalidad != null && _filtroLocalidad!.isNotEmpty)
        query = query.eq('localidad', _filtroLocalidad!) as dynamic;
      if (_filtroClubId != null)
        query = query.contains('clubes_ids', [_filtroClubId!]) as dynamic;
      if (_filtroCat > 0)
        query = query.eq('categoria', _filtroCat) as dynamic;
      else
        query = query.not('categoria', 'is', null) as dynamic;
      final res = await query.order('categoria').limit(100);
      if (mounted) setState(() { _jugadores = List<Map<String, dynamic>>.from(res); _buscando = false; });
    } catch (e) { if (mounted) setState(() => _buscando = false); }
  }

  void _onDistChanged(String val) {
    final q = val.toLowerCase();
    final matches = kDistritosBA.keys.where((d) => d.toLowerCase().contains(q)).take(6).toList();
    setState(() { _distSug = matches; _showDistSug = matches.isNotEmpty && val.isNotEmpty; });
    if (val.isEmpty) { _filtroDistrito = null; _filtroLocalidad = null; _locCtrl.clear(); }
  }

  void _selectDist(String d) {
    _distCtrl.text = d; _locCtrl.clear();
    setState(() { _filtroDistrito = d; _filtroLocalidad = null; _showDistSug = false; _distSug = []; });
  }

  void _onLocChanged(String val) {
    if (_filtroDistrito == null) return;
    final locs = kDistritosBA[_filtroDistrito!] ?? [];
    final q = val.toLowerCase();
    final matches = locs.where((l) => l.toLowerCase().contains(q)).take(6).toList();
    setState(() { _locSug = matches; _showLocSug = matches.isNotEmpty && val.isNotEmpty; });
  }

  void _selectLoc(String l) {
    _locCtrl.text = l;
    setState(() { _filtroLocalidad = l; _showLocSug = false; _locSug = []; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy,
      body: Stack(children: [
        CustomPaint(painter: DiagonalBgPainter(), child: Container()),
        SafeArea(child: Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                IconButton(onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_ios, color: AppColors.white30, size: 20)),
                Text('RANKING', style: GoogleFonts.bebasNeue(fontSize: 28, letterSpacing: 2, color: Colors.white)),
              ]),
              Text('Buscá los mejores jugadores por zona', style: GoogleFonts.barlowCondensed(fontSize: 12, letterSpacing: 1, color: AppColors.white30)),
              const SizedBox(height: 12),
              // Filtros
              GestureDetector(
                onTap: () => setState(() => _showFiltros = !_showFiltros),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.white05, borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.white10),
                  ),
                  child: Row(children: [
                    const Icon(Icons.tune, color: AppColors.blueBright, size: 16),
                    const SizedBox(width: 8),
                    Text('Filtros de búsqueda', style: GoogleFonts.barlowCondensed(fontSize: 13, color: AppColors.blueBright, letterSpacing: 1)),
                    const Spacer(),
                    Icon(_showFiltros ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: AppColors.white30, size: 16),
                  ]),
                ),
              ),
              if (_showFiltros) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(color: AppColors.navy3, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.white10)),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    // Distrito
                    Text('Distrito / Partido', style: GoogleFonts.barlowCondensed(fontSize: 10, letterSpacing: 2, color: AppColors.white30)),
                    const SizedBox(height: 4),
                    TextField(
                      controller: _distCtrl,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      onChanged: _onDistChanged,
                      decoration: InputDecoration(
                        hintText: 'Ej: La Costa, Bahía Blanca...',
                        hintStyle: const TextStyle(color: AppColors.white30, fontSize: 13),
                        prefixIcon: const Icon(Icons.map_outlined, color: AppColors.white30, size: 18),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        suffixIcon: _distCtrl.text.isNotEmpty ? IconButton(icon: const Icon(Icons.clear, color: AppColors.white30, size: 16),
                          onPressed: () { _distCtrl.clear(); _locCtrl.clear(); setState(() { _filtroDistrito = null; _filtroLocalidad = null; _showDistSug = false; }); }) : null,
                      ),
                    ),
                    if (_showDistSug) _suggestionBox(_distSug, _selectDist, Icons.location_city_outlined),
                    const SizedBox(height: 8),
                    // Localidad
                    Text('Localidad', style: GoogleFonts.barlowCondensed(fontSize: 10, letterSpacing: 2, color: AppColors.white30)),
                    const SizedBox(height: 4),
                    TextField(
                      controller: _locCtrl,
                      enabled: _filtroDistrito != null,
                      style: TextStyle(color: _filtroDistrito != null ? Colors.white : AppColors.white30, fontSize: 14),
                      onChanged: _onLocChanged,
                      decoration: InputDecoration(
                        hintText: _filtroDistrito != null ? 'Ej: Cabildo, Las Toninas...' : 'Primero elegí el distrito',
                        hintStyle: const TextStyle(color: AppColors.white30, fontSize: 13),
                        prefixIcon: const Icon(Icons.location_on_outlined, color: AppColors.white30, size: 18),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        suffixIcon: _locCtrl.text.isNotEmpty ? IconButton(icon: const Icon(Icons.clear, color: AppColors.white30, size: 16),
                          onPressed: () { _locCtrl.clear(); setState(() { _filtroLocalidad = null; _showLocSug = false; }); }) : null,
                      ),
                    ),
                    if (_showLocSug) _suggestionBox(_locSug, _selectLoc, Icons.place_outlined),
                    const SizedBox(height: 8),
                    // Club
                    Text('Club', style: GoogleFonts.barlowCondensed(fontSize: 10, letterSpacing: 2, color: AppColors.white30)),
                    const SizedBox(height: 4),
                    if (_clubes.isNotEmpty)
                      SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: [
                        _chip('Todos', _filtroClubId == null, () => setState(() => _filtroClubId = null)),
                        ..._clubes.map((c) => Padding(
                          padding: const EdgeInsets.only(left: 6),
                          child: _chip(c['nombre'] as String, _filtroClubId == c['id'],
                            () => setState(() => _filtroClubId = _filtroClubId == c['id'] ? null : c['id'] as String)),
                        )),
                      ])),
                    const SizedBox(height: 8),
                    // Categoria
                    Text('Categoría', style: GoogleFonts.barlowCondensed(fontSize: 10, letterSpacing: 2, color: AppColors.white30)),
                    const SizedBox(height: 4),
                    Wrap(spacing: 6, runSpacing: 4, children: [
                      _chip('Todas', _filtroCat == 0, () => setState(() => _filtroCat = 0)),
                      ...List.generate(8, (i) { final cat = i+1; return _chip('${cat}a', _filtroCat == cat,
                        () => setState(() => _filtroCat = cat == _filtroCat ? 0 : cat),
                        color: AppColors.categoryColor(cat)); }),
                    ]),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _buscando ? null : _buscar,
                      style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 44)),
                      child: _buscando
                          ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : Text('BUSCAR', style: GoogleFonts.barlowCondensed(fontSize: 16, fontWeight: FontWeight.w700, letterSpacing: 2)),
                    ),
                  ]),
                ),
              ],
            ]),
          ),
          const SizedBox(height: 8),
          Expanded(child: _jugadores.isEmpty
            ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Icon(Icons.leaderboard_outlined, color: AppColors.white30, size: 52),
                const SizedBox(height: 10),
                Text('Aplicá filtros y buscá', style: GoogleFonts.barlowCondensed(fontSize: 15, color: AppColors.white30)),
                Text('para ver el ranking por zona', style: GoogleFonts.barlow(fontSize: 12, color: AppColors.white30)),
              ]))
            : ListView.builder(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                itemCount: _jugadores.length,
                itemBuilder: (_, i) => _jugadorRow(_jugadores[i], i + 1),
              ),
          ),
        ])),
      ]),
    );
  }

  Widget _suggestionBox(List<String> items, ValueChanged<String> onTap, IconData icon) =>
    Container(
      margin: const EdgeInsets.only(top: 2),
      decoration: BoxDecoration(color: AppColors.navy2, borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.white10)),
      child: ConstrainedBox(constraints: const BoxConstraints(maxHeight: 160),
        child: ListView(shrinkWrap: true, children: items.map((s) => InkWell(
          onTap: () => onTap(s),
          child: Padding(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(children: [
              Icon(icon, color: AppColors.white30, size: 14),
              const SizedBox(width: 8),
              Text(s, style: GoogleFonts.barlow(fontSize: 13, color: Colors.white)),
            ])),
        )).toList()),
      ),
    );

  Widget _jugadorRow(Map<String, dynamic> j, int pos) {
    final nombre = j['nombre'] as String? ?? '';
    final apellido = j['apellido'] as String? ?? '';
    final cat = (j['categoria'] as int?) ?? 0;
    final catObs = j['categoria_observada'] as int?;
    final mano = j['mano_habil'] as String? ?? '';
    final lado = j['lado_cancha'] as String? ?? '';
    final localidad = j['localidad'] as String? ?? '';
    final initials = nombre.isNotEmpty ? '${nombre[0]}${apellido.isNotEmpty ? apellido[0] : ''}'.toUpperCase() : 'J';
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppColors.white05, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.white10)),
      child: Row(children: [
        SizedBox(width: 28, child: Text('#$pos', style: GoogleFonts.bebasNeue(fontSize: 16, color: AppColors.white30))),
        ProfileAvatar(fotoUrl: j['foto_url'] as String?, initials: initials, categoria: cat,
          categoriaObservada: catObs != null && catObs != cat ? catObs : null, radius: 20),
        const SizedBox(width: 10),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('$nombre $apellido', style: GoogleFonts.barlowCondensed(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white)),
          if (localidad.isNotEmpty) Text(localidad, style: GoogleFonts.barlow(fontSize: 11, color: AppColors.white30)),
          if (mano.isNotEmpty || lado.isNotEmpty)
            Text([if (mano.isNotEmpty) mano, if (lado.isNotEmpty) lado].join(' · '), style: GoogleFonts.barlow(fontSize: 11, color: AppColors.white30)),
        ])),
        if (cat > 0) Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(color: AppColors.categoryColor(cat).withOpacity(0.15), borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.categoryColor(cat))),
          child: Text('${cat}a', style: GoogleFonts.bebasNeue(fontSize: 14, color: AppColors.categoryColor(cat))),
        ),
      ]),
    );
  }

  Widget _chip(String label, bool active, VoidCallback onTap, {Color? color}) {
    final c = color ?? AppColors.blueBright;
    return GestureDetector(onTap: onTap, child: AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: active ? c.withOpacity(0.2) : AppColors.white05, borderRadius: BorderRadius.circular(14), border: Border.all(color: active ? c : AppColors.white10, width: active ? 1.5 : 1)),
      child: Text(label, style: GoogleFonts.barlowCondensed(fontSize: 12, fontWeight: FontWeight.w600, color: active ? c : AppColors.white30)),
    ));
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
  // Filtros state
  bool _showFiltros = false;
  // Notas state
  List<Map<String, dynamic>> _notas = [];
  final _notaCtrl = TextEditingController();
  bool _guardandoNota = false;
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
      _notas = [];
    });
    _loadNotas(j['id'] as String);
  }

  Future<void> _loadNotas(String jugadorId) async {
    try {
      final res = await Supabase.instance.client
          .from('fiscal_notas')
          .select()
          .eq('jugador_id', jugadorId)
          .order('created_at', ascending: false);
      if (mounted) setState(() => _notas = List<Map<String, dynamic>>.from(res));
    } catch (e) {
      debugPrint('Error loading notas: $e');
    }
  }

  Future<void> _guardarNota() async {
    final texto = _notaCtrl.text.trim();
    if (texto.isEmpty || _jugadorSel == null) return;
    final uid = Supabase.instance.client.auth.currentUser?.id;
    if (uid == null) return;
    setState(() => _guardandoNota = true);
    try {
      final fn = (_fiscalPerfil?['nombre'] as String? ?? '').trim();
      final fa = (_fiscalPerfil?['apellido'] as String? ?? '').trim();
      await Supabase.instance.client.from('fiscal_notas').insert({
        'jugador_id': _jugadorSel!['id'],
        'fiscal_id': uid,
        'fiscal_nombre': '$fn $fa'.trim(),
        'nota': texto,
      });
      _notaCtrl.clear();
      await _loadNotas(_jugadorSel!['id'] as String);
    } catch (e) {
      _toast('Error al guardar nota: $e', error: true);
    } finally {
      if (mounted) setState(() => _guardandoNota = false);
    }
  }

  Future<void> _guardarCategoria() async {
    if (_jugadorSel == null) return;
    setState(() => _guardando = true);
    try {
      final fiscalNombre = '${_fiscalPerfil?['nombre'] ?? ''} ${_fiscalPerfil?['apellido'] ?? ''}'.trim();
      await Supabase.instance.client.from('usuarios').update({
        'categoria': _nuevaCat > 0 ? _nuevaCat : null,
        'categoria_observada': _catObs > 0 ? _catObs : null,
        'categorizado_por_nombre': fiscalNombre.isNotEmpty ? fiscalNombre : null,
        'categorizado_fecha': DateTime.now().toIso8601String(),
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
    _tabCtrl.dispose(); _buscarCtrl.dispose(); _notaCtrl.dispose();
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
                  // Sign back in as jugador if there's a saved session
                  if (context.mounted) {
                    Navigator.pushAndRemoveUntil(context,
                      MaterialPageRoute(builder: (_) => const HomeScreen()), (_) => false);
                  }
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

  Widget _tabJugadores() {
    final hayFiltros = _filtroMano.isNotEmpty || _filtroLado.isNotEmpty || _filtroCat > 0;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Buscador en tiempo real
        TextField(
          controller: _buscarCtrl,
          style: const TextStyle(color: Colors.white),
          onChanged: (val) {
            setState(() {});
            _buscar();
          },
          decoration: InputDecoration(
            labelText: 'Buscar por nombre, apellido o DNI',
            prefixIcon: const Icon(Icons.search, color: AppColors.white30),
            suffixIcon: _buscarCtrl.text.isNotEmpty
                ? IconButton(icon: const Icon(Icons.clear, color: AppColors.white30),
                    onPressed: () { _buscarCtrl.clear(); _buscar(); setState(() {}); })
                : null,
          ),
        ),
        const SizedBox(height: 10),

        // Filtros desplegables
        GestureDetector(
          onTap: () => setState(() => _showFiltros = !_showFiltros),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: hayFiltros ? AppColors.blue.withOpacity(0.15) : AppColors.white05,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: hayFiltros ? AppColors.blueBright : AppColors.white10),
            ),
            child: Row(children: [
              Icon(Icons.filter_list, color: hayFiltros ? AppColors.blueBright : AppColors.white30, size: 18),
              const SizedBox(width: 8),
              Text(
                hayFiltros ? 'Filtros activos' : 'Filtros',
                style: GoogleFonts.barlowCondensed(fontSize: 14, letterSpacing: 1,
                  color: hayFiltros ? AppColors.blueBright : AppColors.white30),
              ),
              if (hayFiltros) ...[
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(color: AppColors.blueBright, borderRadius: BorderRadius.circular(10)),
                  child: Text(
                    [if (_filtroMano.isNotEmpty) _filtroMano, if (_filtroLado.isNotEmpty) _filtroLado, if (_filtroCat > 0) '${_filtroCat}a'].join(' · '),
                    style: GoogleFonts.barlowCondensed(fontSize: 11, color: Colors.white),
                  ),
                ),
              ],
              const Spacer(),
              Icon(_showFiltros ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                color: AppColors.white30, size: 18),
            ]),
          ),
        ),

        // Panel de filtros
        if (_showFiltros) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.navy3,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.white10),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // Mano
              Text('Mano hábil', style: GoogleFonts.barlowCondensed(fontSize: 11, letterSpacing: 2, color: AppColors.white30)),
              const SizedBox(height: 6),
              Wrap(spacing: 8, children: [
                _filtroChip('Todas', _filtroMano.isEmpty, () => setState(() { _filtroMano = ''; _buscar(); })),
                _filtroChip('Derecha', _filtroMano == 'derecha', () => setState(() { _filtroMano = 'derecha'; _buscar(); })),
                _filtroChip('Zurda', _filtroMano == 'zurda', () => setState(() { _filtroMano = 'zurda'; _buscar(); })),
              ]),
              const SizedBox(height: 12),
              // Lado
              Text('Lado de cancha', style: GoogleFonts.barlowCondensed(fontSize: 11, letterSpacing: 2, color: AppColors.white30)),
              const SizedBox(height: 6),
              Wrap(spacing: 8, children: [
                _filtroChip('Todos', _filtroLado.isEmpty, () => setState(() { _filtroLado = ''; _buscar(); })),
                _filtroChip('Drive', _filtroLado == 'drive', () => setState(() { _filtroLado = 'drive'; _buscar(); })),
                _filtroChip('Revés', _filtroLado == 'reves', () => setState(() { _filtroLado = 'reves'; _buscar(); })),
                _filtroChip('Ambos', _filtroLado == 'ambos', () => setState(() { _filtroLado = 'ambos'; _buscar(); })),
              ]),
              const SizedBox(height: 12),
              // Categoria
              Text('Categoría', style: GoogleFonts.barlowCondensed(fontSize: 11, letterSpacing: 2, color: AppColors.white30)),
              const SizedBox(height: 6),
              Wrap(spacing: 8, runSpacing: 6, children: [
                _filtroChip('Todas', _filtroCat == 0, () => setState(() { _filtroCat = 0; _buscar(); })),
                ...List.generate(8, (i) {
                  final cat = i + 1;
                  return _filtroChip('${cat}a', _filtroCat == cat,
                    () => setState(() { _filtroCat = _filtroCat == cat ? 0 : cat; _buscar(); }),
                    color: AppColors.categoryColor(cat));
                }),
              ]),
              if (hayFiltros) ...[
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () => setState(() { _filtroMano = ''; _filtroLado = ''; _filtroCat = 0; _buscar(); }),
                  child: Row(children: [
                    const Icon(Icons.clear_all, color: AppColors.red, size: 16),
                    const SizedBox(width: 6),
                    Text('Limpiar filtros', style: GoogleFonts.barlowCondensed(fontSize: 13, color: AppColors.red, letterSpacing: 0.5)),
                  ]),
                ),
              ],
            ]),
          ),
        ],
        const SizedBox(height: 16),

        // Resultados
        if (_buscando)
          const Center(child: Padding(padding: EdgeInsets.all(24),
            child: CircularProgressIndicator(color: AppColors.blueBright, strokeWidth: 2)))
        else if (_resultados.isEmpty && _buscarCtrl.text.isNotEmpty)
          Center(child: Padding(padding: const EdgeInsets.all(24),
            child: Text('Sin resultados', style: GoogleFonts.barlowCondensed(fontSize: 15, color: AppColors.white30))))
        else if (_buscarCtrl.text.isEmpty && !_filtroMano.isNotEmpty && !_filtroLado.isNotEmpty && _filtroCat == 0)
          Center(child: Padding(padding: const EdgeInsets.all(24),
            child: Column(children: [
              const Icon(Icons.search, color: AppColors.white30, size: 40),
              const SizedBox(height: 8),
              Text('Escribí un nombre, apellido o DNI', style: GoogleFonts.barlowCondensed(fontSize: 14, color: AppColors.white30)),
              Text('o usá los filtros para buscar', style: GoogleFonts.barlow(fontSize: 12, color: AppColors.white30)),
            ])))
        else
          ..._resultados.map((j) => _jugadorTile(j)),

        // Panel jugador seleccionado
        if (_jugadorSel != null) ...[
          const SizedBox(height: 20),
          _panelJugadorSel(),
        ],
      ]),
    );
  }

  Widget _panelJugadorSel() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white05,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.yellow.withOpacity(0.3)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Header jugador
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(children: [
            ProfileAvatar(
              fotoUrl: _jugadorSel!['foto_url'] as String?,
              initials: () { final n = _jugadorSel!['nombre'] as String? ?? ''; final a = _jugadorSel!['apellido'] as String? ?? ''; return n.isNotEmpty ? '${n[0]}${a.isNotEmpty ? a[0] : ''}'.toUpperCase() : 'J'; }(),
              categoria: (_jugadorSel!['categoria'] as int?) ?? 0,
              categoriaObservada: _jugadorSel!['categoria_observada'] as int?,
              radius: 24,
            ),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('${_jugadorSel!['nombre'] ?? ''} ${_jugadorSel!['apellido'] ?? ''}',
                style: GoogleFonts.bebasNeue(fontSize: 20, color: Colors.white)),
              Text('DNI: ${_jugadorSel!['dni'] ?? ''} · ${_jugadorSel!['localidad'] ?? _jugadorSel!['distrito'] ?? ''}',
                style: GoogleFonts.barlow(fontSize: 12, color: AppColors.white30)),
            ])),
            IconButton(onPressed: () => setState(() { _jugadorSel = null; _notas = []; }),
              icon: const Icon(Icons.close, color: AppColors.white30, size: 20)),
          ]),
        ),

        const Divider(color: AppColors.white10, height: 1),

        // Tabs dentro del panel
        DefaultTabController(
          length: 2,
          child: Column(children: [
            TabBar(
              labelColor: AppColors.yellow,
              unselectedLabelColor: AppColors.white30,
              indicatorColor: AppColors.yellow,
              labelStyle: GoogleFonts.barlowCondensed(fontSize: 13, fontWeight: FontWeight.w600, letterSpacing: 1),
              tabs: const [Tab(text: 'CATEGORÍA'), Tab(text: 'NOTAS')],
            ),
            SizedBox(
              height: 380,
              child: TabBarView(children: [
                // Tab Categoria
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Categoría', style: GoogleFonts.barlowCondensed(fontSize: 11, letterSpacing: 2, color: AppColors.white30)),
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
                    const SizedBox(height: 16),
                    Text('En observación para ascenso', style: GoogleFonts.barlowCondensed(fontSize: 11, letterSpacing: 2, color: AppColors.white30)),
                    const SizedBox(height: 8),
                    Wrap(spacing: 8, runSpacing: 8, children: [
                      GestureDetector(
                        onTap: () => setState(() => _catObs = 0),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: _catObs == 0 ? AppColors.white10 : AppColors.white05,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: _catObs == 0 ? Colors.white : AppColors.white10, width: _catObs == 0 ? 2 : 1),
                          ),
                          child: Text('Ninguna', style: GoogleFonts.barlowCondensed(fontSize: 14, fontWeight: FontWeight.w600, color: _catObs == 0 ? Colors.white : AppColors.white30)),
                        ),
                      ),
                      ...List.generate(8, (i) {
                        final cat = i + 1;
                        final color = AppColors.categoryColor(cat);
                        final active = _catObs == cat;
                        return GestureDetector(
                          onTap: () => setState(() => _catObs = cat),
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
                      }),
                    ]),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _guardando ? null : _guardarCategoria,
                      child: _guardando
                          ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : Text('GUARDAR CATEGORÍA', style: GoogleFonts.barlowCondensed(fontSize: 16, fontWeight: FontWeight.w700, letterSpacing: 2)),
                    ),
                  ]),
                ),

                // Tab Notas
                _tabNotas(),
              ]),
            ),
          ]),
        ),
      ]),
    );
  }

  Widget _tabNotas() {
    return Column(children: [
      // Lista de notas existentes
      Expanded(
        child: _notas.isEmpty
            ? Center(child: Text('Sin notas aún', style: GoogleFonts.barlowCondensed(fontSize: 14, color: AppColors.white30)))
            : ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: _notas.length,
                itemBuilder: (_, i) {
                  final nota = _notas[i];
                  final fecha = nota['created_at'] != null
                      ? () { try { final d = DateTime.parse(nota['created_at']).toLocal(); return '${d.day.toString().padLeft(2,'0')}/${d.month.toString().padLeft(2,'0')}/${d.year}'; } catch(_) { return ''; } }()
                      : '';
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.navy3,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.white10),
                    ),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(children: [
                        const Icon(Icons.person_outline, color: AppColors.blueBright, size: 13),
                        const SizedBox(width: 4),
                        Text(nota['fiscal_nombre'] ?? 'Fiscal', style: GoogleFonts.barlowCondensed(fontSize: 12, color: AppColors.blueBright, letterSpacing: 0.5)),
                        const Spacer(),
                        Text(fecha, style: GoogleFonts.barlow(fontSize: 11, color: AppColors.white30)),
                      ]),
                      const SizedBox(height: 6),
                      Text(nota['nota'] ?? '', style: GoogleFonts.barlow(fontSize: 13, color: Colors.white)),
                    ]),
                  );
                },
              ),
      ),
      // Campo nueva nota
      Container(
        padding: const EdgeInsets.all(12),
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.white10)),
        ),
        child: Row(children: [
          Expanded(
            child: TextField(
              controller: _notaCtrl,
              onChanged: (_) => setState(() {}),
              style: const TextStyle(color: Colors.white, fontSize: 14),
              maxLines: 2,
              decoration: InputDecoration(
                hintText: 'Agregar observación sobre el jugador...',
                hintStyle: const TextStyle(color: AppColors.white30, fontSize: 13),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                filled: true,
                fillColor: AppColors.navy3,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.white10)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.white10)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.blueBright)),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: _guardandoNota ? null : _guardarNota,
            child: Container(
              width: 44, height: 44,
              decoration: BoxDecoration(
                color: _notaCtrl.text.trim().isNotEmpty ? AppColors.blue : AppColors.white05,
                borderRadius: BorderRadius.circular(10),
              ),
              child: _guardandoNota
                  ? const Center(child: SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)))
                  : const Icon(Icons.send, color: Colors.white, size: 18),
            ),
          ),
        ]),
      ),
    ]);
  }

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