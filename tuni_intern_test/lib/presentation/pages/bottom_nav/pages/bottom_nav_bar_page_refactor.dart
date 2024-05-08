import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../../Cart/cart_page.dart';
import '../../Home/home_page.dart';
import '../../caterory/categories.dart';
import '../../profile/user_profile/profile.dart';

List<GButton> bottomNavItems = const <GButton>[
  GButton(
    icon: Icons.home,
    iconColor: Colors.grey,
    text: 'Home',
  ),
  GButton(
    icon: Icons.apps_rounded,
    iconColor: Colors.grey,
    text: 'Categories',
  ),
  GButton(
    icon: Icons.shopping_bag,
    iconColor: Colors.grey,
    text: 'Cart',
  ),
  GButton(
    icon: Icons.person,
    iconColor: Colors.grey,
    text: 'Profile',
  ),
];

List<Widget> bottomNavScreen = <Widget>[
  HomePage(),
  const Categories(),
  const CartPage(),
  ProfilePage()

];
