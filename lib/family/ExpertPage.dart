import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:greenify/ff/login_page.dart';
import 'package:greenify/family/Sub-Pages/PendingTasks.dart';

class _ExpertPageState extends StatelessWidget {
  const _ExpertPageState({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      debugShowCheckedModeBanner: false,
      home: const ExpertPage(),
    );
  }
}

class ExpertPage extends StatefulWidget {
  const ExpertPage({Key? key}) : super(key: key);
  @override
  State<ExpertPage> createState() => _ExpertPage();
}

Future<void> _handleSignout(BuildContext context) async {
  try {
    await Amplify.Auth.signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  } on AuthException catch (e) {
    print("Error signing out: ${e.message}");
    // Handle error, show a message, or navigate to an error screen if needed
  }
}

class _ExpertPage extends State<ExpertPage> {
  Future<AuthUser?> getCurrentUser() async {
    final Expert = await Amplify.Auth.getCurrentUser();
    return Expert;
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
                'Greenify Expert',
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
          bottom: const TabBar(
            indicatorColor: Colors.black,
            tabs: <Widget>[
              Tab(
                text: 'Pending Tasks',
                icon: Icon(Icons.pending_actions_sharp),
              ),
              Tab(
                text: 'Completed Tasks',
                icon: Icon(Icons.done_all_sharp),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            // Center(child: HomePage()),
            Center(child: PendingTasks()),
            // Center(child: Tasks()),
          ],
        ),
        bottomNavigationBar: NavigationBar(
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          indicatorColor: Colors.redAccent,
          selectedIndex: currentPageIndex,
          destinations: const <Widget>[
            NavigationDestination(
              selectedIcon: Icon(Icons.home_filled),
              icon: Icon(Icons.home_filled),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.newspaper),
              label: 'News',
            ),
            NavigationDestination(
              icon: Icon(Icons.people_sharp),
              label: 'Community',
            ),
          ],
        ),
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
                            'Expert Details:',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            'email ID: $username',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.exit_to_app_sharp),
                      title: const Text(
                        "Sign Out",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
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
