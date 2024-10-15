import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:super_lista/config/colors.dart';
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

      // Define the default brightness and colors.
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color.fromRGBO(33, 25, 81, 1),
        primary: SLcolors.secondary,
        secondary: SLcolors.primary,
        // ···
        brightness: Brightness.light,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        titleTextStyle: GoogleFonts.poppins(
          color: const Color.fromRGBO(33, 25, 81, 1),
          fontSize: 18,
          fontWeight: FontWeight.w900
        ),
      ),
      scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(backgroundColor: Color.fromRGBO(21, 245, 186, 1)),
      cardTheme: const CardTheme(shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10)))),
      textTheme: TextTheme(
          bodyMedium: GoogleFonts.poppins(),
          titleMedium: GoogleFonts.poppins(fontWeight: FontWeight.w800, color: SLcolors.titleBody),),
    );
  }
}
