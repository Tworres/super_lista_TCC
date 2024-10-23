import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:super_lista/utils/colors.dart';
import 'package:super_lista/screens/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Necessário para Flutter

  // Inicializa o Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        ...GlobalMaterialLocalizations.delegates,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [Locale('pt', 'BR')],
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: _themeDataSuperLista(context),
      home: const Home(),
    );
  }

  ThemeData _themeDataSuperLista(context) {
    return ThemeData(
      useMaterial3: true,
      fontFamily: GoogleFonts.poppins().fontFamily,

      // Define the default brightness and colors.
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color.fromRGBO(33, 25, 81, 1),
        primary: ColorsSl.secondary,
        secondary: ColorsSl.primary,
        // ···
        brightness: Brightness.light,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        titleTextStyle: GoogleFonts.poppins(color: const Color.fromRGBO(33, 25, 81, 1), fontSize: 18, fontWeight: FontWeight.w900),
      ),
      scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(backgroundColor: Color.fromRGBO(21, 245, 186, 1)),
      cardTheme: const CardTheme(shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10)))),
      textTheme: GoogleFonts.poppinsTextTheme(
        Theme.of(context).textTheme,
      ).copyWith(
        titleMedium: GoogleFonts.poppins(
          fontWeight: FontWeight.w800,
          color: ColorsSl.titleBodySecondary,
        ),
        labelMedium: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          color: ColorsSl.textBodySecondary,
        ),
        displayLarge: GoogleFonts.poppins(
          fontSize: 19,
          fontWeight: FontWeight.w800,
          color: ColorsSl.textBody
        ),
        displayMedium: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w800,
          color: ColorsSl.textBody
        ), 
        displaySmall: GoogleFonts.poppins(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: ColorsSl.textBody
        ),
        bodySmall: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: ColorsSl.textBody
        ),
      ),
    );
  }
}
