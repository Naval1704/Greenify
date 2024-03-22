import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/material.dart';
import 'package:greenify/farmer/sub-pages/cropdoctor.dart';
import 'package:greenify/farmer/sub-pages/homepage.dart';
import 'package:greenify/farmer/sub-pages/payement_gateway.dart';
import 'package:greenify/farmer/sub-pages/tasks.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:greenify/farmer/farmer_page.dart';

class _LobbyPageState extends StatelessWidget {
  const _LobbyPageState({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      debugShowCheckedModeBanner: false,
      home: const LobbyPage(),
    );
  }
}

class LobbyPage extends StatefulWidget {
  const LobbyPage({Key? key}) : super(key: key);
  @override
  State<LobbyPage> createState() => _LobbyPage();
}

Future<void> _handleSignout(BuildContext context) async {
  try {
    await Amplify.Auth.signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => FarmerPage()),
    );
  } on AuthException catch (e) {
    print("Error signing out: ${e.message}");
    // Handle error, show a message, or navigate to an error screen if needed
  }
}

class _LobbyPage extends State<LobbyPage> {
  Future<AuthUser?> getCurrentUser() async {
    final user = await Amplify.Auth.getCurrentUser();
    return user;
  }

  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Text(
                'Greenify',
                style: TextStyle(
                  color: Colors
                      .redAccent, // Set the text color to a prominent color
                  fontSize: 23, // Increase the font size for emphasis
                  fontWeight: FontWeight.bold,
                  fontFamily:
                      'Aclonica', // Use a specific font (ensure it's available)
                  letterSpacing:
                      1.2, // Add a slight letter spacing for better readability
                  shadows: [
                    Shadow(
                      color: Colors.black
                          .withOpacity(0.4), // Add a subtle shadow for depth
                      offset: Offset(0, 1),
                      blurRadius: 2,
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: <Widget>[
            IconButton(
              iconSize: 28,
              icon: const Icon(Icons.payment_outlined),
              onPressed: () {
                // Handle Cart button press
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PaymentGateway()));
              },
            ),
          ],
          bottom: const TabBar(
            indicatorColor: Colors.black,
            tabs: <Widget>[
              Tab(
                text: 'Home',
                icon: Icon(Icons.home_filled),
              ),
              Tab(
                text: 'Crop Doctor',
                icon: Icon(Icons.energy_savings_leaf),
              ),
              Tab(
                text: 'Notifications',
                icon: Icon(Icons.notifications),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            Center(child: HomePage()),
            Center(child: CropDoctor()),
            Center(child: Tasks()),
          ],
        ),
        // bottomNavigationBar: NavigationBar(
        //   onDestinationSelected: (int index) {
        //     setState(() {
        //       currentPageIndex = index;
        //     });
        //   },
        //   indicatorColor: Colors.redAccent,
        //   selectedIndex: currentPageIndex,
        //   destinations: const <Widget>[
        //     NavigationDestination(
        //       selectedIcon: Icon(Icons.home_filled),
        //       icon: Icon(Icons.home_filled),
        //       label: 'Home',
        //     ),
        //     NavigationDestination(
        //       icon: Icon(Icons.newspaper),
        //       label: 'News',
        //     ),
        //     NavigationDestination(
        //       icon: Icon(Icons.people_sharp),
        //       label: 'Community',
        //     ),
        //   ],
        // ),
        drawer: Drawer(
          child: FutureBuilder<AuthUser?>(
            future: getCurrentUser(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                final user = snapshot.data!;
                final signInDetails = user.signInDetails;
                final username =
                    user.signInDetails.toJson()['username'].toString();

                return ListView(
                  children: <Widget>[
                    DrawerHeader(
                      decoration: const BoxDecoration(
                        color: Colors.redAccent,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'User Details:',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            'mail ID: $username',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.account_box_rounded),
                      title: const Text(
                        "Your profile",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: Icon(Icons.payment_outlined),
                      title: const Text(
                        "Payments",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PaymentGateway()));
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.logout),
                      title: const Text(
                        "Sign Out",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.redAccent),
                      ),
                      onTap: () {
                        _handleSignout(context);
                      },
                    ),
                  ],
                );
              } else {
                // Handle loading state or error
                return CircularProgressIndicator();
              }
            },
          ),
        ),
      ),
    );
  }
}
