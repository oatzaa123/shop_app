import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exception.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  void _setFavorites(bool fav) {
    isFavorite = fav;
    notifyListeners();
  }

  Future<void> toggleFavorite() async {
    final url = Uri.parse(
        'https://shopapp-58532-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json');

    final oldStatus = isFavorite;

    try {
      final res = await http.patch(
        url,
        body: json.encode({
          "title": title,
          "description": description,
          "price": price,
          "imageUrl": imageUrl,
          "isFavorite": !isFavorite
        }),
      );

      if (res.statusCode >= 400) {
        _setFavorites(oldStatus);
        throw HttpException('Cannot favorites product!');
      }

      _setFavorites(!isFavorite);
    } catch (e) {
      _setFavorites(oldStatus);
      rethrow;
    }
  }
}
