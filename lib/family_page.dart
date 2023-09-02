// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:greenify/family_form.dart';

class FamilyPage extends StatelessWidget {
  const FamilyPage({super.key});

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        // Gradient Background
        gradient: LinearGradient(
          colors: [Color(0xFF1EFF34), Color(0xFF47FF4B), Color(0xFF14FF00)],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
      ),
      child: Stack(
        children: [
          // Background Image for Login Page
          Positioned.fill(
            right: -10,
            top: -85,
            bottom: 500,
            child: Opacity(
              opacity: 0.9, // Adjust the opacity value as needed
              child: Image.asset(
                'assets/watermark.png', // Replace with your watermark image asset
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Card widget
              const SizedBox(height: 150),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Card(
                    // White card for login content
                    color: Colors.white, // Set card color to white
                    elevation: 20.0, // Add shadow to the card (optional)
                    margin: const EdgeInsets.all(10.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            25.0)), // Add margin around the card
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        minWidth: 300.0,
                        minHeight: 460.0,
                      ),
                      child: const Padding(
                        padding:
                            EdgeInsets.all(20.0), // Add padding inside the card

                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // For adding Login Functions and SignUp Functions
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
=======
    return Material(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          // Gradient Background
          gradient: LinearGradient(
            colors: [Color(0xFF1EFF34), Color(0xFF47FF4B), Color(0xFF14FF00)],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
        ),
        child: Center(
          child: SizedBox(
            width: 281,
            height: 444,
            child: Stack(
              children: <Widget>[
                Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    width: 281,
                    height: 444,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        const BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.25),
                          offset: Offset(0, 4),
                          blurRadius: 4,
                        ),
                      ],
                      color: const Color.fromRGBO(255, 255, 255, 1),
                    ),
                  ),
                ),
                Positioned.fill(
                  right: -500,
                  bottom: -400,
                  child: Opacity(
                    opacity: 0.8, // Adjust the opacity value as needed
                    child: Image.asset(
                      'assets/watermark.png', // Replace with your watermark image asset
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 36,
                  left: 37,
                  child: Container(
                    width: 218,
                    height: 36,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color.fromRGBO(240, 240, 240, 1),
                    ),
                  ),
                ),
                Positioned(
                  top: 36,
                  left: 37,
                  child: Container(
                    width: 109,
                    height: 36,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color.fromRGBO(255, 55, 55, 1),
                    ),
                  ),
                ),
                Positioned(
                  bottom:
                      140, // Adjust these values to position the button as desired
                  left: 80,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      primary: Colors.red,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 16),
                      shadowColor: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const FamilyFormPage()),
                      );
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontFamily: 'Aclonica'),
                    ),
                  ),
                ),
                const Positioned(
                  top: 46,
                  left: 65,
                  child: Text(
                    'Login',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Color.fromRGBO(255, 255, 255, 1),
                      fontFamily: 'Aclonica',
                      fontSize: 15,
                      letterSpacing: 0,
                      fontWeight: FontWeight.normal,
                      height: 1,
                    ),
                  ),
                ),
                const Positioned(
                  top: 46,
                  left: 163,
                  child: Text(
                    'Sign Up',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Color.fromRGBO(255, 0, 0, 1),
                      fontFamily: 'Aclonica',
                      fontSize: 15,
                      letterSpacing: 0,
                      fontWeight: FontWeight.normal,
                      height: 1,
                    ),
                  ),
                ),
                Positioned(
                  top: 116, // Adjust as needed
                  left: 47,
                  child: Container(
                    width: 200, // Adjust as needed
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Enter email or username',
                        hintStyle: TextStyle(
                          color: Color.fromRGBO(129, 129, 129, 1),
                          fontFamily: 'Aclonica',
                          fontSize: 10,
                          letterSpacing: 0,
                          fontWeight: FontWeight.normal,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.black), // Adjust as needed
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.red), // Adjust as needed
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 151, // Adjust as needed
                  left: 47,
                  child: Container(
                    width: 200, // Adjust as needed
                    child: TextFormField(
                      obscureText:
                          true, // Hides the input characters for password
                      decoration: const InputDecoration(
                        hintText: 'Password',
                        hintStyle: TextStyle(
                          color: Color.fromRGBO(129, 129, 129, 1),
                          fontFamily: 'Aclonica',
                          fontSize: 10,
                          letterSpacing: 0,
                          fontWeight: FontWeight.normal,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.black), // Adjust as needed
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.red), // Adjust as needed
                        ),
                      ),
                    ),
                  ),
                ),
                const Positioned(
                  top: 188,
                  left: 147,
                  child: Text(
                    'Forgot Password ?',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Color.fromRGBO(129, 129, 129, 1),
                      fontFamily: 'Aclonica',
                      fontSize: 10,
                      letterSpacing: 0,
                      fontWeight: FontWeight.normal,
                      height: 1,
                    ),
                  ),
                ),
                const Positioned(
                  top: 131,
                  left: 40,
                  child: Divider(
                    color: Color.fromRGBO(0, 0, 0, 1),
                    thickness: 1,
                  ),
                ),
                const Positioned(
                  top: 167,
                  left: 39,
                  child: Divider(
                    color: Color.fromRGBO(0, 0, 0, 1),
                    thickness: 1,
                  ),
                ),
                Positioned(
                  top: 148,
                  left: 233,
                  child: Container(
                    width: 17,
                    height: 16,
                    decoration: const BoxDecoration(),
                  ),
                ),
                Positioned(
                  bottom: 40,
                  left: 90,
                  right: 90,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        'assets/google.png',
                        width: 50,
                      ),
                      Image.asset(
                        'assets/meta.png',
                        width: 50,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
>>>>>>> origin/main
      ),
    );
  }
}

// style: ElevatedButton.styleFrom(
//   shape: RoundedRectangleBorder(
//     borderRadius:
//         BorderRadius.circular(25.0),
//   ),
//   primary: Colors
//       .red, // Use primary instead of backgroundColor
//   padding: EdgeInsets.symmetric(
//       horizontal: 40, vertical: 16),
//   shadowColor: Colors.black,
// ),
