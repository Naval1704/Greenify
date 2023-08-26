import 'package:flutter/material.dart';
import 'package:greenify/login_page.dart';
import 'package:greenify/start_page.dart';
// Import your StartPage

void main() {
  
  runApp(const MyApp());
  
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Your App Title',
      initialRoute: '/', // Set the initial route to '/'
      routes: {
        '/': (context) => const StartPage(), // Map the root route to the StartPage
        '/login': (context) => const LoginPage(), // Map the login route
        // Add more routes as needed
      },
    );
  }
}
