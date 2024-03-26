import 'package:amplify_core/amplify_core.dart';
import 'package:flutter/material.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:greenify/mongo/mongodb_user.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String key = '';
  bool _isLoading = false;
  var userData;
  TextEditingController usernameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

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

    userData = await MongoDatabase2.fetchUserDataById(key);
    usernameController.text = userData['username'];
    phoneNumberController.text = userData['phone'];
  }

  Future<void> _updateUserData() async {
    await MongoDatabase2.updateUserData(
      key,
      usernameController.text,
      phoneNumberController.text,
    );
    // Refresh user data after update
    setState(() {
      userData['username'] = usernameController.text;
      userData['phone'] = phoneNumberController.text;
      bool _isLoading = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Profile updated successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your Profile',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.redAccent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(5),
              child: Image.asset(
                'assets/userImage.jpg', // Replace with your image URL
                height: 300,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTextFieldWithTitle('Username:', usernameController),
                      SizedBox(height: 20),
                      _buildTextFieldWithTitle(
                          'Phone Number:', phoneNumberController),
                      SizedBox(height: 20),
                      _buildReadOnlyFieldWithTitle(
                          'Email:', userData != null ? userData['email'] : ""),
                      SizedBox(height: 20),
                      _buildReadOnlyFieldWithTitle(
                          'Group:', userData != null ? userData['group'] : ""),
                      SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.redAccent,
                        ),
                        child: _isLoading
                            ? const Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : TextButton.icon(
                                onPressed: _updateUserData,
                                icon: const Icon(
                                  Icons.update,
                                  color: Colors.white,
                                ),
                                label: const Text(
                                  'Update details',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextFieldWithTitle(
      String title, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey[200],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReadOnlyFieldWithTitle(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 5),
        Text(
          value,
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
