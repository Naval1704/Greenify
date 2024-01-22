import 'package:flutter/material.dart';
import 'login_page.dart'; // Import your LoginPage

class StartPage extends StatefulWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  void initState() {
    super.initState();
    _navigateToLoginPage(); // Start the countdown when the page is loaded
  }

  void _navigateToLoginPage() {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const LoginPage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 254, 254, 254),
            ),
          
          child: Center(
            child: Image.asset(
              'assets/agriculture.png', // Replace with the actual asset path
              width: 100.0, // Adjust the width as needed
              height: 100.0, // Adjust the height as needed
            ),
          ),
        ),
      ),
    );
  }
}
