import 'package:flutter/material.dart';

class communityPage extends StatefulWidget {
  @override
  _communityPageState createState() => _communityPageState();
}

class _communityPageState extends State<communityPage> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[Text('Community Page')],
        ),
      ),
    );
  }
}
