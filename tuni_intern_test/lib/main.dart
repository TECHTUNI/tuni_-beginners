import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:tuni/core/provider/product_provider.dart';
import 'package:tuni/firebase_options.dart';
import 'package:tuni/presentation/bloc/address_bloc/address_bloc.dart';
import 'package:tuni/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:tuni/presentation/bloc/auth_bloc/auth_repository.dart';
import 'package:tuni/presentation/bloc/bnb_bloc/bottom_nav_bloc.dart';
import 'package:tuni/presentation/bloc/cart_bloc/cart_bloc.dart';
import 'package:tuni/presentation/bloc/favorite_bloc/favorite_bloc.dart';
import 'package:tuni/presentation/bloc/home_bloc/home_bloc.dart';
import 'package:tuni/presentation/bloc/home_bloc/size_bloc.dart';
import 'package:tuni/presentation/bloc/personal_details_bloc/personal_detail_bloc.dart';
import 'package:tuni/presentation/bloc/user_profile_bloc/user_profile_bloc.dart';
import 'package:tuni/presentation/pages/bottom_nav/routes/generated_routes.dart';
import 'package:tuni/presentation/pages/splash_screen/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => AuthRepository(),
      child: MultiBlocProvider(
        providers: [
          ChangeNotifierProvider<ProductProvider>(
              create: (_) => ProductProvider()),
          BlocProvider(create: (context) => AuthBloc()),
          BlocProvider(create: (context) => BottomNavBloc()),
          BlocProvider(create: (context) => HomeBloc()),
          BlocProvider(create: (context) => CartBloc()),
          BlocProvider(create: (context) => AddressBloc()),
          BlocProvider(create: (context) => FavoriteBloc()),
          BlocProvider(create: (context) => PersonalDetailBloc()),
          BlocProvider(create: (context) => UserProfileBloc()),
          BlocProvider(create: (context) => SizeBloc()),
        ],
        child: Platform.isAndroid
            ? MaterialApp(
                title: 'TUNI',
                theme: ThemeData(
                    elevatedButtonTheme: ElevatedButtonThemeData(
                      style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.blue),
                      ),
                    ),
                    primaryColor: Colors.blue,
                    appBarTheme: const AppBarTheme(
                        titleTextStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                        centerTitle: true,
                        color: Colors.white,
                        elevation: 0),
                    scaffoldBackgroundColor: Colors.white),
                debugShowCheckedModeBanner: false,
                home: const SplashScreen(),
                initialRoute: '/',
                onGenerateRoute: RouteGenerator().generateRoute,
              )
            : CupertinoApp(
                title: 'TUNI',
                theme: const CupertinoThemeData(
                  brightness: Brightness.light,
                  primaryColor: CupertinoColors.activeBlue,
                  scaffoldBackgroundColor: CupertinoColors.white,
                  barBackgroundColor: CupertinoColors.white,
                  textTheme: CupertinoTextThemeData(),
                ),
                debugShowCheckedModeBanner: false,
                home: const SplashScreen(),
                initialRoute: '/',
                onGenerateRoute: RouteGenerator().generateRoute,
              ),
      ),
    );
  }
}
