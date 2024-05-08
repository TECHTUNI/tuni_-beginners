import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/model/product_order_model.dart';
import '../../../bloc/cart_bloc/cart_bloc.dart';
import '../../auth/sign_in/login.dart';
import '../../caterory/pages_in_categories/category_all_page.dart';
import '../checkout/select_address.dart';

class Ios extends StatelessWidget {
  Ios({
    super.key,
    required this.itemCount,
    required this.firestore,
    required this.total,
    required this.screenHeight,
    required this.screenWidth,
    required this.productIds,
    required this.user,
  });

  int itemCount;
  final Stream<QuerySnapshot<Map<String, dynamic>>> firestore;
  int total;
  final double screenHeight;
  final double screenWidth;
  final List<OrderModel> productIds;
  final User? user;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          middle: Text("CART"),
        ),
        child: Column(
          children: [
            StreamBuilder<QuerySnapshot>(
                stream: firestore,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  total = 0;

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child: CupertinoActivityIndicator());
                  }
                  if (snapshot.hasError) {
                    return const Center(child: Text("Some error occurred"));
                  }
                  if (snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: SizedBox(
                        height: screenHeight * .52,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            user!.isAnonymous
                                ? const Text('You are using Guest Account')
                                : const Text('Your Cart is Empty'),
                            user!.isAnonymous
                                ? CupertinoButton(
                                padding: EdgeInsets.zero,
                                child: const Text("Login now!",
                                    style: TextStyle(fontSize: 15)),
                                onPressed: () {
                                  FirebaseAuth.instance.currentUser!.delete();
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      CupertinoPageRoute(
                                        builder: (context) => LogInPage(),
                                      ),
                                          (route) => false);
                                })
                                : CupertinoButton(
                                padding: EdgeInsets.zero,
                                child: const Text("Click here to explore",
                                    style: TextStyle(fontSize: 15)),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                        builder: (context) => AllCategory(),
                                      ));
                                })
                          ],
                        ),
                      ),
                    );
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final value = snapshot.data!.docs[index];
                      final String id = value['id'].toString();
                      final String image = value['image'][0].toString();
                      final String name = value['name'].toString();
                      final String size = value['size'].toString();
                      final String color = value['color'].toString();
                      final int price = int.parse(value['price']);
                      final int quantity = int.parse(value['itemCount']);

                      final int totalPrice = price * quantity;
                      total += totalPrice;
                      if (productIds
                          .any((element) => element.productId == id)) {
                        final existingItemIndex = productIds
                            .indexWhere((element) => element.productId == id);

                        productIds[existingItemIndex].quantity = quantity;
                      } else {
                        productIds
                            .add(OrderModel(productId: id, quantity: quantity));
                      }

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        child: Container(
                          height: screenHeight * .169,
                          width: screenWidth,
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Platform.isAndroid
                                      ? Colors.grey.withOpacity(0.1)
                                      : CupertinoColors.systemGrey
                                      .withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 7,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                              color: Platform.isAndroid
                                  ? Colors.grey.shade100
                                  : CupertinoColors.systemGrey6,
                              borderRadius:
                              const BorderRadius.all(Radius.circular(15))),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  image,
                                  fit: BoxFit.cover,
                                  height: screenHeight * .15,
                                  width: screenWidth * .25,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: screenWidth * .6,
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            name,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 1),
                                          ),
                                        ),
                                        Platform.isAndroid
                                            ? TextButton(
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    content: const Text(
                                                        "Remove this item from cart?"),
                                                    actions: [
                                                      TextButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: const Text(
                                                              "No")),
                                                      TextButton(
                                                          onPressed: () {
                                                            context
                                                                .read<
                                                                CartBloc>()
                                                                .add(OnDeleteCartItem(
                                                                id: id));
                                                            ScaffoldMessenger.of(
                                                                context)
                                                                .showSnackBar(
                                                                const SnackBar(
                                                                  content: Text(
                                                                      "Removed From Cart"),
                                                                  duration: Duration(
                                                                      milliseconds:
                                                                      1500),
                                                                ));
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: const Text(
                                                              "Yes"))
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                            child: const Text('Remove'))
                                            : CupertinoButton(
                                            padding: EdgeInsets.zero,
                                            child: const Text(
                                              "Remove",
                                              style: TextStyle(
                                                  color: CupertinoColors
                                                      .systemRed),
                                            ),
                                            onPressed: () {
                                              showCupertinoDialog(
                                                context: context,
                                                builder: (context) {
                                                  return CupertinoAlertDialog(
                                                    title: const Text(
                                                        "Are you sure?"),
                                                    content: const Text(
                                                        "Do you want to remove this item from cart?"),
                                                    actions: [
                                                      CupertinoDialogAction(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context,
                                                              false);
                                                        },
                                                        child: const Text(
                                                          "No",
                                                          style: TextStyle(
                                                              color: CupertinoColors
                                                                  .systemRed),
                                                        ),
                                                      ),
                                                      CupertinoDialogAction(
                                                        onPressed: () {
                                                          context
                                                              .read<
                                                              CartBloc>()
                                                              .add(OnDeleteCartItem(
                                                              id: id));
                                                          Navigator.pop(
                                                              context,
                                                              true);
                                                        },
                                                        child: const Text(
                                                            "Yes"),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            })
                                      ],
                                    ),
                                  ),
                                  RichText(
                                      text: TextSpan(
                                          text: 'SIZE: ',
                                          style: TextStyle(
                                              color: Platform.isAndroid
                                                  ? Colors.black
                                                  : CupertinoColors.black),
                                          children: [
                                            TextSpan(
                                                text: size,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.w500))
                                          ])),
                                  RichText(
                                      text: TextSpan(
                                          text: 'COLOR: ',
                                          style: TextStyle(
                                              color: Platform.isAndroid
                                                  ? Colors.black
                                                  : CupertinoColors.black),
                                          children: [
                                            TextSpan(
                                                text: color,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.w500))
                                          ])),
                                  const Spacer(),
                                  SizedBox(
                                    width: screenWidth * .6,
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '₹$price/-',
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 1),
                                        ),
                                        BlocBuilder<CartBloc, CartState>(
                                          builder: (context, state) {
                                            itemCount =
                                            state is CartActionSuccessState
                                                ? quantity
                                                : quantity;
                                            return Container(
                                              width: 115,
                                              height: 35,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Platform.isAndroid
                                                          ? Colors.black
                                                          : CupertinoColors
                                                          .black),
                                                  borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(7))),
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceEvenly,
                                                children: [
                                                  Platform.isAndroid
                                                      ? IconButton(
                                                      onPressed: () {
                                                        context
                                                            .read<
                                                            CartBloc>()
                                                            .add(RemoveCartItemCountEvent(
                                                            itemId:
                                                            id));
                                                      },
                                                      icon: const Icon(
                                                          Icons.remove,
                                                          size: 15))
                                                      : CupertinoButton(
                                                      padding:
                                                      EdgeInsets.zero,
                                                      child: const Icon(
                                                          CupertinoIcons
                                                              .minus,
                                                          size: 15),
                                                      onPressed: () {
                                                        context
                                                            .read<
                                                            CartBloc>()
                                                            .add(RemoveCartItemCountEvent(
                                                            itemId:
                                                            id));
                                                      }),
                                                  Text(
                                                    itemCount.toString(),
                                                    style: const TextStyle(
                                                        fontSize: 15),
                                                  ),
                                                  Platform.isAndroid
                                                      ? IconButton(
                                                      onPressed: () {
                                                        context
                                                            .read<
                                                            CartBloc>()
                                                            .add(
                                                            AddCartItemCountEvent(
                                                              itemId: id,
                                                            ));
                                                      },
                                                      icon: const Icon(
                                                        Icons.add,
                                                        size: 15,
                                                      ))
                                                      : CupertinoButton(
                                                      padding:
                                                      EdgeInsets.zero,
                                                      child: const Icon(
                                                        CupertinoIcons.add,
                                                        size: 15,
                                                      ),
                                                      onPressed: () {
                                                        context
                                                            .read<
                                                            CartBloc>()
                                                            .add(
                                                            AddCartItemCountEvent(
                                                              itemId: id,
                                                            ));
                                                      }),
                                                ],
                                              ),
                                            );
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                  // SizedBox(height: 10)
                                ],
                              ),
                            ]),
                          ),
                        ),
                      );
                    },
                  );
                }),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SizedBox(
                  height: 45,
                  width: double.infinity,
                  child: StreamBuilder<QuerySnapshot>(
                      stream: firestore,
                      builder: (context, snapshot) {
                        return Visibility(
                            visible: snapshot.hasData &&
                                snapshot.data!.docs.isNotEmpty,
                            child: SizedBox(
                              height: 45,
                              width: double.infinity,
                              child: CupertinoButton.filled(
                                  child: const Text("CHECKOUT",
                                      style: TextStyle(fontSize: 15)),
                                  onPressed: () {
                                    if (snapshot.hasData &&
                                        snapshot.data!.docs.isNotEmpty) {
                                      showCupertinoDialog(
                                        context: context,
                                        builder: (context) {
                                          return CupertinoAlertDialog(
                                            title: const Text('CART'),
                                            content: const Text(
                                                "Proceed to checkout?"),
                                            actions: [
                                              CupertinoDialogAction(
                                                child: const Text(
                                                  "No",
                                                  style: TextStyle(
                                                      color: CupertinoColors
                                                          .systemRed),
                                                ),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                              ),
                                              CupertinoDialogAction(
                                                child: const Text("CHECKOUT"),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  Navigator.push(
                                                      context,
                                                      CupertinoPageRoute(
                                                        builder: (context) =>
                                                            SelectAddress(
                                                                orderList:
                                                                productIds,
                                                                total: total),
                                                      ));
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    } else {
                                      showCupertinoDialog(
                                        context: context,
                                        builder: (context) {
                                          return CupertinoAlertDialog(
                                            title: const Text(
                                                "Your Cart Page is Empty"),
                                            content: const Text(
                                                "Click here to Explore out items"),
                                            actions: [
                                              CupertinoDialogAction(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text("Cancel")),
                                              CupertinoDialogAction(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                    Navigator.push(
                                                        context,
                                                        CupertinoPageRoute(
                                                          builder: (context) =>
                                                              AllCategory(),
                                                        ));
                                                  },
                                                  child:
                                                  const Text("Shop now")),
                                            ],
                                          );
                                        },
                                      );
                                    }
                                  }),
                            ));
                      })),
            )
          ],
        ));
  }
}
