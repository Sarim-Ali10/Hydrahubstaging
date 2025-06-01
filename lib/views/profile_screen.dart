import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skinai/constants/colors.dart';
import 'package:skinai/views/login_screen.dart';

class ProfilePage extends StatelessWidget {


  Future<Map<String, dynamic>?> fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? username = prefs.getString('username');
    String? userEmail = prefs.getString('email');
    String? userImage = prefs.getString('userImage');

    if (username != null && userEmail != null && userImage != null) {
      return {
        'userName': username,
        'userEmail': userEmail,
        'userImage': userImage,
      };
    }

    // If not in prefs, fetch from Firestore
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      await FirebaseAuth.instance.authStateChanges().first;
      currentUser = FirebaseAuth.instance.currentUser;
    }

    if (currentUser != null) {
      final query = await FirebaseFirestore.instance
          .collection('AppUsers')
          .where('userEmail', isEqualTo: currentUser.email)
          .get();

      if (query.docs.isNotEmpty) {
        final userData = query.docs.first.data();

        // Save to SharedPreferences
        await prefs.setString('username', userData['userName']);
        await prefs.setString('email', userData['userEmail']);
        await prefs.setString('userImage', userData['userImage']);

        return userData;
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>?>(
        future: fetchUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: SpinKitFadingCircle(
                color: successColor,
                size: 50.0,
              ),
            );
          }else if (snapshot.hasError) {
            return const Center(child: Text('Error fetching data'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No user data found'));
          }

          final userData = snapshot.data!;
          return Column(
            children: [
              Stack(
                children: [
                  ClipPath(
                    clipper: WaveClipper(),
                    child: Container(
                      height: 190,
                      color: successColor,
                    ),
                  ),
                  Positioned(
                    top: 40,
                    left: 0,
                    right: 0,
                    child: Column(
                      children: [
                        const Text(
                          'Profile',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(userData['userImage']),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              InfoTile(
                icon: Icons.person,
                label: 'Name',
                value: userData['userName'],
              ),
              InfoTile(
                icon: Icons.email,
                label: 'E-Mail',
                value: userData['userEmail'],
              ),
              const SizedBox(height: 36),
              Padding(
                padding: const EdgeInsets.all(24),
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();

                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    await prefs.clear();

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text("Sign Out"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const InfoTile({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    )),
                const SizedBox(height: 2),
                Text(value,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 80);
    path.quadraticBezierTo(
      size.width / 2, size.height,
      size.width, size.height - 80,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
