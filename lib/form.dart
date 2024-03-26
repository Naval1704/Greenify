import 'package:amplify_core/amplify_core.dart';
import 'package:flutter/material.dart';
import 'package:greenify/family/ExpertPage.dart';
import 'package:greenify/farmer/lobby_page.dart';
import 'package:greenify/mongo/mongodb_user.dart';

class UserDetailsForm extends StatefulWidget {
  const UserDetailsForm({Key? key}) : super(key: key);

  @override
  _UserDetailsFormState createState() => _UserDetailsFormState();
}

class UserDetails {
  final String username;
  final String email;
  final String phoneNumber;
  final bool isExpert;

  UserDetails({
    required this.username,
    required this.email,
    required this.phoneNumber,
    required this.isExpert,
  });
}

class _UserDetailsFormState extends State<UserDetailsForm> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  bool isExpert = false;
  bool _isLoading = true;
  final String fixedEmail = "example@example.com"; // Fixed email value

  @override
  void initState() {
    super.initState();
    _checkUserAndNavigate();
  }

  Future<void> _checkUserAndNavigate() async {
    String key = '';
    try {
      final result = await Amplify.Auth.fetchUserAttributes();
      for (final element in result) {
        key = element.value;
      }
    } on AuthException catch (e) {
      print('Error fetching user attributes: ${e.message}');
    }

    var userData = await MongoDatabase2.fetchUserDataById(key);

    print('$userData');

    setState(() {
      Future.delayed(const Duration(seconds: 3), () {
        setState(() {
          _isLoading = false;
        });
      }); // Turn off loading indicator
    });

    if (userData != null) {
      if (userData['group'] == 'farmer') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LobbyPage()),
        );
      } else if (userData['group'] == 'expert') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ExpertPage()),
        );
      }
    }
  }

  Future<void> _saveUserDetails(BuildContext context) async {
    UserDetails userDetails = UserDetails(
      username: usernameController.text,
      email: fixedEmail, // Fixed email value
      phoneNumber: phoneNumberController.text,
      isExpert: isExpert,
    );

    await MongoDatabase2.insertLeafData(
      userDetails.username,
      userDetails.email,
      userDetails.phoneNumber,
      userDetails.isExpert ? 'expert' : 'farmer',
    );

    Navigator.of(context).pop();
    if (userDetails.isExpert) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ExpertPage()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LobbyPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                value: null, // Disable animation
                strokeWidth: 3.0, // Adjust thickness if needed
                valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.redAccent), // Change color if needed
                backgroundColor:
                    Colors.grey, // Change background color if needed
                // Specify duration for the animation (e.g., 3 seconds)
                // Duration should match the time you want the CircularProgressIndicator to be visible
                semanticsValue: 'Loading...',
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Enter User Details',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: phoneNumberController,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          readOnly: true, // Make email field read-only
                          initialValue: fixedEmail, // Fixed email value
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  CheckboxListTile(
                    title: const Text('Are you an expert?'),
                    value: isExpert,
                    onChanged: (bool? value) {
                      if (value != null) {
                        setState(() {
                          isExpert = value;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => _saveUserDetails(context),
                    child: const Text('Save'),
                  ),
                ],
              ),
            ),
    );
  }
}
