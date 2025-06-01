import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skinai/views/home_screen.dart';
import 'package:skinai/views/register_screen.dart';

import '../appservices/image_picker_service.dart';
import '../constants/colors.dart';
import '../constants/size_config.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  final key = GlobalKey<FormState>();
  bool isHidden = true;
  bool isProcessing = false;

  loginUser() async {
    try {
      setState(() {
        isProcessing = true;
      });

      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.text.toLowerCase().toString(),
          password: password.text.toLowerCase().toString());

      final SharedPreferences userLog = await SharedPreferences.getInstance();
      userLog.setString("email", email.text.toLowerCase().toString());

      ImagePickerService.customMessage(context, "Login Successfully", 0);

      setState(() {
        isProcessing = false;
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        isProcessing = false;
      });
      ImagePickerService.customMessage(context, e.code, 1);
      throw Exception(e);
    }
  }

  void passwordHideShow() {
    setState(() {
      isHidden = !isHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) => exit(0),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: GestureDetector(
          onTap: (){
            FocusScope.of(context).unfocus();
          },
          child: SafeArea(
            child: Center(
              child: ListView(
                padding: const EdgeInsets.all(24),
                // shrinkWrap: true,
                children: [
                  Column(
                    children: [
                      Container(
                        width: 150,
                        height: 150,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image:
                            AssetImage('images/APPLOGO.png'),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Welcome\nBack!',
                          style: TextStyle(
                            fontSize: 28,
                            color: successColor,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.1,
                            fontFamily: 'Zolina',
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Good to see you again.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                            fontFamily: 'Zolina',
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Form
                      Form(
                        key: key,
                        child: Column(
                          children: [
                            TextFormField(
                              cursorColor:successColor,
                              controller: email,
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return ("Email is Required");
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                hintText: 'Enter your email',
                                hintStyle: TextStyle(fontSize: 14),
                                prefixIcon: const Icon(Icons.email_outlined),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: successColor),
                                  borderRadius: BorderRadius.circular(16),

                                ),

                              ),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              cursorColor: successColor,
                              controller: password,
                              obscureText: isHidden,
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return ("Password is Required");
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                hintText: 'Enter your password',
                                hintStyle: TextStyle(fontSize: 14),
                                prefixIcon: const Icon(Icons.lock_outline),
                                suffixIcon: IconButton(
                                  icon: Icon(isHidden
                                      ? Icons.visibility_off
                                      : Icons.visibility),
                                  onPressed: passwordHideShow,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: successColor),
                                  borderRadius: BorderRadius.circular(16),

                                ),
                              ),
                            ),
                            const SizedBox(height: 3),

                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {},
                                child: Text(
                                  'Forgot Password?',
                                  style: TextStyle(color: Colors.grey.shade600),
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),

                            isProcessing
                                ? const SpinKitFadingCircle(
                              color: successColor,
                              size: 40.0,
                            )
                                : SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: () {
                                  if (key.currentState!.validate()) {
                                    loginUser();
                                  }
                                },
                                child: const Text(
                                  "Sign In",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              ),
                            ),
                            const SizedBox(height: 25),


                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("Not a member? "),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => RegisterScreen(),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    "Register now",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
