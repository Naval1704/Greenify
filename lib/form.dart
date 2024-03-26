import 'package:amplify_core/amplify_core.dart';
import 'package:flutter/material.dart';
import 'package:greenify/family/ExpertPage.dart';
import 'package:greenify/family/family_page.dart';
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
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  bool isExpert = false;

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

    var userData = await MongoDatabase2.fetchLeafDataById(key);

    print('$userData');

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
      email: emailController.text,
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
    return AlertDialog(
      title: Text('Enter User Details'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: phoneNumberController,
              decoration: InputDecoration(labelText: 'Phone Number'),
            ),
            CheckboxListTile(
              title: Text('Are you an expert?'),
              value: isExpert,
              onChanged: (bool? value) {
                setState(() {
                  isExpert = value!;
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () => _saveUserDetails(context),
          child: Text('Save'),
        ),
      ],
    );
  }
}
