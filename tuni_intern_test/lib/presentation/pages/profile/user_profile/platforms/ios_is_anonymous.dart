import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../auth/sign_in/login.dart';

class IosAnonymousUserProfilePage extends StatelessWidget {
  const IosAnonymousUserProfilePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        child: Center(
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * .2,
          ),
          const CircleAvatar(
            backgroundColor: CupertinoColors.black,
            radius: 70,
            child: Icon(
              CupertinoIcons.person_crop_circle_fill_badge_exclam,
              color: CupertinoColors.white,
              size: 60,
            ),
          ),
          const SizedBox(height: 15),
          CupertinoButton(
              child: const Text(
                "Login",
                style: TextStyle(
                    fontSize: 25,
                    letterSpacing: 2,
                    fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                FirebaseAuth.instance.currentUser?.delete();
                Navigator.pushAndRemoveUntil(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => LogInPage(),
                    ),
                    (route) => false);
              })
        ],
      ),
    ));
  }
}
