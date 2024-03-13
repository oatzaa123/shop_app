import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exception.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;

  bool get isAuth {
    return _token != null;
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token!;
    }
    return null;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url = Uri.parse(
      'https://www.googleapis.com/identitytoolkit/v3/relyingparty/$urlSegment?key=AIzaSyAUR0o-JByNZYPAPv5c5Cjf_4UVbh4q8ik',
    );

    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );

      final data = json.decode(response.body);

      if (data['error'] != null) {
        throw HttpException(data['error']['message']);
      }

      _token = data['idToken'];
      _userId = data['localId'];
      _expiryDate = DateTime.now().add(Duration(
        seconds: int.parse(data['expiresIn']),
      ));
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> signup(String email, String password) async {
    await _authenticate(email, password, 'signupNewUser');
  }

  Future<void> login(String email, String password) async {
    await _authenticate(email, password, 'verifyPassword');
  }
}
