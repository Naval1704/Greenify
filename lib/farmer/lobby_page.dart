import 'package:flutter/material.dart';
import 'package:greenify/farmer/sub-pages/cropdoctor.dart';
import 'package:greenify/farmer/sub-pages/homepage.dart';
import 'package:greenify/farmer/sub-pages/tasks.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:greenify/farmer/farmer_page.dart';

class LobbyPage extends StatefulWidget {
  const LobbyPage({Key? key}) : super(key: key);

  @override
  _LobbyPageState createState() => _LobbyPageState();
}

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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

class _LobbyPageState extends State<LobbyPage> {
  int currentTabIndex = 0;
  int currentTabPageIndex = 0;
  final List<Tab> tabs = [
    const Tab(text: 'Home'),
    const Tab(text: 'Crop Doctor'),
    const Tab(text: 'Tasks'),
  ];

  void onTabTapped(int index) {
    setState(() {
      currentTabIndex = index;
      currentTabPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          toolbarHeight: 60,
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF1EFF34),
                  Color(0xFF47FF4B),
                  Color(0xFF14FF00),
                ],
                begin: Alignment.topCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),
          title: Row(
            children: [
              IconButton(
                iconSize: 40,
                icon: const Icon(Icons.account_circle_sharp),
                onPressed: () {
                  // Handle Account button press
                  Scaffold.of(context).openDrawer();
                },
              ),
              const Text(
                'Greenify',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                ),
              ),
            ],
          ),
          actions: <Widget>[
            IconButton(
              iconSize: 30,
              icon: const Icon(Icons.notifications_none),
              onPressed: () {
                // Handle Notification button press
              },
            ),
            IconButton(
              iconSize: 30,
              icon: const Icon(Icons.shopping_cart_outlined),
              onPressed: () {
                // Handle Cart button press
              },
            ),
          ],
          bottom: TabBar(
            tabs: tabs,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.white,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            indicator: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50),
                topRight: Radius.circular(50),
              ),
            ),
            onTap: (int index) {
              setState(() {
                currentTabPageIndex = index;
              });
            },
          ),
        ),
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          children: <Widget>[
            Center(child: HomePage()),
            Center(child: CropDoctor()),
            const Center(child: Tasks()),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed, // Disable button transformation
          currentIndex: currentTabIndex,
          onTap: onTabTapped,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.library_books,
              ),
              label: 'News',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.store,
              ),
              label: 'Store',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.people,
              ),
              label: 'Community',
            ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              Container(
                color: Color(0xFF14FF00), // Set the background color to red
                child: const ListTile(
                  title:
                      Text("Your Name", style: TextStyle(color: Colors.white)),
                  subtitle: Text("youremail@example.com",
                      style: TextStyle(color: Colors.white)),
                  leading: CircleAvatar(
                      // Add user profile picture here
                      ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text("Sign Out"),
                onTap: () {
                  _handleSignout(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
