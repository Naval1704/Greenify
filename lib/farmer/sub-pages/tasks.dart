import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:flutter/material.dart';
import 'package:greenify/mongo/mongodb_leaf.dart';

class Tasks extends StatefulWidget {
  @override
  _TasksState createState() => _TasksState();
}

class _TasksState extends State<Tasks> {
  List<String> imageKeys = [];
  List<StorageItem> list = [];
  List<String> urls = [];

  @override
  void initState() {
    super.initState();
    _fetchImagesFromS3();
  }

  Future<String> getUrl({
    required String key,
    required StorageAccessLevel accessLevel,
  }) async {
    try {
      final result = await Amplify.Storage.getUrl(
        key: key,
        options: const StorageGetUrlOptions(
          accessLevel: StorageAccessLevel.guest,
          pluginOptions: S3GetUrlPluginOptions(
            validateObjectExistence: true,
            expiresIn: Duration(minutes: 1),
          ),
        ),
      ).result;
      return result.url.toString();
    } on StorageException catch (e) {
      print('Get URL error - ${e.message}');
      rethrow;
    }
  }

  Future<void> _fetchImagesFromS3() async {
    String userId = '';
    try {
      final result = await Amplify.Auth.fetchUserAttributes();
      for (final element in result) {
        userId = element.value;
      }
    } on AuthException catch (e) {
      userId = '';
      safePrint('Error fetching user attributes: ${e.message}');
    }

    try {
      final result = await Amplify.Storage.list(
        options: const StorageListOptions(
          accessLevel: StorageAccessLevel.guest,
          pluginOptions: S3ListPluginOptions.listAll(),
        ),
      ).result;

      setState(() {
        list = result.items;
        imageKeys.clear();
        urls.clear();
      });

      for (StorageItem item in list) {
        // Check if the item belongs to the folder corresponding to the user ID
        if (item.key.startsWith(userId.split('.').first + '/')) {
          // Check if the item is an image file based on its extension
          if (item.key.endsWith('.jpg') ||
              item.key.endsWith('.png') ||
              item.key.endsWith('.jpeg') ||
              item.key.endsWith('.webp')) {
            bool checked =
                await checkedOrnot(item.key); // Check the 'checked' status
            if (checked) {
              setState(() {
                imageKeys
                    .add(item.key); // Add the key only if 'checked' is false
              });
            }
          }
        }
      }

      for (String i in imageKeys) {
        final imageUrl = await getUrl(
          key: i,
          accessLevel: StorageAccessLevel.guest,
        );
        setState(() {
          urls.add(imageUrl);
        });
      }
    } catch (e) {
      print("Error fetching images: $e");
    }
  }

  Future<String> _extractCropName(String imageKey) async {
    // Extracting information from imageName
    List<String> keyParts = imageKey.split('.');
    String uniqueKey = keyParts[0];

    // Fetch leafName and leafProblem based on uniqueKey
    Map<String, dynamic>? leafNameAndProblem =
        await MongoDatabase.fetchLeafNameAndProblemById(uniqueKey);

    if (leafNameAndProblem != null) {
      String leafName = leafNameAndProblem['leafname'];
      return leafName;
    } else {
      return 'Leaf data not found for ID: $uniqueKey';
    }
  }

  Future<bool> checkedOrnot(String imageKey) async {
    List<String> keyParts = imageKey.split('.');
    String uniqueKey = keyParts[0];
    Map<String, dynamic>? leafNameAndProblem =
        await MongoDatabase.fetchLeafNameAndProblemById(uniqueKey);

    if (leafNameAndProblem != null) {
      bool checked = leafNameAndProblem['checked'];
      return checked;
    } else {
      // Assuming leaf is not checked if data is not found
      return false;
    }
  }

  void _showImageDetailsDialog(
      String imageUrl, String imageName, int index) async {
    // Extracting information from imageName
    List<String> nameParts = imageName.split('.');
    String uniqueKey = nameParts[0];

    Map<String, dynamic>? leafNameAndProblem =
        await MongoDatabase.fetchLeafNameAndProblemById(uniqueKey);
    String leafProblem = "";
    String leafName = "";
    String solutions = "";

    if (leafNameAndProblem != null) {
      leafProblem = leafNameAndProblem['leafproblem'];
      leafName = leafNameAndProblem['leafname'];
      solutions = leafNameAndProblem['solution'];
    } else {
      print('Leaf data not found for ID: $uniqueKey');
    }

    // Controllers for editing
    TextEditingController cropNameController =
        TextEditingController(text: leafName);
    TextEditingController problemController =
        TextEditingController(text: leafProblem);

    // Mock data for demonstration, replace it with actual solution and tips
    String solutionByExpert = solutions;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16.0),
                    ),
                    child: Image.network(
                      imageUrl,
                      key: Key(imageUrl), // Add Key here
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Name of crop:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  Text(
                    leafName,
                    style: const TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  const Text(
                    'Problem:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  Text(
                    leafProblem,
                    style: const TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  const Text(
                    'Solution by Expert:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  Text(
                    solutionByExpert,
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  SizedBox(height: 8.0),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
          ),
          padding: const EdgeInsets.all(10.0),
          itemCount: urls.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                _showImageDetailsDialog(urls[index], imageKeys[index], index);
              },
              child: Card(
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(16.0),
                      ),
                      child: Image.network(
                        urls[index],
                        key: Key(urls[index]), // Add Key here
                        fit: BoxFit.cover,
                        height: 120.0,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: FutureBuilder<String>(
                        future: _extractCropName(imageKeys[index]),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            if (snapshot.hasData) {
                              return Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Text(
                                  snapshot.data!,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                  ),
                                ),
                              );
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              return Container();
                            }
                          } else {
                            return Container();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
