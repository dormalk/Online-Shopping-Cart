import 'package:drag_and_drop_gridview/devdrag.dart';
import 'package:flutter/material.dart';
import 'package:online_shopping_cart/views/cartScreen.dart';
import 'package:online_shopping_cart/widgets/cartItemTile.dart';
import 'package:provider/provider.dart';
import '../providers/storage.dart';
import '../models/cart.dart';

class CartList extends StatefulWidget {
  bool removeMode = false;

  CartList(this.removeMode);

  @override
  _CartListState createState() => _CartListState();
}

class _CartListState extends State<CartList> {
  ScrollController _scrollController;

  Widget _buildButton(IconData icon, Function action) {
    return InkWell(
      onTap: action,
      child: Icon(
        icon,
        size: 30,
        color: Colors.white,
      ),
    );
  }

  Widget _buildbButtonsGroup(String id) {
    return Column(
      children: [
        Expanded(
          child: Container(
            color: Colors.black26,
          ),
        ),
        Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(color: Colors.black45),
              height: 60,
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildButton(
                      Icons.delete,
                      () => Provider.of<Storage>(context, listen: false)
                          .removeCart(id))
                ],
              )),
            ))
      ],
    );
  }

  Widget _buildCartWidget(Cart c) {
    return Hero(
      tag: c.id,
      child: Card(
          elevation: 2,
          color: c.isOnline ? Colors.blueAccent[100] : Colors.yellow[400],
          child: InkWell(
            onTap: () async {
              final cartToDelete = await Navigator.of(context)
                  .pushNamed(CartScreen.routeName, arguments: {'id': c.id});
              if (cartToDelete != null) {
                Future.delayed(new Duration(milliseconds: 200), () {
                  Provider.of<Storage>(context, listen: false)
                      .removeCart(cartToDelete);
                });
              }
            },
            child: Stack(
              children: [
                LayoutBuilder(
                  builder: (ctx, costrains) {
                    return GridTile(
                      key: Key(c.id),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                          itemCount: c.items.length < 4 ? c.items.length : 4,
                          itemBuilder: (ctx, index) => CartItemTile(
                            item: c.items[index],
                            index: index,
                            id: c.id,
                            isEditMode: false,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                widget.removeMode ? _buildbButtonsGroup(c.id) : Container()
              ],
            ),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Storage>(
        builder: (ctx, s, _) => DragAndDropGridView(
            controller: _scrollController,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, childAspectRatio: 3 / 4),
            padding: EdgeInsets.all(5),
            itemBuilder: (ctx, index) => _buildCartWidget(s.carts[index]),
            itemCount: s.carts.length,
            onWillAccept: (oldIndex, newIndex) => true,
            onReorder: s.switchPlaces));
  }
}
