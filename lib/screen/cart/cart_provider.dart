import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/models.dart';

class CartChangeProvider with ChangeNotifier {
  final List<Carts> _carts = [];
  final String _cartKey = 'cart';

  List<Carts> get carts => _carts;
  int get itemcount => _carts.length;

  CartChangeProvider() {
    loadCartLists();
  }

  Future<void> loadCartLists() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String>? cartsJson = prefs.getStringList(_cartKey);
    if (cartsJson != null) {
      _carts.addAll(cartsJson.map((e) => Carts.fromJson(e)).toList());
      notifyListeners();
    }
  }

  Future<void> saveCart(List<Carts> carts) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> cartsJson = carts.map((e) => e.toJson()).toList();
    await prefs.setStringList(_cartKey, cartsJson);
  }

  bool addCart(Carts cart) {
    bool isExist = _carts.any((e) =>
        e.productid == cart.productid && e.productsizeid == cart.productsizeid);

    if (!isExist) {
      _carts.add(cart);
      saveCart(_carts);

      notifyListeners();

      return true;
    } else {
      return false;
    }
  }

  bool removeCart(String productid) {
    _carts.removeWhere((element) => element.productid == productid);
    saveCart(_carts);

    notifyListeners();

    return true;
  }

  void clearCart() async {
    _carts.clear();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(_cartKey);

    notifyListeners();
  }

  double getSubTotalPrice() {
    return _carts.fold(0, (sum, e) => sum + e.total);
  }
}
