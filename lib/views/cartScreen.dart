import 'package:flutter/material.dart';
import 'package:online_shopping_cart/models/cart.dart';
import 'package:online_shopping_cart/providers/storage.dart';
import 'package:online_shopping_cart/widgets/cartItemTile.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  static const routeName = 'cart';
  CartScreen({Key key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  Cart _currCart;

  void _selectOption(String value) {
    if (value == 'Delete') {
      Navigator.of(context).pop(_currCart.id);
    } else if (value == 'Make Public') {
      _currCart.changeToOnlineCart(true);
      Provider.of<Storage>(context, listen: false).saveOnStorage();
    } else if (value == 'Disable Public') {
      _currCart.disableOnlineCart();
      Provider.of<Storage>(context, listen: false).saveOnStorage();
    }
  }

  Widget _buildAppBar() {
    List<String> options = _currCart.isOnline
        ? ['Delete', 'Disable Public', 'View Public Link']
        : ['Delete', 'Make Public'];
    return AppBar(
      elevation: 0,
      actions: [
        PopupMenuButton<String>(
            onSelected: _selectOption,
            itemBuilder: (BuildContext ctx) {
              return options.map((String opt) {
                return PopupMenuItem<String>(
                  value: opt,
                  child: Text(opt),
                );
              }).toList();
            })
      ],
      backgroundColor:
          _currCart.isOnline ? Colors.blue[900] : Colors.brown[900],
    );
  }

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, Object>;
    final id = routeArgs['id'];
    _currCart = Provider.of<Storage>(context, listen: true).getCartById(id);
    return Hero(
        tag: id,
        child: Scaffold(
          backgroundColor: _currCart.isOnline
              ? Colors.blueAccent[100]
              : Colors.yellowAccent[100],
          appBar: _buildAppBar(),
          body: Container(
            child: ListView.builder(
              itemCount: _currCart.items.length,
              itemBuilder: (ctx, index) => CartItemTile(
                item: _currCart.items[index],
                index: index,
                id: _currCart.id,
              ),
            ),
          ),
        ));
  }
}
