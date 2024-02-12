import 'package:flutter/material.dart';
import 'package:greenify/mongo/mongodb.dart';
// import 'package:greenify/mongo/mongodb.dart';

class LeafScreen extends StatelessWidget {
  final TextEditingController leafProblemController = TextEditingController();
  final TextEditingController leafNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Leaf Data'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: leafProblemController,
              decoration: InputDecoration(labelText: 'Leaf Problem'),
            ),
            TextField(
              controller: leafNameController,
              decoration: InputDecoration(labelText: 'Leaf Name'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                // Call the function to insert data when the button is pressed
                await MongoDatabase.insertLeafData(
                  leafProblemController.text,
                  leafNameController.text,
                );
              },
              child: Text('Add Leaf Data'),
            ),
          ],
        ),
      ),
    );
  }
}
