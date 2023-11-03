// ignore_for_file: prefer_const_literals_to_create_immutables
import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:flutter/material.dart';
import 'package:greenify/farmer/lobby_page.dart';

class FarmerPage extends StatefulWidget {
  FarmerPage({Key? key}) : super(key: key);

  @override
  _FarmerPageState createState() => _FarmerPageState();
}

class _FarmerPageState extends State<FarmerPage> {
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
    return Authenticator(
      initialStep: AuthenticatorStep.signIn,
      child: MaterialApp(
        theme: ThemeData.from(
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.red,
            backgroundColor: Colors.white,
          ),
        ).copyWith(
          indicatorColor: Colors.red,
        ),
        // set the dark theme (optional)
        darkTheme: ThemeData.from(
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.red,
            backgroundColor: Colors.black,
            brightness: Brightness.dark,
          ),
        ),
        // set the theme mode to respond to the user's system preferences (optional)
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        builder: Authenticator.builder(),
        home: Scaffold(
          body: Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const LobbyPage()),
                );
              },
              child: const Text('Log In'),
            ),
          ),
        ),
      ),
    );
  }
}

class SignupContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Authenticator(
      initialStep: AuthenticatorStep.signUp,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        builder: Authenticator.builder(),
        home: const Scaffold(
          body: Center(
            child: Text('You are logged in!'),
          ),
        ),
      ),
    );
  }
}
