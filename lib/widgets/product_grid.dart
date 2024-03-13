import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/widgets/product_item.dart';

import '../providers/products.dart';

class ProductGrid extends StatelessWidget {
  final bool showFavs;

  const ProductGrid(this.showFavs, {super.key});

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<Products>(context);

    final productsData =
        showFavs ? productsProvider.favoriteItems : productsProvider.items;

    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: productsData.length,
      itemBuilder: (BuildContext context, int index) =>
          ChangeNotifierProvider.value(
        value: productsData[index],
        // create: (context) => productsData[index],
        child: const ProductItem(),
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
