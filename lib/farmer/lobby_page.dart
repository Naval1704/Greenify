import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/material.dart';
import 'package:greenify/farmer/sub-pages/cropdoctor.dart';
import 'package:greenify/farmer/sub-pages/homepage.dart';
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
              icon: const Icon(Icons.shopping_cart_outlined),
              onPressed: () {
                // Handle Cart button press
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
                      leading: Icon(Icons.exit_to_app),
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

// class NestedTabBar extends StatefulWidget {
//   const NestedTabBar(this.outerTab, {super.key});
//
//   final String outerTab;
//
//   @override
//   State<NestedTabBar> createState() => _NestedTabBarState();
// }
//
// class _NestedTabBarState extends State<NestedTabBar>
//     with TickerProviderStateMixin {
//   late final TabController _tabController;
//
//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//   }
//
//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: <Widget>[
//         Expanded(
//           child: TabBarView(
//             controller: _tabController,
//             children: <Widget>[
//               Card(
//                 margin: const EdgeInsets.all(16.0),
//                 child: Center(child: Text('${widget.outerTab}: Overview tab')),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

// class TabBarExample extends StatelessWidget {
//   const TabBarExample({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       initialIndex: 1,
//       length: 3,
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Row(
//             children: [
//               Text(
//                 'Greenify',
//                 style: TextStyle(
//                     color: Colors.black,
//                     fontSize: 25,
//                     fontWeight: FontWeight.bold),
//               ),
//             ],
//           ),
//           bottom: const TabBar(
//             tabs: <Widget>[
//               Tab(
//                 icon: Icon(Icons.home_filled),
//               ),
//               Tab(
//                 icon: Icon(Icons.energy_savings_leaf),
//               ),
//               Tab(
//                 icon: Icon(Icons.task_sharp),
//               ),
//             ],
//           ),
//           actions: <Widget>[
//             IconButton(
//               iconSize: 28,
//               icon: const Icon(Icons.notifications_none),
//               onPressed: () {
//                 // Handle Notification button press
//               },
//             ),
//             IconButton(
//               iconSize: 28,
//               icon: const Icon(Icons.shopping_cart_outlined),
//               onPressed: () {
//                 // Handle Cart button press
//               },
//             ),
//           ],
//         ),
//         body: const TabBarView(
//           children: <Widget>[
//             Center(
//               child: Text("Home"),
//             ),
//             Center(
//               child: Text("Crop Doctor"),
//             ),
//             Center(
//               child: Text("Tasks"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

// ------------------------------------

// int currentTabIndex = 0;
// int currentTabPageIndex = 0;
// final List<Tab> tabs = [
//   const Tab(text: 'Home'),
//   const Tab(text: 'Crop Doctor'),
//   const Tab(text: 'Tasks'),
// ];
//
// void onTabTapped(int index) {
//   setState(() {
//     currentTabIndex = index;
//     currentTabPageIndex = index;
//   });
// }
//
// @override
// Widget build(BuildContext context) {
//   return DefaultTabController(
//     length: tabs.length,
//     child: Scaffold(
//       key: _scaffoldKey,
//       appBar: AppBar(
//         toolbarHeight: 60,
//         automaticallyImplyLeading: false,
//         flexibleSpace: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               colors: [
//                 Color(0xFF1EFF34),
//                 Color(0xFF47FF4B),
//                 Color(0xFF14FF00),
//               ],
//               begin: Alignment.topCenter,
//               end: Alignment.topCenter,
//             ),
//           ),
//         ),
//         title: Row(
//           children: [
//             IconButton(
//               iconSize: 40,
//               icon: const Icon(Icons.account_circle_sharp),
//               onPressed: () {
//                 _scaffoldKey.currentState?.openDrawer();
//               },
//             ),
//             const Text(
//               'Greenify',
//               style: TextStyle(
//                   color: Colors.black,
//                   fontSize: 22,
//                   fontWeight: FontWeight.bold),
//             ),
//           ],
//         ),
//         actions: <Widget>[
//           IconButton(
//             iconSize: 30,
//             icon: const Icon(Icons.notifications_none),
//             onPressed: () {
//               // Handle Notification button press
//             },
//           ),
//           IconButton(
//             iconSize: 30,
//             icon: const Icon(Icons.shopping_cart_outlined),
//             onPressed: () {
//               // Handle Cart button press
//             },
//           ),
//         ],
//         bottom: TabBar(
//           tabs: tabs,
//           labelColor: Colors.black,
//           unselectedLabelColor: Colors.white,
//           labelStyle: const TextStyle(fontWeight: FontWeight.bold),
//           indicator: const BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(50),
//               topRight: Radius.circular(50),
//             ),
//           ),
//           onTap: (int index) {
//             setState(() {
//               currentTabPageIndex = index;
//             });
//           },
//         ),
//       ),
//       body: TabBarView(
//         physics: const NeverScrollableScrollPhysics(),
//         children: <Widget>[
//           Center(child: HomePage()),
//           Center(child: CropDoctor()),
//           Center(child: Tasks()),
//         ],
//       ),
//       bottomNavigationBar: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.2),
//               spreadRadius: 5,
//               blurRadius: 7,
//               offset: Offset(0, -3),
//             ),
//           ],
//         ),
//         child: BottomNavigationBar(
//           type: BottomNavigationBarType.fixed,
//           currentIndex: currentTabIndex,
//           onTap: onTabTapped,
//           selectedLabelStyle: const TextStyle(
//             fontSize: 12,
//             fontWeight: FontWeight.bold,
//           ),
//           unselectedLabelStyle: const TextStyle(
//             fontSize: 12,
//             fontWeight: FontWeight.normal,
//           ),
//           items: [
//             BottomNavigationBarItem(
//               icon: Icon(
//                 Icons.home,
//                 size: 24,
//                 color: currentTabIndex == 0 ? Colors.blue : Colors.grey,
//               ),
//               label: 'Home',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(
//                 Icons.my_library_books,
//                 size: 24,
//                 color: currentTabIndex == 1 ? Colors.blue : Colors.grey,
//               ),
//               label: 'News',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(
//                 Icons.shopping_cart,
//                 size: 24,
//                 color: currentTabIndex == 2 ? Colors.blue : Colors.grey,
//               ),
//               label: 'Shop',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(
//                 Icons.people,
//                 size: 24,
//                 color: currentTabIndex == 3 ? Colors.blue : Colors.grey,
//               ),
//               label: 'Community',
//             ),
//           ],
//         ),
//       ),
//       drawer: Drawer(
//         child: ListView(
//           children: <Widget>[
//             const DrawerHeader(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [
//                     Color(0xFF1EFF34),
//                     Color(0xFF47FF4B),
//                     Color(0xFF14FF00),
//                   ],
//                   begin: Alignment.topCenter,
//                   end: Alignment.topCenter,
//                 ),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "youremail@example.com",
//                     style: TextStyle(color: Colors.white, fontSize: 14),
//                   ),
//                 ],
//               ),
//             ),
//             ListTile(
//               leading: Icon(Icons.home),
//               title: const Text("Home"),
//               onTap: () {
//                 // Handle Home button press
//                 Navigator.pop(context); // Close the drawer
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.my_library_books),
//               title: const Text("News"),
//               onTap: () {
//                 // Handle News button press
//                 Navigator.pop(context); // Close the drawer
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.shopping_cart),
//               title: const Text("Shop"),
//               onTap: () {
//                 // Handle Shop button press
//                 Navigator.pop(context); // Close the drawer
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.people),
//               title: const Text("Community"),
//               onTap: () {
//                 // Handle Community button press
//                 Navigator.pop(context); // Close the drawer
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.exit_to_app),
//               title: const Text("Sign Out"),
//               onTap: () {
//                 _handleSignout(context);
//               },
//             ),
//           ],
//         ),
//       ),
//     ),
//   );
// }
// }
