// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
//
// import '../../../../core/model/product_order_model.dart';
// import '../../auth/sign_in/login.dart';
// import '../cart_refactor.dart';
// import '../checkout/select_address.dart';
//
// class Android extends StatefulWidget {
//   Android({
//     super.key,
//     required this.itemCount,
//     required this.firestore,
//     required this.total,
//     required this.screenHeight,
//     required this.screenWidth,
//     required this.productIds,
//   });
//
//   final int itemCount;
//   final Stream<QuerySnapshot<Map<String, dynamic>>> firestore;
//   int total;
//   final double screenHeight;
//   final double screenWidth;
//   final List<OrderModel> productIds;
//
//   @override
//   State<Android> createState() => _AndroidState();
// }
//
// class _AndroidState extends State<Android> {
//   final User? user = FirebaseAuth.instance.currentUser;
//
//   updateTotal(int newTotal) {
//     setState(() {
//       widget.total = newTotal;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     debugPrint("current anonymous userId: ${user!.uid}");
//     if (user!.isAnonymous) {
//       return Scaffold(
//         appBar: AppBar(
//           title: const Text("CART"),
//         ),
//         body: SizedBox(
//           height: widget.screenHeight,
//           width: widget.screenWidth,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               SizedBox(height: widget.screenHeight * .2),
//               const Text("You are in ghost mode"),
//               const Text("Login to buy our products"),
//               TextButton(
//                   onPressed: () {
//                     FirebaseAuth.instance.currentUser?.delete();
//                     Navigator.pushAndRemoveUntil(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => LogInPage(),
//                         ),
//                         (route) => false);
//                   },
//                   child: const Text("Login now!"))
//             ],
//           ),
//         ),
//       );
//     } else {
//       return Scaffold(
//         // drawer: DrawerWidget(),
//         backgroundColor: Colors.white,
//         appBar: AppBar(
//           title: const Text(
//             'CART',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.w500,
//               letterSpacing: 2,
//             ),
//           ),
//           centerTitle: true,
//           foregroundColor: Colors.black,
//         ),
//         body: SingleChildScrollView(
//             child: Column(
//           children: [
//             cartItemsListingRefactor(
//                 itemCount: widget.itemCount,
//                 firestore: widget.firestore,
//                 total: widget.total,
//                 screenHeight: widget.screenHeight,
//                 screenWidth: widget.screenWidth,
//                 productIds: widget.productIds,
//                 updateTotal: updateTotal(widget.total)),
//           ],
//         )),
//         bottomNavigationBar: StreamBuilder<QuerySnapshot>(
//           stream: widget.firestore,
//           builder: (context, snapshot) {
//             if (snapshot.hasData) {
//               if (snapshot.data!.docs.isNotEmpty) {
//                 return BottomAppBar(
//                   elevation: 0,
//                   color: Colors.white,
//                   child: Padding(
//                     padding: const EdgeInsets.all(10),
//                     child: SizedBox(
//                         height: 45,
//                         child: ElevatedButton(
//                           onPressed: () {
//                             showDialog(
//                               context: context,
//                               builder: (context) {
//                                 return AlertDialog(
//                                   title: Text(
//                                       'Your Cart total is ₹${widget.total}/-'),
//                                   content: const Text("Proceed to checkout?"),
//                                   // content: Text(
//                                   //     'The total amount of your products is $total \n Go to checkout??'),
//                                   actions: [
//                                     TextButton(
//                                       onPressed: () {
//                                         Navigator.pop(context);
//                                       },
//                                       child: const Text('cancel',
//                                           style: TextStyle(color: Colors.red)),
//                                     ),
//                                     TextButton(
//                                       onPressed: () {
//                                         Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                             builder: (context) => SelectAddress(
//                                               orderList: widget.productIds,
//                                               total: widget.total,
//                                             ),
//                                           ),
//                                         );
//                                       },
//                                       child: const Text('Go to checkout'),
//                                     ),
//                                   ],
//                                 );
//                               },
//                             );
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.blueGrey,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(15),
//                             ),
//                           ),
//                           child: const Text("PROCEED TO CHECKOUT"),
//                         )),
//                   ),
//                 );
//               }
//             }
//             return const SizedBox();
//           },
//         ),
//       );
//     }
//   }
// }
