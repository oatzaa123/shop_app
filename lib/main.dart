import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/routes.dart';
import 'package:shop_app/screens/auth_screen.dart';
import 'package:shop_app/screens/product_overview_screen.dart';

import '../providers/cart.dart';
import '../providers/orders.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (BuildContext context) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (context) => Products('', []),
          update: (ctx, auth, previousProducts) => Products(
            auth.token as String,
            previousProducts == null ? [] : previousProducts.items,
          ),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => Orders(),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, _) => MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple)
                  .copyWith(secondary: Colors.deepOrange),
              fontFamily: 'Lato'),
          routes: routes,
          home:
              auth.isAuth ? const ProductOverviewScreen() : const AuthScreen(),
        ),
      ),
    );
  }
}
