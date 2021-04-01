import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.yellowAccent[100],
      child: Center(
        child: Image.asset('assets/images/cartsicon.png'),
      ),
    );
  }
}
