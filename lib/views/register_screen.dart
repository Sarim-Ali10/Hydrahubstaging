import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skinai/appservices/image_picker_service.dart';
import 'package:uuid/uuid.dart';

import '../constants/colors.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final key = GlobalKey<FormState>();

  File? userImage;
  bool isImagePicked = false;
  bool isHidden = true;
  bool isProcessing = false;

  void getUserImage() async {
    XFile? pickImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickImage != null) {
      setState(() {
        userImage = File(pickImage.path);
        isImagePicked = true;
      });
    }
  }

  void passwordHideShow() {
    setState(() {
      isHidden = !isHidden;
    });
  }

  Future<String> uploadUserImage(String userID) async {
    if (userImage != null) {
      try {
        UploadTask uploadTask = FirebaseStorage.instance
            .ref()
            .child("AppUsers")
            .child(userID)
            .putFile(userImage!);
        TaskSnapshot taskSnapshot = await uploadTask;
        String imageUrl = await taskSnapshot.ref.getDownloadURL();
        return imageUrl;
      } catch (e) {
        throw Exception(e);
      }
    } else {
      ImagePickerService.customMessage(context, "Image Required", 1);
      throw Exception("No image selected");
    }
  }

  Future<void> addDataToFirebase() async {
    try {
      setState(() => isProcessing = true);

      final id = const Uuid().v1();
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );

      String imageUrl = await uploadUserImage(id);

      await FirebaseFirestore.instance.collection("AppUsers").add({
        "userID": id,
        "userImage": imageUrl,
        "userName": name.text,
        "userEmail": email.text.trim(),
        "userPassword": password.text.trim(),
      });
      // Save user data locally
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('username', name.text);
      prefs.setString('email', email.text.trim());
      prefs.setString('userImage', imageUrl);


      ImagePickerService.customMessage(context, "Account Created Successfully", 0);
      Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
    } on FirebaseAuthException catch (e) {
      ImagePickerService.customMessage(context, e.message ?? "Failed to Create User", 1);
    } finally {
      setState(() => isProcessing = false);
    }
  }

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Form(
          key: key,
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              const SizedBox(height: 20),
              Center(
                child: GestureDetector(
                  onTap: getUserImage,
                  child: CircleAvatar(
                    radius: 64,
                    backgroundColor: Colors.grey.shade100,
                    backgroundImage: isImagePicked ? FileImage(userImage!) : null,
                    child: !isImagePicked ? const Icon(Icons.person, size: 50, color: Colors.grey) : null,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Text(
                  'Create Account!',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Zolina',
                  ),
                ),
              ),
              const SizedBox(height: 25),
              TextFormField(
                controller: name,
                cursorColor: successColor,

                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person_2_outlined),
                  hintText: 'Username',
                  hintStyle: TextStyle(fontSize: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: successColor),
                    borderRadius: BorderRadius.circular(16),

                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                cursorColor: successColor,
                controller: email,
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return ("Email is Required");
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'Email',
                  hintStyle: TextStyle(fontSize: 14),
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: successColor),
                    borderRadius: BorderRadius.circular(16),

                  ),
                ),
              ),
              const SizedBox(height: 10),
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
                  hintText: 'Password',
                  hintStyle: TextStyle(fontSize: 14),
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(isHidden ? Icons.visibility_off : Icons.visibility),
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

              const SizedBox(height: 30),
              isProcessing
                  ? const Center(child: SpinKitFadingCircle(
                color: successColor,
                size: 40.0,
              ))
                  : SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    if (key.currentState!.validate()) {
                      addDataToFirebase();
                    }
                  },
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Divider(),

              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Already have an Account?', style: TextStyle(color: Colors.grey[700])),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
                    },
                    child: const Text(
                      'Sign in',
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
