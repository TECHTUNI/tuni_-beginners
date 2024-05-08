import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../auth/sign_in/login.dart';

class AndroidAnonymousUserProfilePage extends StatelessWidget {
  const AndroidAnonymousUserProfilePage({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
  });

  final double screenHeight;
  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: SizedBox(
          height: screenHeight,
          width: screenWidth,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * .2),
              const Center(
                child: CircleAvatar(
                  backgroundColor: Colors.black,
                  radius: 70,
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 60,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  FirebaseAuth.instance.currentUser?.delete();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LogInPage(),
                      ),
                      (route) => false);
                },
                child: const Text("Login"),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
