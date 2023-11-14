import 'package:flutter/material.dart';
import 'package:greenify/farmer/providers/auth.dart';

import 'package:greenify/farmer/screens/image_picker_screen.dart';
import 'package:greenify/farmer/screens/login_screen.dart';
import 'package:greenify/farmer/screens/session_details_screen.dart';
import 'package:greenify/farmer/screens/show_images_screen.dart';
import 'package:greenify/farmer/sub-pages/homepage.dart';
import 'package:greenify/farmer/sub-pages/pathprovider.dart';
// import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context, listen: false);

    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            AppBar(
              title: Text('AWS Amplify For Flutter'),
              automaticallyImplyLeading: false,
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) => HomePage(),
                  ),
                );
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('Show Session Details'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) => SessionDetailsScreen(),
                  ),
                );
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.cloud_upload),
              title: Text('Upload Images'),
              onTap: () async {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) => SelectImage(),
                  ),
                );
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.cloud_download),
              title: Text('Download Images'),
              onTap: () async {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) => ListBucketScreen(),
                  ),
                );
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Logout'),
              onTap: () async {
                // Signout the user
                await auth.signOut();

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) => AuthScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
