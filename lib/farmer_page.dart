// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class FarmerPage extends StatelessWidget {
  const FarmerPage({super.key});

  @override
  Widget build(BuildContext context) {
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
                top: 238,
                left: 45,
                child: Container(
                  width: 218,
                  height: 36,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color.fromRGBO(255, 55, 55, 1),
                  ),
                ),
              ),
              const Positioned(
                top: 46,
                left: 70,
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
                top: 248,
                left: 128,
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
              const Positioned(
                top: 116,
                left: 47,
                child: Text(
                  'Enter email or username',
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
                top: 151,
                left: 47,
                child: Text(
                  'Password',
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
            ],
          ),
        ),
      ),
    );
  }
}
