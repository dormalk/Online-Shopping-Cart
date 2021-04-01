import 'package:flutter/material.dart';
import 'package:online_shopping_cart/models/item.dart';
import 'package:online_shopping_cart/providers/storage.dart';
import 'package:provider/provider.dart';

class CartItemTile extends StatelessWidget {
  final Item item;
  final int index;
  final String id;
  final bool isEditMode;
  CartItemTile(
      {Key key,
      @required this.item,
      @required this.index,
      @required this.id,
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
    final isNotLast = item.name.length > 0;
    return Padding(
      padding: isEditMode
          ? const EdgeInsets.only(right: 25)
          : const EdgeInsets.only(right: 0),
      child: Transform.scale(
        scale: isEditMode ? 1.2 : 1,
        child: Opacity(
          opacity: isNotLast ? 1 : 0.4,
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
                        initialValue: item.name,
                        onChanged: (value) {
                          item.name = value;
                          _updateItem(context, item, index);
                        },
                      )
                    : Text(
                        item.name,
                        textAlign: TextAlign.right,
                      ),
                onChanged: isEditMode && isNotLast
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
