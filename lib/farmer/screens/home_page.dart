import 'package:flutter/material.dart';
import 'package:greenify/farmer/widgets/app_drawer.dart';
import 'package:greenify/farmer/screens/image_picker_screen.dart';

class Home_Page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AWS Amplify for Flutter'),
      ),
      drawer: AppDrawer(),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            '''AWS''',
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (ctx) => SelectImage(),
            ),
          );
        },
        child: Icon(Icons.file_upload),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation
          .endFloat, // Adjust the location as needed
    );
  }
}
