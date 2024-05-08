// import 'package:flutter/material.dart';
// import 'package:otp_text_field/otp_field.dart';
// import 'package:otp_text_field/style.dart';
// import 'package:saifulhamid_totalx_machine_task/screens/otp_verification/refactor_otp_verification_page.dart';
// import 'package:saifulhamid_totalx_machine_task/screens/user_listing/user_listing_page.dart';

// class OtpVerificationPage extends StatelessWidget {
//   // final String userPhoneNumber;

//   const OtpVerificationPage(
//       {super.key,
//         required String phoneNumber,
//         required String verificationId});

//   @override
//   Widget build(BuildContext context) {
//     // String maskedPhoneNumber =
//     //     '******${userPhoneNumber.substring(userPhoneNumber.length - 3)}';

//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(height: 120),
//               // const ImageInOtpVerificationPage(),
//               const SizedBox(height: 50),
//               const Text(
//                 "OTP Verification",
//                 style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.w500,
//                     letterSpacing: 1),
//               ),
//               const SizedBox(height: 25),
//               Text(""
//                 // "Enter verification code we just sent to your number $maskedPhoneNumber",
//                 // style: const TextStyle(fontSize: 17, letterSpacing: 1),
//               ),
//               const SizedBox(height: 25),
//               const OtpTextField(),
//               const SizedBox(height: 30),
//               const VerifyButton()
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
