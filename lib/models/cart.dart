import './item.dart';
import 'package:firebase_database/firebase_database.dart';

class Cart {
  List<Item> items;
  bool isOnline;
  bool canEdit;
  String id;

  Cart() {
    this.items = [];
    this.isOnline = false;
    this.canEdit = false;
    this.id = DateTime.now().millisecondsSinceEpoch.toString();
    this.items.add(Item(name: ''));
  }

  void addItem(Item newItem) {
    this.items.add(newItem);
  }

  void removeItem(int index) {
    this.items.removeAt(index);
  }

  void changeToOnlineCart(bool canEdit) {
    this.isOnline = true;
    this.canEdit = canEdit;
    //update database
  }

  void disableOnlineCart() {
    this.isOnline = false;
    this.canEdit = false;
    //update database
    FirebaseDatabase.instance.reference().child('carts/$id').remove();
  }

  void updateItemByIndex(int index, Item updatedItem) {
    items[index] = updatedItem;
    checkListFull();
  }

  void checkListFull() {
    int count = 0;
    items.forEach((element) {
      if (element.name.isEmpty) count++;
    });
    if (count == 0) {
      addItem(Item(name: ''));
    } else if (count > 1) {
      items.removeWhere((element) {
        if (element.name.isEmpty && count-- > 1) return true;
        return false;
      });
    }
  }

  Map<String, Object> toJSON() {
    return {
      'items': this.items.map((item) => item.toJSON()).toList(),
      'isOnline': this.isOnline,
      'canEdit': this.canEdit,
      'id': this.id
    };
  }

  Cart fromJSON(Map<String, dynamic> json) {
    this.items = (json['items'] as List)
        .map((item) =>
            Item(name: item['name']).fromJSON(Map<String, dynamic>.from(item)))
        .toList();
    this.isOnline = json['isOnline'];
    this.canEdit = json['canEdit'];
    this.id = json['id'];
    return this;
  }
}
