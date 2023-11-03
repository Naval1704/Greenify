import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:greenify/farmer/farmer_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int count = 0;

  void incrementCount() {
    setState(() {
      count += 1;
    });
  }

  Future<void> _handleSignout(BuildContext context) async {
    try {
      await Amplify.Auth.signOut(); // Sign the user out from all devices
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => FarmerPage()),
      );
    } on AuthException catch (e) {
      print("Error signing out: ${e.message}");
      // Handle error, show a message, or navigate to an error screen if needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Count: $count',
              style: TextStyle(fontSize: 24),
            ),
            ElevatedButton(
              onPressed: incrementCount,
              child: Text('Increment'),
            ),
            ElevatedButton(
              onPressed: () {
                _handleSignout(context);
              },
              child: Text('Sign Out'),
            ),
          ],
        ),
      ),
    );
  }
}
