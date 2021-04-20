import 'package:flutter/material.dart';
import 'package:online_shopping_cart/models/item.dart';
import 'package:online_shopping_cart/providers/storage.dart';
import 'package:provider/provider.dart';

class CartItemTile extends StatelessWidget {
  final Item item;
  final int index;
  final String id;
  final bool isEditMode;
  final bool isLast;
  CartItemTile(
      {Key key,
      @required this.item,
      @required this.index,
      @required this.id,
      this.isLast = true,
      this.isEditMode = true})
      : super(key: key);

  void _updateItem(
    BuildContext ctx,
    Item item,
    int index,
  ) {
    Provider.of<Storage>(ctx, listen: false).updateItemOnCart(id, index, item);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: isEditMode
          ? const EdgeInsets.only(right: 25)
          : const EdgeInsets.only(right: 0),
      child: Transform.scale(
        scale: isEditMode ? 1.2 : 1,
        child: Opacity(
          opacity: !this.isLast ? 1 : 0.4,
          child: SizedBox(
            height: !isEditMode ? 35 : null,
            child: CheckboxListTile(
                value: item.isCheked,
                contentPadding:
                    !isEditMode ? EdgeInsets.only(top: 0, bottom: 0) : null,
                title: isEditMode
                    ? TextFormField(
                        textAlign: TextAlign.right,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                        style: item.isCheked
                            ? TextStyle(
                                decoration: TextDecoration.lineThrough,
                                color: Colors.black26)
                            : null,
                        initialValue: item.name,
                        onChanged: (value) {
                          item.name = value;
                          _updateItem(context, item, index);
                        },
                      )
                    : Text(item.name,
                        textAlign: TextAlign.right,
                        style: item.isCheked
                            ? TextStyle(decoration: TextDecoration.lineThrough)
                            : null),
                onChanged: isEditMode && (!this.isLast || index == 0)
                    ? (value) {
                        item.isCheked = value;
                        _updateItem(context, item, index);
                      }
                    : null),
          ),
        ),
      ),
    );
  }
}
