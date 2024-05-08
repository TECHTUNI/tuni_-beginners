import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuni/presentation/pages/Home/platforms/andoid_home_refactor.dart';
import 'package:tuni/presentation/pages/Home/platforms/ios_home_refactor.dart';

import '../../../core/model/product_category_model.dart';
import '../../../core/provider/product_provider.dart';
import '../../../data/repository/product_repository.dart';

class HomePage extends StatefulWidget {
  final List<String> model = [
    "full sleve",
    "half sleve",
    "collar",
    "round neck",
    "v-neck"
  ];
  final List<String> type = ["Pant", "Shirt", "Tshirt", "Shorts"];

  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // final String _keyCachedProductList = 'cached_product_list';

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false)
          .fetchallproduct("Tshirt", "full sleve");
      // Provider.of<ProductProvider>(context, listen: false)
      //     .fetchAllProducts();

    });

    super.initState();
  }

  // Future<void> cacheProductList(List<ProductCategory> productList) async {
  //   try {
  //     final prefs = await SharedPreferences.getInstance();
  //     final encodedData =
  //         productList.map((product) => product.toJson()).toList();
  //     await prefs.setString(_keyCachedProductList, json.encode(encodedData));
  //   } catch (e) {
  //     print('Error caching product list: $e');
  //     throw e.toString();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context);
    final List<ProductCategory> allProductsList = provider.Allproducts;
    // cacheProductList(allProductsList);

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Platform.isAndroid
        ? AndroidHome(
            screenWidth: screenWidth,
            screenHeight: screenHeight,
            productList: allProductsList)
        : IosHome(
            screenWidth: screenWidth,
            screenHeight: screenHeight,
            productList: allProductsList,
          );
  }
}
