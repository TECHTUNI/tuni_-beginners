import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/model/product_category_model.dart';
import '../../../../core/provider/product_provider.dart';
import '../../Home/pages_in_home_page/product_detail_page.dart';
import '../categories_refactor.dart';

import 'package:shimmer/shimmer.dart'; // Import Shimmer package

class AllCategory extends StatefulWidget {
  final List<ProductCategory>? allProductList;

  AllCategory({this.allProductList, super.key});

  @override
  State<AllCategory> createState() => _AllCategoryState();
}

class _AllCategoryState extends State<AllCategory> {
  late Future<List<ProductCategory>> _fetchAllProductsFuture;

  @override
  void initState() {
    _fetchAllProductsFuture =
        Provider.of<ProductProvider>(context, listen: false).fetchAllProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Platform.isAndroid
        ? Scaffold(
            appBar: AppBar(
              foregroundColor: Colors.black,
              title: const Text(
                'All',
                style: TextStyle(letterSpacing: 3, fontSize: 20),
              ),
              toolbarHeight: 60,
            ),
            body: FutureBuilder<List<ProductCategory>>(
              future: _fetchAllProductsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Shimmer.fromColors(
                      // Use Shimmer here
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: GridView.builder(
                        padding: const EdgeInsets.all(5),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                        ),
                        itemCount: 10,
                        itemBuilder: (context, index) {
                          return Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else if (snapshot.data == null || snapshot.data!.isEmpty) {
                  return Center(
                    child: const Text("Currently this category not available"),
                  );
                } else {
                  return GridView.builder(
                    padding: const EdgeInsets.all(10),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: .72,
                    ),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final ProductCategory product = snapshot.data![index];
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
                                category: "",
                                gender: product.gender,
                                time: product.time,
                              ),
                            ),
                          );
                        },
                        child: productView(product.name,
                            product.price.toString(), product.imageUrlList[0]),
                      );
                    },
                  );
                }
              },
            ),
          )
        : CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              // foregroundColor: Colors.black,
              middle: const Text(
                'All',
                style: TextStyle(letterSpacing: 3, fontSize: 20),
              ),
              // toolbarHeight: 60,
            ),
            child: FutureBuilder<List<ProductCategory>>(
              future: _fetchAllProductsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CupertinoActivityIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else if (snapshot.data == null || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text("Currently this category not available"),
                  );
                } else {
                  return GridView.builder(
                    padding: const EdgeInsets.all(10),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: .72,
                    ),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final ProductCategory product = snapshot.data![index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => ProductDetailPage(
                                productId: product.id,
                                productName: product.name,
                                imageUrl: product.imageUrlList,
                                color: product.color,
                                brand: product.brand,
                                price: product.price,
                                size: product.size,
                                category: "",
                                gender: product.gender,
                                time: product.time,
                              ),
                            ),
                          );
                        },
                        child: productView(product.name,
                            product.price.toString(), product.imageUrlList[0]),
                      );
                    },
                  );
                }
              },
            ),
          );
  }
}
