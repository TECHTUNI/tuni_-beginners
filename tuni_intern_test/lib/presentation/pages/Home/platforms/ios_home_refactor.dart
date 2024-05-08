import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../core/model/product_category_model.dart';
import '../../search/search_widget.dart';
import '../home_refactor.dart';

class IosHome extends StatelessWidget {
  const IosHome({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
    required this.productList
  });
  final List<ProductCategory> productList;

  final double screenWidth;
  final double screenHeight;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text(
          "TUNi",
          style: TextStyle(
            color: CupertinoColors.black,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SearchScreen()));
          },
          child: const Icon(CupertinoIcons.search),
        ),
      ),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                const MainPageCarouselSlider(),
                const SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      mainPageHeading('Explore'),
                      const SizedBox(
                        width: 0,
                      ),
                      MainPageSeeMoreTextButton(allProductList: productList,)
                    ],
                  ),
                ),
                ExploreItemsInHomePage(products: productList ,),
                Center(child: mainPageHeading('Filter by CATEGORY')),
                MainPageFilterByCategory(
                    screenWidth: screenWidth, screenHeight: screenHeight),
                const Divider()
              ],
            ),
          ),
        ],
      ),
    );
  }
}
