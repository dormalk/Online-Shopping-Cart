import 'package:online_shopping_cart/models/item.dart';

import '../models/cart.dart';
import 'package:flutter/foundation.dart';
import 'package:localstorage/localstorage.dart';
import 'package:firebase_database/firebase_database.dart';

class Storage extends ChangeNotifier {
  List<Cart> carts = [];
  LocalStorage _storage = new LocalStorage('online_carts');

  Future initialize() async {
    await _storage.ready;
    final list = _storage.getItem('carts');
    if (list != null) {
      this.carts =
          (list['carts'] as List).map((item) => Cart().fromJSON(item)).toList();
      setListenersToDatabase();
    }
  }

  void setListenersToDatabase() {
    for (var cart in this.carts) {
      if (cart.isOnline) {
        FirebaseDatabase.instance
            .reference()
            .child('carts/${cart.id}')
            .onValue
            .listen((event) {
          final snapshotVal = Map<String, dynamic>.from(event.snapshot.value);
          Cart updatedCart = Cart().fromJSON(snapshotVal);
          this.carts[this
                  .carts
                  .indexWhere((element) => element.id == updatedCart.id)] =
              updatedCart;
        });
      }
    }
  }

  void createCart() {
    this.carts.add(new Cart());
    saveOnStorage();
  }

  void removeCart(String id) {
    this.carts.removeWhere((element) => element.id == id);
    try {
      FirebaseDatabase.instance.reference().child('carts/$id').remove();
    } catch (e) {}
    saveOnStorage();
  }

  void switchPlaces(int i, int j) {
    Cart temp = carts[i];
    carts[i] = carts[j];
    carts[j] = temp;
    saveOnStorage();
  }

  Cart getCartById(String id) {
    return this.carts.firstWhere((element) => element.id == id);
  }

  void updateItemOnCart(String id, int itemIndex, Item updatedItem) {
    final cartIndex = this.carts.indexWhere((element) => element.id == id);
    this.carts[cartIndex].updateItemByIndex(itemIndex, updatedItem);
    saveOnStorage();
  }

  void saveOnStorage() {
    _storage.setItem(
        'carts', {'carts': this.carts.map((item) => item.toJSON()).toList()});
    notifyListeners();
    saveOnOnlineStorage();
  }

  void saveOnOnlineStorage() {
    for (var cart in this.carts) {
      if (cart.isOnline) {
        Map<String, Object> cartJSON = cart.toJSON();
        FirebaseDatabase.instance
            .reference()
            .child('carts/${cart.id}')
            .set(cartJSON);
      }
    }
  }
}
