import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skinai/api_key_secret.dart';
import 'package:skinai/constants/size_config.dart';
import 'package:skinai/firebase_options.dart';
import 'package:skinai/pageview/onboarding_screen.dart';
import 'package:skinai/views/splash_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Gemini.init(apiKey: secretApiKey, enableDebugging: true);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return  MaterialApp(
      home: SplashScreen(),
      title: 'Skin Disease Detector',
      theme: ThemeData(
          textTheme: GoogleFonts.poppinsTextTheme()
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

