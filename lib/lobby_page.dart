import 'package:flutter/material.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'farmer_page.dart';

class LobbyPage extends StatelessWidget {
  const LobbyPage({Key? key});
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
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Welcome to Your App!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'This is your home page.',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Add your button's functionality here
              },
              child: const Text('Click Me'),
            ),
            ElevatedButton(
              onPressed: () async {
                await _handleSignout(context); // Call the signout function
              },
              child: const Text('Signout'),
            ),
          ],
        ),
      ),
    );
  }
}
