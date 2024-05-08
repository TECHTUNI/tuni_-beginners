import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:tuni/core/provider/product_provider.dart';
import 'package:tuni/presentation/pages/Home/pages_in_home_page/products_category_item_view_widget.dart';

import '../../../../core/model/product_category_model.dart';

class ProductsCategoryInExplore extends StatefulWidget {
  final List<String> model = [
    "full sleve",
    "half sleve",
    "collar",
    "round neck",
    "v-neck"
  ];
  final List<String> type = ["Pant", "Shirt", "Tshirt", "Shorts"];

  List<ProductCategory> productList;

  ProductsCategoryInExplore({super.key, required this.productList});

  @override
  ProductsCategoryInExploreState createState() =>
      ProductsCategoryInExploreState();
}

class ProductsCategoryInExploreState extends State<ProductsCategoryInExplore> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  void _onIndexChanged(int newIndex) {
    setState(() {
      _selectedIndex = newIndex;
      Provider.of<ProductProvider>(context, listen: false)
          .fetchallproduct("Tshirt", widget.model[newIndex]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              middle: const Text('EXPLORE'),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Consumer<ProductProvider>(
                  builder: (context, productProvider, Widget? child) {
                    return Container(
                      width: constraints.maxWidth,
                      color: CupertinoColors.black,
                      child: Row(
                        children: [
                          Container(
                            width: constraints.maxWidth * 0.25,
                            color: CupertinoColors.systemGrey4,
                            child: Column(
                              children: [
                                _buildCircleAvatarWithName(
                                    CupertinoIcons.person, "full sleve", 0),
                                _buildCircleAvatarWithName(
                                    CupertinoIcons.person, "half sleve", 1),
                                _buildCircleAvatarWithName(
                                    CupertinoIcons.person, "collar", 2),
                                _buildCircleAvatarWithName(
                                    CupertinoIcons.person, "round neck", 3),
                                _buildCircleAvatarWithName(
                                    CupertinoIcons.person, "V neck", 4),
                              ],
                            ),
                          ),
                          Container(
                            width: constraints.maxWidth * 0.75,
                            height: double.infinity,
                            color: CupertinoColors.white,
                            child: Center(
                              child: _getScreenForIndex(_selectedIndex),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: const Text('EXPLORE'),
            ),
            body: LayoutBuilder(
              builder: (context, constraints) {
                return Consumer<ProductProvider>(
                  builder: (context, productProvider, Widget? child) {
                    return Container(
                      width: constraints.maxWidth,
                      color: Colors.black,
                      child: Row(
                        children: [
                          Container(
                            width: constraints.maxWidth * 0.25,
                            color: Colors.grey.shade200,
                            child: Column(
                              children: [
                                _buildCircleAvatarWithName(
                                    Icons.person, "full sleve", 0),
                                _buildCircleAvatarWithName(
                                    Icons.person, "half sleve", 1),
                                _buildCircleAvatarWithName(
                                    Icons.person, "collar", 2),
                                _buildCircleAvatarWithName(
                                    Icons.person, "round neck", 3),
                                _buildCircleAvatarWithName(
                                    Icons.person, "V neck", 4),
                              ],
                            ),
                          ),
                          Container(
                            width: constraints.maxWidth * 0.75,
                            height: double.infinity,
                            color: Colors.white,
                            child: Center(
                              child: _getScreenForIndex(_selectedIndex),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          );
  }

  Widget _buildCircleAvatarWithName(
    IconData icon,
    String name,
    int index,
  ) {
    bool isSelected = index == _selectedIndex;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: GestureDetector(
        onTap: () {
          _onIndexChanged(index);
        },
        child: Platform.isIOS
            ? Container(
                height: 35,
                width: double.infinity,
                color: isSelected
                    ? CupertinoColors.systemGrey2
                    : CupertinoColors.systemGrey4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      name.toUpperCase(),
                      style: TextStyle(
                          color: isSelected
                              ? CupertinoColors.black
                              : CupertinoColors.systemGrey,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                          letterSpacing: 1,
                          fontSize: isSelected ? 13 : 12),
                    ),
                  ],
                ),
              )
            : Container(
                height: 35,
                width: double.infinity,
                color:
                    isSelected ? Colors.blueGrey.shade100 : Colors.transparent,
                child: Column(
                  children: [
                    Text(
                      name.toUpperCase(),
                      style: TextStyle(
                          color:
                              isSelected ? Colors.black : Colors.grey.shade500,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                          letterSpacing: 1,
                          fontSize: isSelected ? 13 : 12),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _getScreenForIndex(int index) {
    switch (index) {
      case 0:
        return ProductsItemView(
          type: 'Tshirt',
          model: widget.model[index],
          productList: widget.productList,
        );
      case 1:
        return ProductsItemView(
          type: 'Tshirt',
          model: widget.model[index],
          productList: widget.productList,
        );
      case 2:
        return ProductsItemView(
          type: 'Tshirt',
          model: widget.model[index],
          productList: widget.productList,
        );
      case 3:
        return ProductsItemView(
          type: 'Tshirt',
          model: widget.model[index],
          productList: widget.productList,
        );
      case 4:
        return ProductsItemView(
          type: 'Tshirt',
          model: widget.model[index],
          productList: widget.productList,
        );
      default:
        return Container();
    }
  }
}
