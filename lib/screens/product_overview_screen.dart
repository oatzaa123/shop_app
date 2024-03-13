import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';

import '../providers/cart.dart';
import '../widgets/app_drawer.dart';
import '../widgets/badge.dart';
import '../widgets/product_grid.dart';
import 'cart_screen.dart';

enum FilterOptions { favorites, all }

class ProductOverviewScreen extends StatefulWidget {
  const ProductOverviewScreen({super.key});

  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  bool _showFavoriteOnly = false;
  bool _isLoading = false;

  Future<void> getProducts() async {
    await Provider.of<Products>(context, listen: false).getProducts();
  }

  void _setIsLoading(bool isLoading) {
    setState(() => _isLoading = isLoading);
  }

  Future<void> _refreshPage() async {
    await getProducts();
  }

  @override
  Future<void> didChangeDependencies() async {
    _setIsLoading(true);
    await getProducts();
    _setIsLoading(false);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('MyShop'),
        actions: [
          PopupMenuButton(
            onSelected: (FilterOptions value) {
              setState(() {
                final val = value == FilterOptions.favorites ? true : false;
                _showFavoriteOnly = val;
              });
            },
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: FilterOptions.favorites,
                child: Text('Only Favorite'),
              ),
              const PopupMenuItem(
                value: FilterOptions.all,
                child: Text('Show All'),
              ),
            ],
            icon: const Icon(Icons.more_vert),
          ),
          Consumer<Cart>(
            builder: (_, value, child) => Badge(
              value: value.itemCount.toString(),
              child: child!,
            ),
            child: IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () => Navigator.of(context).pushNamed(
                CartScreen.routeName,
              ),
            ),
          )
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: _refreshPage,
              child: ProductGrid(_showFavoriteOnly),
            ),
    );
  }
}
