import 'package:flutter/material.dart';
import 'farmer_page.dart'; // Import your Farmer page
import 'family_page.dart'; // Import your Family page

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text('Login')),
      backgroundColor: Colors.green,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1EFF34), Color(0xFF47FF4B), Color(0xFF14FF00)],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/agriculture.png'),
            const SizedBox(height: 40),
            const Text(
              'Greenify',
              style: TextStyle(
                fontFamily: 'Aclonica', // Use the 'Acrolinca' font
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Who are you ?',
              style: TextStyle(
                fontFamily: 'Aclonica',
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  // ignore: deprecated_member_use
                  primary:
                      const Color(0xFFFF3737), // Set the button color to green
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  shadowColor: Colors.black // Increase button size
                  ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FarmerPage()));
              },
              child: const Text(
                'Farmer',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontFamily: 'Aclonica',
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  backgroundColor:
                      const Color(0xFFFF3737), // Set the button color to green
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  shadowColor: Colors.black // Increase button size
                  ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FamilyPage()));
              },
              child: const Text(' Family ',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontFamily: 'Aclonica')),
            ),
          ],
        ),
      ),
    );
  }
}
