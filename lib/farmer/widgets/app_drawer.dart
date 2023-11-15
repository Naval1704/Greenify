import 'package:flutter/material.dart';
import 'package:greenify/farmer/providers/auth.dart';
import 'package:greenify/farmer/screens/home_page.dart';
import 'package:greenify/farmer/screens/image_picker_screen.dart';
import 'package:greenify/farmer/screens/session_details_screen.dart';
import 'package:greenify/farmer/screens/show_images_screen.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Auth()),
        // Add more providers if needed
      ],
      child: Drawer(
        child: SingleChildScrollView(
          child: Column(
            children: [
              AppBar(
                title: Text('AWS Amplify For Flutter'),
                automaticallyImplyLeading: true,
              ),
              ListTile(
                leading: Icon(Icons.home),
                title: Text('Home'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) => Home_Page(),
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
            ],
          ),
        ),
      ),
    );
  }
}
