import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:greenify/models/LeafInfo.dart';

class LeafScreen extends StatefulWidget {
  @override
  _LeafScreenState createState() => _LeafScreenState();
}

class _LeafScreenState extends State<LeafScreen> {
  final TextEditingController _leafNameController = TextEditingController();
  final TextEditingController _leafProblemController = TextEditingController();

  @override
  void dispose() {
    _leafNameController.dispose();
    _leafProblemController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Leaf Information'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: () {
                _showLeafInfoInputDialog();
              },
              child: Text('Create Leaf Info'),
            ),
            ElevatedButton(
              onPressed: () async {
                // Assuming you have an instance of LeafInfo to delete
                // LeafInfo modelToDelete = ...;
                // await deleteLeafInfo(modelToDelete);
              },
              child: Text('Delete Leaf Info'),
            ),
            ElevatedButton(
              onPressed: () async {
                // List<LeafInfo?> items = await queryListItems();
                // Handle the items retrieved from the query as needed
                // print('List of Leaf Info: $items');
              },
              child: Text('Query Leaf Info List'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showLeafInfoInputDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Leaf Information'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _leafNameController,
                decoration: InputDecoration(labelText: 'Leaf Name'),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _leafProblemController,
                decoration: InputDecoration(labelText: 'Leaf Problem'),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                createLeafInfo(
                    _leafNameController.text, _leafProblemController.text);
                Navigator.of(context)
                    .pop(); // Close the dialog after creating leaf info
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  Future<void> createLeafInfo(String name, String problem) async {
    // try {
    //   LeafInfo model = LeafInfo(
    //     leaf_name: name,
    //     leaf_problem: problem,
    //   );
    //   final request = ModelMutations.create(model);
    //   final response = await Amplify.API.mutate(request: request).response;

    //   final createdLeafInfo = response.data;
    //   if (createdLeafInfo == null) {
    //     print('errors: ${response.errors}');
    //     return;
    //   }
    //   print('Mutation result: ${createdLeafInfo.id}');
    // } on ApiException catch (e) {
    //   print('Mutation failed: $e');
    // }
    // await Amplify.DataStore.start();
    final item = LeafInfo(
        leafname: "Lorem ipsum dolor sit amet",
        leafproblem: "Lorem ipsum dolor sit amet",
        );
    await Amplify.DataStore.save(item);
    // await Amplify.DataStore.clear();
  }

  // Implement the methods you provided in the earlier code section here
  // You can copy and paste them as is or refine them as needed.

//   Future<void> updateLeafInfo(LeafInfo originalLeafInfo) async {
//     final updatedModel = originalLeafInfo.copyWith(
//         leaf_name: "Lorem ipsum dolor sit amet",
//         leaf_problem: "Lorem ipsum dolor sit amet");

//     final request = ModelMutations.update(updatedModel);
//     final response = await Amplify.API.mutate(request: request).response;
//     print('Response: $response');
//   }

//   Future<void> deleteLeafInfo(LeafInfo modelToDelete) async {
//     final request = ModelMutations.delete(modelToDelete);
//     final response = await Amplify.API.mutate(request: request).response;
//     print('Response: $response');
//   }

// // // or delete by ID, ideal if you do not have the instance in memory, yet
// // Future<void> deleteLeafInfoById(LeafInfo modelToDelete) async {
// //   final request = ModelMutations.deleteById(LeafInfo.classType, 'ENTER ID HERE');
// //   final response = await Amplify.API.mutate(request: request).response;
// //   print('Response: $response');
// // }

//   Future<List<LeafInfo?>> queryListItems() async {
//     try {
//       final request = ModelQueries.list(LeafInfo.classType);
//       final response = await Amplify.API.query(request: request).response;

//       final items = response.data?.items;
//       if (items == null) {
//         print('errors: ${response.errors}');
//         return <LeafInfo?>[];
//       }
//       return items;
//     } on ApiException catch (e) {
//       print('Query failed: $e');
//     }
//     return <LeafInfo?>[];
//   }
// }
}
