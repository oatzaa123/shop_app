import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/providers/cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  final List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> getOrders() async {
    final url = Uri.parse(
        'https://shopapp-58532-default-rtdb.asia-southeast1.firebasedatabase.app/orders.json');

    try {
      final res = await http.get(url);
      final decodedOrders = json.decode(res.body) as Map<String, dynamic>?;
      if (decodedOrders == null) return;

      _orders.clear();
      decodedOrders.forEach((id, data) {
        _orders.add(OrderItem(
          id: id,
          amount: data['amount'],
          dateTime: DateTime.parse(data['dateTime']),
          products: (data['products'] as List<dynamic>)
              .map((d) => CartItem(
                  id: d['id'],
                  price: d['price'],
                  quantity: d['quantity'],
                  title: d['title']))
              .toList(),
        ));
      });

      _orders.reversed.toList();

      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addOrder(List<CartItem> cartItems, double total) async {
    final url = Uri.parse(
        'https://shopapp-58532-default-rtdb.asia-southeast1.firebasedatabase.app/orders.json');

    final timeStamp = DateTime.now();

    try {
      final res = await http.post(
        url,
        body: json.encode(
          {
            "amount": total,
            "dateTime": timeStamp.toIso8601String(),
            "products": cartItems
                .map((cartItem) => {
                      "id": cartItem.id,
                      "title": cartItem.title,
                      "quantity": cartItem.quantity,
                      "price": cartItem.price,
                    })
                .toList(),
          },
        ),
      );

      _orders.insert(
        0,
        OrderItem(
          id: json.decode(res.body)['name'],
          amount: total,
          products: cartItems,
          dateTime: timeStamp,
        ),
      );

      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}
