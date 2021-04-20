import 'package:flutter/material.dart';
import 'package:online_shopping_cart/views/SplashScreen.dart';
import 'package:provider/provider.dart';
import '../providers/storage.dart';
import '../widgets/cartList.dart';
import 'package:uni_links/uni_links.dart';

import 'cartScreen.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool _initialized = false;
  bool removeMode = false;
  void init() async {
    if (!_initialized) {
      await Provider.of<Storage>(context, listen: false).initialize();
      Future.delayed(
          Duration(seconds: 1),
          () => setState(() {
                _initialized = true;
              }));
      checkLink();
    }
  }

  void checkLink() async {
    String initialLink = await getInitialLink();
    if (initialLink == null) return;
    String id = initialLink.split('link/')[1];
    final cartToDelete = await Navigator.of(context)
        .pushNamed(CartScreen.routeName, arguments: {'id': id});
    if (cartToDelete != null) {
      Future.delayed(new Duration(milliseconds: 200), () {
        Provider.of<Storage>(context, listen: false).removeCart(cartToDelete);
      });
    }
  }

  Widget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.brown[900],
      elevation: 0,
      title: InkWell(
        onTap: () {
          Provider.of<Storage>(context, listen: false).createCart();
        },
        child: Icon(
          Icons.add,
          size: 40,
        ),
      ),
      actions: [
        InkWell(
            onTap: () => setState(() {
                  if (removeMode)
                    removeMode = false;
                  else
                    removeMode = true;
                }),
            child: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Icon(
                !removeMode ? Icons.delete_rounded : Icons.delete_outline,
                size: 30,
              ),
            ))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    this.init();
    return _initialized
        ? Scaffold(
            appBar: _buildAppBar(),
            backgroundColor: Colors.yellowAccent[100],
            body: CartList(this.removeMode),
          )
        : SplashScreen();
  }
}
