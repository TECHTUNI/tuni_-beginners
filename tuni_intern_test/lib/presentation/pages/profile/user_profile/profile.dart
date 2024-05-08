import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tuni/presentation/pages/profile/user_profile/platforms/android_is_anonymous.dart';
import 'package:tuni/presentation/pages/profile/user_profile/platforms/android_user_profile_page.dart';
import 'package:tuni/presentation/pages/profile/user_profile/platforms/ios_is_anonymous.dart';
import 'package:tuni/presentation/pages/profile/user_profile/platforms/ios_user_profile_page.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final userId = user!.uid;
    final String userEmail = user?.email ?? "";
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    if (user != null && user!.isAnonymous) {
      if (Platform.isIOS) {
        return const IosAnonymousUserProfilePage();
      } else {
        return AndroidAnonymousUserProfilePage(
            screenHeight: screenHeight, screenWidth: screenWidth);
      }
    } else {
      if (Platform.isIOS) {
        return IosUserProfilePage(
            userId: userId, userEmail: userEmail, screenWidth: screenWidth);
      } else {
        return AndroidUserProfilePage(
            userId: userId, userEmail: userEmail, screenWidth: screenWidth);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    ProfilePage();
  }
}




