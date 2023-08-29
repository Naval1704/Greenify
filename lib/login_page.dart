import 'package:flutter/material.dart';
import 'farmer_page.dart'; // Import your Farmer page
import 'family_page.dart'; // Import your Family page

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text('Login')),
      backgroundColor: Colors.green,
      body: Stack(
        children: [
          // Positioned(
          //   right: -500,
          //   bottom: -400,
          //   child: Opacity(
          //     opacity: 0.9, // Adjust opacity as needed
          //     child: Image.asset(
          //       'assets/watermark.png', // Replace with your watermark image path
          //       width: 950, // Adjust width as needed
          //     ),
          //   ),
          // ),
          Container(
            decoration: const BoxDecoration(
              // Gradient Background
              gradient: LinearGradient(
                colors: [
                  Color(0xFF1EFF34),
                  Color(0xFF47FF4B),
                  Color(0xFF14FF00)
                ],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Greenify',
                    style: TextStyle(
                      fontFamily: 'Aclonica', // Use the 'Aclonica' font
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Who are you?',
                    style: TextStyle(
                      fontFamily: 'Aclonica',
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        primary: Colors.red, // Set the button color to red
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 16),
                        shadowColor: Colors.black),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const FarmerPage()),
                      );
                    },
                    child: const Text(
                      '    Farmer    ',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontFamily: 'Aclonica'),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      primary: Colors.red, // Set the button color to red
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 16),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const FamilyPage()),
                      );
                    },
                    child: const Text(
                      '     Family     ',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontFamily: 'Aclonica'),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Positioned(
                    right: -500,
                    bottom: -400,
                    child: Opacity(
                      opacity: 0.9, // Adjust opacity as needed
                      child: Image.asset(
                        'assets/watermark.png', // Replace with your watermark image path
                        width: 950, // Adjust width as needed
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
// decoration: const BoxDecoration(
// // Gradient Background
// gradient: LinearGradient(
// colors: [
// Color(0xFF1EFF34),
// Color(0xFF47FF4B),
// Color(0xFF14FF00)
// ],
// begin: Alignment.bottomLeft,
// end: Alignment.topRight,
// ),
// ),
