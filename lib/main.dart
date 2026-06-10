import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'theme/app_colors.dart';
import 'screens/splash_screen.dart';

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
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.white10),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.white10),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.blueBright, width: 2),
          ),
          labelStyle: const TextStyle(color: AppColors.white30),
          hintStyle: const TextStyle(color: AppColors.white30),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.blue,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      localizationsDelegates: [
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
