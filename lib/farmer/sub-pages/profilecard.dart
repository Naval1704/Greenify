import 'package:flutter/material.dart';
import 'package:greenify/mongo/mongodb_user.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_core/amplify_core.dart';

class ProfileCard extends StatefulWidget {
  @override
  _ProfileCardState createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  String key = '';
  var userData;

  @override
  void initState() {
    super.initState();
    _fetchUserId();
  }

  Future<void> _fetchUserId() async {
    try {
      final result = await Amplify.Auth.fetchUserAttributes();
      for (final element in result) {
        key = element.value;
      }
      setState(() {});
    } on AuthException catch (e) {
      print('Error fetching user attributes: ${e.message}');
    }
    print('KEYYYY: $key');

    // Future<Map<String, dynamic>?>? _fetchUserData(String key) {
    //   try {
    //     return MongoDatabase2.fetchLeafDataById(key);
    //   } catch (e) {
    //     print('Error fetching user data: $e');
    //     return null;
    //   }
    // }
    userData = await MongoDatabase2.fetchLeafDataById(key);
  }

  @override
  Widget build(BuildContext context) {
    // var userData = _fetchUserData(key);

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Username: ${userData['username']}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 12),
                Text('Email: ${userData['email']}'),
                SizedBox(height: 12),
                Text('Phone Number: ${userData['phone']}'),
                SizedBox(height: 12),
                Text('Group: ${userData['group']}'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
