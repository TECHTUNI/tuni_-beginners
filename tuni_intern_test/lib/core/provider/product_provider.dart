import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tuni/core/model/product_category_model.dart';

import '../../data/repository/product_repository.dart';

class ProductProvider extends ChangeNotifier {
  List<ProductCategory> _providerhalfsleve = [];
  List<ProductCategory> _Allproducts = [];
  List<ProductCategory> _typewise = [];

  List<String> itemTypesList = ["Pant", "Shirt", "Tshirt", "Short"];
  List<String> gendersList = ["Men", "Women", "Kids"];
  final List<String> pants = [
    "Jogger",
    "Six pocket",
    "Jeans",
  ];
  final List<String> types = [
    "full sleve",
    "half sleve",
    "collar",
    "round neck",
    "v-neck",
  ];
  final List<String> design = ["Plain", "Printed", "check"];


  ProductRepo productRepo = ProductRepo();
  int _selectedCategoryIndex = 0;

  int get selectedCategoryIndex => _selectedCategoryIndex;
  List<ProductCategory> get providerhalfsleve => _providerhalfsleve;
  List<ProductCategory> get Allproducts => _Allproducts;
  List<ProductCategory> get typewise => _typewise;

  void selectCategory(int index) {
    _selectedCategoryIndex = index;
    notifyListeners();
  }

  Future<void> gethalfsleveTshirt() async {
    try {
      List<ProductCategory> newData = await productRepo.fetchTshirtshalfsleve();

      Set<String> uniqueProductIds = Set();

      _providerhalfsleve.clear();

      for (ProductCategory product in newData) {
        if (!uniqueProductIds.contains(product.id)) {
          _providerhalfsleve.add(product);
          uniqueProductIds.add(product.id);
        }
      }

      // Notify listeners after updating the list
      notifyListeners();
    } catch (error) {
      print('Error fetching half sleeve t-shirts: $error');
    }
  }

  Future<void> fetchallproduct(String type, String model) async {
    try {

      List<ProductCategory> allproduct =
      await productRepo.fetchALLTshirts(type, model);

      _Allproducts.clear();

      Set<String> uniqueProductIds = {};

      for (ProductCategory product in allproduct) {
        if (!uniqueProductIds.contains(product.id)) {
          _Allproducts.add(product);
          uniqueProductIds.add(product.id);
        }
      }

      notifyListeners();
    } catch (e) {
      throw e.toString();
    }
  }

  Future<List<ProductCategory>> fetchAllProducts() async {
    List<ProductCategory> allProducts = [];

    try {
      List<Future<void>> fetchTasks = [];
      for (String gender in gendersList) {
        for (String iteam in itemTypesList) {
          for (String type in types) {
            for (String design in design) {
              fetchTasks.add(_fetchProductsForTypeAndDesign(
                  gender, iteam, type, design, allProducts));
            }
          }
        }
      }

      // Wait for all fetch tasks to complete in parallel
      await Future.wait(fetchTasks);

      return allProducts;
    } catch (e) {
      print('Error fetching products: $e');
      throw e;
    }
  }

  Future<void> _fetchProductsForTypeAndDesign(String gender, String iteam,
      String type, String design, List<ProductCategory> allProducts) async {
    final QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection("clothes")
        .doc(gender)
        .collection(iteam)
        .doc(type)
        .collection(design)
        .get();

    for (var doc in snapshot.docs) {
      final Map<String, dynamic> data = doc.data();
      final ProductCategory product = ProductCategory(
        id: doc.id,
        name: data['name'] ?? '',
        brand: data['brand'] ?? '',
        gender: data['gender'] ?? '',
        price: data['price'] ?? '',
        time: data['time'] ?? '',
        imageUrlList: List<String>.from(data['imageUrl'] ?? []),
        quantity: data['Quantity'] ?? '',
        color: data['color'] ?? '',
        size: List<String>.from(data['size'] ?? []),
      );

      allProducts.add(product);
    }
  }

}
