import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tuni/presentation/pages/Home/home_page.dart';
import '../../bottom_nav/pages/bottom_nav_bar_page.dart';
import '../sign_up/refactor.dart';
import 'login_refactor.dart';

class LogInPage extends StatelessWidget {
  final void Function()? onTap;

  LogInPage({super.key, this.onTap});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  final TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Platform.isAndroid
        ? Scaffold(
            backgroundColor: Colors.grey.shade200,
            body: SafeArea(
              child: SingleChildScrollView(
                child: SizedBox(
                  width: screenWidth,
                  height: screenHeight,
                  child: Column(
                    children: [
                      sizedBox(height: screenHeight * 0.2),
                      const LoginWelcomeMessage(),
                      LoginCollectingEmailAndPassword(
                          emailController: emailController,
                          screenWidth: screenWidth,
                          passwordController: passwordController),
                    ],
                  ),
                ),
              ),
            ),
            bottomNavigationBar: LoginBottomAppBar(),
          )
        : CupertinoPageScaffold(
            backgroundColor: CupertinoColors.systemGrey6,
            child: SingleChildScrollView(
              child: SafeArea(
                child: SizedBox(
                  // color: Colors.amberAccent,
                  height: screenHeight * .88,
                  width: screenWidth,
                  child: Column(
                    children: [
                      Container(
                        height: 200,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(
                                    "Assets/logo/tunifulllogo.png"))),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const LoginWelcomeMessage(),
                            sizedBox(height: screenHeight * 0.05),
                            SizedBox(
                              height: 40,
                              child: CupertinoTextField(
                                padding: const EdgeInsets.only(left: 20),
                                keyboardType: TextInputType.emailAddress,
                                controller: emailController,
                                placeholder: "Email",
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: CupertinoColors.white),
                              ),
                            ),
                            // const SizedBox(height: 20),
                            // SizedBox(
                            //   height: 40,
                            //   child: CupertinoTextField(
                            //     padding: const EdgeInsets.only(left: 20),
                            //     obscureText: true,
                            //     controller: otpController,
                            //     placeholder: "Enter OTP",
                            //     decoration: BoxDecoration(
                            //         borderRadius: BorderRadius.circular(8),
                            //         color: CupertinoColors.white),
                            //   ),
                            // ),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.end,
                            //   children: [
                            //     CupertinoButton(
                            //         padding: EdgeInsets.zero,
                            //         child: Text("Resent OTP"),
                            //         onPressed: () {}),
                            //     SizedBox(width: 15)
                            //   ],
                            // ),
                            const SizedBox(height: 20),
                            Center(
                              child: SizedBox(
                                width: 150,
                                child: CupertinoButton.filled(
                                    padding: EdgeInsets.zero,
                                    child: Text("Get OTP"),
                                    onPressed: () async {
                                      try {
                                        await FirebaseAuth.instance
                                            .verifyPhoneNumber(
                                          verificationCompleted:
                                              (PhoneAuthCredential
                                                  credential) {},
                                          verificationFailed:
                                              (FirebaseAuthException ex) {},
                                          codeSent: (String verificationId,
                                              int? resentOTP) {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      HomePage(),
                                                ));
                                          },
                                          codeAutoRetrievalTimeout:
                                              (String verificationId) {},
                                          phoneNumber:
                                              phoneController.text.toString(),
                                        );
                                      } catch (e) {
                                        throw e.toString();
                                      }
                                    }),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      CupertinoButton(
                          padding: EdgeInsets.zero,
                          child: const Text("CONTINUE AS GUEST"),
                          onPressed: () async {
                            try {
                              // final userCredential =
                              await FirebaseAuth.instance.signInAnonymously();
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) =>
                                        const BottomNavBarPage(),
                                  ),
                                  (route) => false);
                            } on FirebaseAuthException catch (e) {
                              switch (e.code) {
                                case "operation-not-allowed":
                                  break;
                                default:
                              }
                            }
                          }),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
// BlocListener<AuthBloc, AuthState>(
//   listener: (context, state) {
//     if (state is LoadingState) {
//     } else if (state is Authenticated) {
//       Navigator.pushAndRemoveUntil(
//           context,
//           CupertinoPageRoute(
//             builder: (context) =>
//                 const BottomNavBarPage(),
//           ),
//           (route) => false);
//     } else if (state is AuthenticationError) {
//       showCupertinoDialog(
//         context: context,
//         builder: (context) {
//           return CupertinoAlertDialog(
//             title: const Text('Sign In Failed'),
//             content: const Text(
//                 "Email and Password doesn't match."),
//             actions: [
//               CupertinoDialogAction(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//                 child: const Text('OK'),
//               ),
//             ],
//           );
//         },
//       );
//     }
//   },
//   child: Center(
//     child: CupertinoButton.filled(
//         child: const Text("Login"),
//         onPressed: () {
//           if (emailController.text.isEmpty ||
//               passwordController.text.isEmpty) {
//             showCupertinoDialog(
//               context: context,
//               builder: (context) {
//                 return CupertinoAlertDialog(
//                   title:
//                       const Text('Empty Fields!!'),
//                   content: const Text(
//                       "Mandatory fields can't be empty"),
//                   actions: [
//                     CupertinoDialogAction(
//                         onPressed: () {
//                           Navigator.pop(context);
//                         },
//                         child: const Text("OK")),
//                   ],
//                 );
//               },
//             );
//           } else {
//             context.read<AuthBloc>().add(
//                 SignInRequestEvent(
//                     email: emailController.text,
//                     password:
//                         passwordController.text));
//             emailController.clear();
//             passwordController.clear();
//           }
//         }),
//   ),
// )
