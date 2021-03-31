import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:online_shopping_cart/models/cart.dart';
import 'package:online_shopping_cart/providers/storage.dart';
import 'package:online_shopping_cart/widgets/cartItemTile.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  static const routeName = '/cart';
  CartScreen({Key key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  Cart _currCart;
  Future<void> _copyPublicLinkToClipboard() async {
    String copyUrl = 'http://onlineshop.page.link/${_currCart.id}';
    await Clipboard.setData(ClipboardData(text: copyUrl));

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text(
        'Public link copied!',
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.grey[800],
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 3),
    ));
  }

  void _selectOption(String value) {
    if (value == 'Delete') {
      Navigator.of(context).pop(_currCart.id);
    } else if (value == 'Make Public') {
      _currCart.changeToOnlineCart(true);
      Provider.of<Storage>(context, listen: false).saveOnStorage();
      this._copyPublicLinkToClipboard();
    } else if (value == 'Disable Public') {
      _currCart.disableOnlineCart();
      Provider.of<Storage>(context, listen: false).saveOnStorage();
    } else if (value == 'Copy Public Link') {
      this._copyPublicLinkToClipboard();
    }
  }

  Widget _buildAppBar() {
    List<String> options = _currCart.isOnline
        ? ['Delete', 'Disable Public', 'Copy Public Link']
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

  void fetchCartFromDatabase(String id) async {
    _currCart =
        await Provider.of<Storage>(context, listen: true).getCartFromDB(id);
  }

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, Object>;
    final id = routeArgs['id'];
    _currCart = Provider.of<Storage>(context, listen: true).getCartById(id);
    if (_currCart == null) this.fetchCartFromDatabase(id);
    return Scaffold(
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
    );
  }
}
