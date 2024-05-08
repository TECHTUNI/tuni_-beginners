import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/model/product_category_model.dart';
import '../../../core/provider/product_provider.dart';
import '../Home/pages_in_home_page/product_detail_page.dart';
import '../caterory/categories_refactor.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<ProductCategory> _products = [];
  List<ProductCategory> _filteredProducts = [];

  late Future<List<ProductCategory>> _fetchAllProductsFuture;

  @override
  void initState() {
    _fetchAllProductsFuture =
        Provider.of<ProductProvider>(context, listen: false).fetchAllProducts();
    _fetchProducts();
    super.initState();
  }

  Future<void> _fetchProducts() async {
    try {
      final List<ProductCategory> productList = await _fetchAllProductsFuture;
      setState(() {
        _products = productList;
        _filteredProducts = _products;
      });
    } catch (error) {
      throw error.toString();
    }
  }

  void _searchProducts(String query) {
    setState(() {
      _filteredProducts = _products.where((product) {
        final productName = product.name.toLowerCase();
        return productName.contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Platform.isAndroid
        ? Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          onChanged: _searchProducts,
          decoration: const InputDecoration(
            hintText: 'Search...',
            border: InputBorder.none,
          ),
        ),
      ),
      body: _filteredProducts.isEmpty
          ? const Center(
        child: Text('No products found.'),
      )
          : GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate:
        const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: .72,
        ),
        itemCount: _filteredProducts.length,
        itemBuilder: (context, index) {
          final product = _filteredProducts[index];
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailPage(
                    productId: product.id,
                    productName: product.name,
                    imageUrl: product.imageUrlList,
                    color: product.color,
                    brand: product.brand,
                    price: product.price,
                    size: product.size,
                    category: product.name,
                    gender: product.gender,
                    time: product.time,
                  ),
                ),
              );
            },
            child: productView(
              product.name,
              product.price,
              product.imageUrlList[0],
            ),
          );
        },
      ),
    )
        : CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: CupertinoSearchTextField(
            controller: _searchController,
            onChanged: _searchProducts,
            keyboardType: TextInputType.text,
          ),
          trailing: const SizedBox(),
        ),
        child: _filteredProducts.isEmpty
            ? const Center(
          child: Text('No products found.'),
        )
            : GridView.builder(
          padding: const EdgeInsets.all(10),
          gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: .72,
          ),
          itemCount: _filteredProducts.length,
          itemBuilder: (context, index) {
            final product = _filteredProducts[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailPage(
                      productId: product.id,
                      productName: product.name,
                      imageUrl: product.imageUrlList,
                      color: product.color,
                      brand: product.brand,
                      price: product.price,
                      size: product.size,
                      category: product.name,
                      gender: product.gender,
                      time: product.time,
                    ),
                  ),
                );
              },
              child: productView(
                product.name,
                product.price,
                product.imageUrlList[0],
              ),
            );
          },
        ));
  }
}
