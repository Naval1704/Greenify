// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:greenify/family_form.dart';
import 'package:greenify/lobby_page.dart';

class FamilyPage extends StatefulWidget {
  FamilyPage({Key? key}) : super(key: key);

  @override
  _FamilyPageState createState() => _FamilyPageState();
}

class _FamilyPageState extends State<FamilyPage> {
  bool isLoginSelected = true;

  void toggleLoginSignup() {
    setState(() {
      isLoginSelected = !isLoginSelected;
    });
  }

  @override
  Widget build(BuildContext context) {
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
        child: Stack(
          alignment: const Alignment(0.0, 0.4),
          children: [
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
            SizedBox(
              width: 300,
              height: 444,
              child: Stack(
                children: <Widget>[
                  // const SizedBox(height: 30),
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      width: 300,
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
                  Positioned(
                    top: 20, // Adjust as needed
                    left: 30,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ElevatedButton(
                          onPressed: () {
                            if (!isLoginSelected) {
                              toggleLoginSignup();
                              // isLoginSelected = !isLoginSelected;
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor:
                                isLoginSelected ? Colors.white : Colors.red,
                            backgroundColor:
                                isLoginSelected ? Colors.red : Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 10),
                          ),
                          child: const Text(
                            "Login",
                            style: TextStyle(
                              fontFamily: 'Aclonica',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (isLoginSelected) {
                              toggleLoginSignup();
                              // isLoginSelected = !isLoginSelected;
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor:
                                isLoginSelected ? Colors.red : Colors.white,
                            backgroundColor:
                                isLoginSelected ? Colors.white : Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 10),
                          ),
                          child: const Text(
                            "Signup",
                            style: TextStyle(
                              fontFamily: 'Aclonica',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  isLoginSelected ? LoginContent() : SignupContent(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          Positioned(
            bottom:
                155, // Adjust these values to position the button as desired
            left: 47,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                backgroundColor: Colors.red,
                padding:
                    const EdgeInsets.symmetric(horizontal: 75, vertical: 16),
                shadowColor: Colors.black,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const LobbyPage()),
                );
              },
              child: const Text(
                'Login',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Aclonica'),
              ),
            ),
          ),
          Positioned(
            top: 100, // Adjust as needed
            left: 47,
            child: Container(
              width: 200, // Adjust as needed
              child: TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Phone Number',
                  hintStyle: TextStyle(
                    color: Color.fromRGBO(129, 129, 129, 1),
                    fontFamily: 'Aclonica',
                    fontSize: 12,
                    letterSpacing: 0,
                    fontWeight: FontWeight.bold,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.black), // Adjust as needed
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
            top: 320,
            left: 110,
            child: Text(
              '------ Or ------',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Color.fromRGBO(129, 129, 129, 1),
                fontFamily: 'Aclonica',
                fontSize: 11,
                letterSpacing: 0,
                fontWeight: FontWeight.bold,
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
    );
  }
}

// class LoginContent extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Authenticator(
//       initialStep: AuthenticatorStep.signIn,
//       child: MaterialApp(
//         debugShowCheckedModeBanner: false,
//         builder: Authenticator.builder(),
//         home: const Scaffold(
//           body: Center(
//             child: Text('You are logged in!'),
//           ),
//         ),
//       ),
//     );
//   }
// }

class SignupContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          Positioned(
            bottom:
                155, // Adjust these values to position the button as desired
            left: 47,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                backgroundColor: Colors.red,
                padding:
                    const EdgeInsets.symmetric(horizontal: 65, vertical: 16),
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
                'Sign Up',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Aclonica'),
              ),
            ),
          ),
          Positioned(
            top: 100, // Adjust as needed
            left: 47,
            child: Container(
              width: 200, // Adjust as needed
              child: TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Phone Number',
                  hintStyle: TextStyle(
                    color: Color.fromRGBO(129, 129, 129, 1),
                    fontFamily: 'Aclonica',
                    fontSize: 12,
                    letterSpacing: 0,
                    fontWeight: FontWeight.bold,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.black), // Adjust as needed
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
                obscureText: true, // Hides the input characters for password
                decoration: const InputDecoration(
                  hintText: 'OTP',
                  hintStyle: TextStyle(
                    color: Color.fromRGBO(129, 129, 129, 1),
                    fontFamily: 'Aclonica',
                    fontSize: 12,
                    letterSpacing: 0,
                    fontWeight: FontWeight.bold,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.black), // Adjust as needed
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
            top: 173,
            left: 200,
            child: Text(
              'Get OTP',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Color.fromRGBO(129, 129, 129, 1),
                fontFamily: 'Aclonica',
                fontSize: 11,
                letterSpacing: 0,
                fontWeight: FontWeight.bold,
                height: 1,
              ),
            ),
          ),
          const Positioned(
            top: 320,
            left: 110,
            child: Text(
              '------ Or ------',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Color.fromRGBO(129, 129, 129, 1),
                fontFamily: 'Aclonica',
                fontSize: 11,
                letterSpacing: 0,
                fontWeight: FontWeight.bold,
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
    );
  }
}
