// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class FamilyPage extends StatelessWidget {
  const FamilyPage({super.key});

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
