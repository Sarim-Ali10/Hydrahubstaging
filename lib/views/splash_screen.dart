import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skinai/views/home_screen.dart';
import '../pageview/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  Future getUserDetails()async{
    final SharedPreferences userLog = await SharedPreferences.getInstance();
    var email = userLog.getString("email");
    return email;
  }

  @override
  void initState() {
    // TODO: implement initState
    getUserDetails().then((val){
      if(val != null){
        Timer(const Duration(seconds: 3), () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>  const HomeScreen()),
          );
        });
      } else{
        Timer(const Duration(seconds: 3), () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>  const OnboardingScreen()),
          );
        });
      }
    });
    super.initState();
    navigateToNextScreen();
  }

  void navigateToNextScreen() {
    Timer(const Duration(seconds: 3), () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>  const OnboardingScreen()),
      );
    });
  }


  @override
  Widget build(BuildContext context) {
    return const PopScope(
      canPop: false,
      child: SafeArea(
        child: Scaffold(
            body: Center(
              child: Stack(
                children: [
                  SizedBox(
                      height: 300,
                      width: 300,
                      child: Image(
                          fit: BoxFit.contain,
                          image: AssetImage('images/APPLOGO.png'))),
                ],
              ),
            )
        ),
      ),
    );
  }
}
