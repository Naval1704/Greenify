import 'package:flutter/material.dart';

class storePage extends StatefulWidget {
  @override
  _storePageState createState() => _storePageState();
}

class _storePageState extends State<storePage> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[Text('Store Page')],
        ),
      ),
    );
  }
}
