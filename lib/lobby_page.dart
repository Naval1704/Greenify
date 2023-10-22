import 'package:flutter/material.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'farmer_page.dart';

class LobbyPage extends StatefulWidget {
  const LobbyPage({Key? key}) : super(key: key);

  @override
  _LobbyPageState createState() => _LobbyPageState();
}

class _LobbyPageState extends State<LobbyPage> {
  int currentPageIndex = 0;

  Future<void> _handleSignout(BuildContext context) async {
    try {
      await Amplify.Auth.signOut(); // Sign the user out from all devices
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => FarmerPage()),
      );
    } on AuthException catch (e) {
      print("Error signing out: ${e.message}");
      // Handle error, show a message, or navigate to an error screen if needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentPageIndex,
        onTap: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Business',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'School',
          ),
        ],
      ),
      body: DefaultTabController(
        initialIndex: 1,
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('TabBar Sample'),
            bottom: TabBar(
              tabs: <Widget>[
                Tab(
                  icon: Icon(Icons.cloud_outlined),
                ),
                Tab(
                  icon: Icon(Icons.beach_access_sharp),
                ),
                Tab(
                  icon: Icon(Icons.brightness_5_sharp),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              // Add your tab content here
              // For example:
              Center(
                child: Text('Tab 1 Content'),
              ),
              Center(
                child: Text('Tab 2 Content'),
              ),
              Center(
                child: Text('Tab 3 Content'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
