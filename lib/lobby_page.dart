import 'package:flutter/material.dart';

class LobbyPage extends StatefulWidget {
  const LobbyPage({Key? key}) : super(key: key);

  @override
  _LobbyPageState createState() => _LobbyPageState();
}

class _LobbyPageState extends State<LobbyPage> {
  int currentPageIndex = 0;
  final List<Tab> tabs = [
    Tab(text: 'Home'),
    Tab(text: 'Crop Doctor'),
    Tab(text: 'Tasks'),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 60,
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
            decoration: BoxDecoration(
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
                icon: const Icon(Icons.account_circle),
                onPressed: () {
                  // Handle Account button press
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
              icon: const Icon(Icons.notifications),
              onPressed: () {
                // Handle Notification button press
              },
            ),
            IconButton(
              iconSize: 30,
              icon: const Icon(Icons.shopping_cart),
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
                currentPageIndex = index;
              });
            },
          ),
        ),
        body: const TabBarView(
          children: <Widget>[
            Center(child: Text('Home Content')),
            Center(child: Text('Crop Doctor Content')),
            Center(child: Text('Tasks Content')),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentPageIndex,
          onTap: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: Colors.black,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.library_books,
                color: Colors.black,
              ),
              label: 'News',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.store,
                color: Colors.black,
              ),
              label: 'Store',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.people,
                color: Colors.black,
              ),
              label: 'Community',
            ),
          ],
        ),
      ),
    );
  }
}
