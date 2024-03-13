import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';
import 'product.dart';

class Products with ChangeNotifier {
  final List<Product> _items;
  final String authToken;

  Products(this.authToken, this._items);

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((item) => item.isFavorite).toList();
  }

  Product findById(String id) => _items.firstWhere((item) => item.id == id);

  Future<void> getProducts() async {
    final url = Uri.parse(
        'https://shopapp-58532-default-rtdb.asia-southeast1.firebasedatabase.app/products.json?auth=$authToken');

    try {
      final res = await http.get(url);
      final extractData = json.decode(res.body) as Map<String, dynamic>?;

      if (extractData == null) return;
      // final List<Product> loadedProducts = [];
      _items.clear();

      extractData.forEach((id, data) {
        _items.add(
          Product(
            id: id,
            title: data['title'],
            description: data['description'],
            imageUrl: data['imageUrl'],
            price: data['price'],
            isFavorite: data['isFavorite'],
          ),
        );
      });

      notifyListeners();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse(
        'https://shopapp-58532-default-rtdb.asia-southeast1.firebasedatabase.app/products.json?auth=$authToken');

    try {
      final res = await http.post(
        url,
        body: json.encode(
          {
            "title": product.title,
            "description": product.description,
            "imageUrl": product.imageUrl,
            "price": product.price,
            "isFavorite": product.isFavorite,
          },
        ),
      );

      final newProduct = Product(
        id: json.decode(res.body)['name'],
        title: product.title,
        description: product.description,
        imageUrl: product.imageUrl,
        price: product.price,
      );

      _items.add(newProduct);

      notifyListeners();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> updateProduct(String id, Product product) async {
    final prodIndex = _items.indexWhere((item) => item.id == id);

    if (prodIndex < 0) return;

    final url = Uri.parse(
        'https://shopapp-58532-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json?auth=$authToken');

    try {
      await http.patch(
        url,
        body: json.encode({
          "title": product.title,
          "description": product.description,
          "imageUrl": product.imageUrl,
          "price": product.price,
          "isFavorite": product.isFavorite
        }),
      );

      _items[prodIndex] = product;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.parse(
        'https://shopapp-58532-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json?auth=$authToken');

    final existingProductIndex = _items.indexWhere((item) => item.id == id);

    Product? existingProduct = _items[existingProductIndex];

    _items.removeAt(existingProductIndex);
    notifyListeners();

    final res = await http.delete(url);

    if (res.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      throw HttpException('Could not delete product.');
    }

    existingProduct = null;
  }
}
