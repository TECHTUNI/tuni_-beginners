import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../../core/model/cart_model.dart';
import '../../../core/model/product_order_model.dart';
import '../../pages/bottom_nav/pages/bottom_nav_bar_page.dart';
import 'cart_repository.dart';

part 'cart_event.dart';

part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartRepository cartRepository = CartRepository();

  final User? user = FirebaseAuth.instance.currentUser;
  final Razorpay _razorpay = Razorpay();

  int totalAmount = 0;

  CartBloc() : super(CartInitial()) {
    on<FetchCartDataEvent>(fetchCartDataEvent);
    on<OnDeleteCartItem>(onDeleteCartItem);
    on<AddCartItemCountEvent>(addCartItemCountEvent);
    on<RemoveCartItemCountEvent>(removeCartItemCountEvent);
    // on<GetTotalProductPrice>(getTotalProductPrice);
    // on<RazorPayEventListenersEvent>(razorPayEventListenersEvent);
    on<RazorPayEvent>(razorPayEvent);
    on<CancelOrderedProductEvent>(cancelOrderedProductEvent);
  }

  FutureOr<void> fetchCartDataEvent(
      FetchCartDataEvent event, Emitter<CartState> emit) async {
    try {
      final int total = await cartRepository.getCartTotal();
      final List<CartModel> cartDataList =
          await cartRepository.fetchCartDataFromFirestore();
      emit(CartDataFetchedState(
          cartDataList: cartDataList, cartTotalPrice: total));
    } catch (e) {
      throw e.toString();
    }
  }

  FutureOr<void> onDeleteCartItem(
      OnDeleteCartItem event, Emitter<CartState> emit) async {
    try {
      await cartRepository.deleteCartItem(event.id);
      emit(CartItemDeletedState());
      final int total = await cartRepository.getCartTotal();
      final List<CartModel> cartDataList =
          await cartRepository.fetchCartDataFromFirestore();
      emit(CartDataFetchedState(
          cartDataList: cartDataList, cartTotalPrice: total));
    } catch (e) {
      throw e.toString();
    }
  }

  FutureOr<void> addCartItemCountEvent(
      AddCartItemCountEvent event, Emitter<CartState> emit) async {
    try {
      cartRepository.addCartItemCount(event.itemId);
      emit(CartActionSuccessState());
      int total = await cartRepository.getCartTotal();
      final List<CartModel> cartDataList =
          await cartRepository.fetchCartDataFromFirestore();
      emit(CartDataFetchedState(
          cartDataList: cartDataList, cartTotalPrice: total));
    } catch (e) {
      throw e.toString();
    }
  }

  FutureOr<void> removeCartItemCountEvent(
      RemoveCartItemCountEvent event, Emitter<CartState> emit) async {
    try {
      cartRepository.lessCartItemCount(event.itemId);
      emit(CartActionSuccessState());
      int total = await cartRepository.getCartTotal();
      final List<CartModel> cartDataList =
          await cartRepository.fetchCartDataFromFirestore();
      emit(CartDataFetchedState(
          cartDataList: cartDataList, cartTotalPrice: total));
    } catch (e) {
      throw e.toString();
    }
  }

  // FutureOr<void> getTotalProductPrice(GetTotalProductPrice event,
  //     Emitter<CartState> emit) async {
  //   final firestore = await
  // }

  FutureOr<void> razorPayEventListenersEvent(
      RazorPayEventListenersEvent event, Emitter<CartState> emit) async {}

  FutureOr<void> razorPayEvent(
      RazorPayEvent event, Emitter<CartState> emit) async {
    try {
      Map<String, dynamic> options = {
        'key':
            // "rzp_live_G0zIOHVwXX4lMK",
            'rzp_test_TpsHVKhrkZuIUJ',
        //rzp_live_G0zIOHVwXX4lMK
        'amount': event.amount * 100,
        'name': 'Tuni',
        'description': 'Payment for tuni',
        'timeout': 300,
        'prefill': {
          'contact': '8088473612',
          'email': 'tunitechsolution@gmail.com'
        }
      };
      _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS,
          (PaymentSuccessResponse response) {
        try {
          cartRepository.addOrderListInFirestore(
              context: event.context,
              name: event.name,
              email: event.email,
              address: event.address,
              mobile: event.mobile,
              orderList: event.orderList);
          Platform.isAndroid
              ? Navigator.pushAndRemoveUntil(
                  event.context,
                  MaterialPageRoute(
                    builder: (context) => const BottomNavBarPage(),
                  ),
                  (route) => true)
              : Navigator.pushReplacement(
                  event.context,
                  CupertinoPageRoute(
                    builder: (context) => const BottomNavBarPage(),
                  ));
        } catch (error) {
          debugPrint("error is here");
          throw error.toString();
        }
      });

      _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR,
          (PaymentFailureResponse response) {
        try {
          Platform.isAndroid
              ? Navigator.pushAndRemoveUntil(
                  event.context,
                  MaterialPageRoute(
                    builder: (context) => const BottomNavBarPage(),
                  ),
                  (route) => true)
              : Navigator.pushReplacement(
                  event.context,
                  CupertinoPageRoute(
                    builder: (context) => const BottomNavBarPage(),
                  ));
          Platform.isAndroid
              ? showDialog(
                  context: event.context,
                  builder: (context) {
                    return AlertDialog(
                      content: const Text("Can't checkout, please try again!!"),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("OK"))
                      ],
                    );
                  },
                )
              : showCupertinoDialog(
                  context: event.context,
                  builder: (context) {
                    return CupertinoAlertDialog(
                      content: const Text("Can't checkout, please try again!!"),
                      actions: [
                        CupertinoButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("OK"))
                      ],
                    );
                  },
                );
        } catch (e) {
          debugPrint("error is at razorpay.EVENT_PAYMENT_ERROR");
          throw e.toString();
        }
      });

      _razorpay.on(
          Razorpay.EVENT_EXTERNAL_WALLET, (ExternalWalletResponse response) {});
      _razorpay.open(options);
    } catch (e) {
      throw e.toString();
    }
  }

  FutureOr<void> cancelOrderedProductEvent(
      CancelOrderedProductEvent event, Emitter<CartState> emit) async {
    try {
      final userId = user!.uid;
      await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection("orderList")
          .doc(event.orderId)
          .delete();
      await FirebaseFirestore.instance
          .collection("AllOrderList")
          .doc(event.orderId)
          .delete();
    } catch (e) {
      throw e.toString();
    }
  }
}
