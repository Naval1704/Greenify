import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:greenify/models/LeafInfo.dart';

class Leaf{


  Future<void> createLeafInfo() async {
  try {
    final model = LeafInfo(
		leaf_name: "Lorem ipsum dolor sit amet",
		leaf_problem: "Lorem ipsum dolor sit amet");
    final request = ModelMutations.create(model);
    final response = await Amplify.API.mutate(request: request).response;

    final createdLeafInfo = response.data;
    if (createdLeafInfo == null) {
      safePrint('errors: ${response.errors}');
      return;
    }
    safePrint('Mutation result: ${createdLeafInfo.id}');
  } on ApiException catch (e) {
    safePrint('Mutation failed: $e');
  }
}

Future<void> updateLeafInfo(LeafInfo originalLeafInfo) async {
  final updatedModel = originalLeafInfo.copyWith(
		leaf_name: "Lorem ipsum dolor sit amet",
		leaf_problem: "Lorem ipsum dolor sit amet");

  final request = ModelMutations.update(updatedModel);
  final response = await Amplify.API.mutate(request: request).response;
  print('Response: $response');
}

Future<void> deleteLeafInfo(LeafInfo modelToDelete) async {
  final request = ModelMutations.delete(modelToDelete);
  final response = await Amplify.API.mutate(request: request).response;
  print('Response: $response');
}

// // or delete by ID, ideal if you do not have the instance in memory, yet
// Future<void> deleteLeafInfoById(LeafInfo modelToDelete) async {
//   final request = ModelMutations.deleteById(LeafInfo.classType, 'ENTER ID HERE');
//   final response = await Amplify.API.mutate(request: request).response;
//   print('Response: $response');
// }

Future<List<LeafInfo?>> queryListItems() async {
  try {
    final request = ModelQueries.list(LeafInfo.classType);
    final response = await Amplify.API.query(request: request).response;

    final items = response.data?.items;
    if (items == null) {
      print('errors: ${response.errors}');
      return <LeafInfo?>[];
    }
    return items;
  } on ApiException catch (e) {
    print('Query failed: $e');
  }
  return <LeafInfo?>[];
}

// or delete by ID, ideal if you do not have the instance in memory, yet
}

