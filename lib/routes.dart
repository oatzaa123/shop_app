import 'package:flutter/material.dart';
import 'package:shop_app/screens/cart_screen.dart';

import 'screens/edit_product_screen.dart';
import 'screens/orders_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/user_product_screen.dart';
import 'widgets/user_product_item.dart';

final Map<String, WidgetBuilder> routes = {
  ProductDetailScreen.routeName: (ctx) => const ProductDetailScreen(),
  CartScreen.routeName: (ctx) => const CartScreen(),
  OrdersScreen.routeName: (ctx) => const OrdersScreen(),
  UserProductScreen.routeName: (ctx) => const UserProductScreen(),
  EditProductScreen.routeName: (ctx) => const EditProductScreen(),
  GalleryWidget.routeName: (ctx) => const GalleryWidget(),
};
