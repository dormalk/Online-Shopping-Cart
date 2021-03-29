import 'package:flutter/material.dart';
import 'package:online_shopping_cart/views/cartScreen.dart';
import './views/mainScreen.dart';
import 'package:provider/provider.dart';
import './providers/storage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => Storage())],
      child: MaterialApp(
        title: 'Online Shopping Cart',
        theme: ThemeData(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (ctx) => MainScreen(),
          CartScreen.routeName: (ctx) => CartScreen()
        },
      ),
    );
  }
}
