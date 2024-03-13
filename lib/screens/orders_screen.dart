import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/widgets/app_drawer.dart';

import '../providers/orders.dart' show Orders;
import '../widgets/orders_item.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';

  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Your Order'),
      ),
      body: FutureBuilder(
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.error != null) {
              return const Center(
                child: Text('An error occurred!'),
              );
            }

            return Consumer<Orders>(
              builder: (context, ordersData, child) => ListView.builder(
                itemCount: ordersData.orders.length,
                itemBuilder: (context, index) => OrdersItem(
                  order: ordersData.orders[index],
                ),
              ),
            );
          },
          future: Provider.of<Orders>(context, listen: false).getOrders()),
    );
  }
}
