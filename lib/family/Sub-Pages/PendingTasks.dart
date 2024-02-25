import 'package:flutter/material.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
// import 'package:mongo_dart/mongo_dart.dart';
import 'package:greenify/mongo/mongodb.dart';

final TextEditingController solutionsController = TextEditingController();
final AmplifyLogger _logger = AmplifyLogger('CropDoctorApp');
final _formKey = GlobalKey<FormState>();

class FormData {
  String solutions = '';
}

class PendingTasks extends StatefulWidget {
  @override
  _PendingTasks createState() => _PendingTasks();
}

class _PendingTasks extends State<PendingTasks> {
  List<StorageItem> list = [];
  var imageUrl = '';
  FormData formData = FormData();
  List<String> imageKeys = [];
  List<String> urls = [];

  @override
  void initState() {
    super.initState();
    _fetchImagesFromS3();
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

  Future<bool?> _showLeafFormDialog(File imageFile) async {
    return showDialog<bool?>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Enter Leaf Data'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: solutionsController,
                decoration: const InputDecoration(labelText: 'Solutions'),
                onChanged: (value) {
                  formData.solutions = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Solutions are required';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(false); // Form canceled
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop(true); // Form submitted
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  Future<void> downloadFileMobile(String key) async {
    final documentsDir = await getApplicationDocumentsDirectory();
    final filename = key.split('/').last;
    final filepath = '${documentsDir.path}/$filename';
    try {
      final result = await Amplify.Storage.downloadFile(
        key: key,
        localFile: AWSFile.fromPath(filepath),
        onProgress: (progress) {
          _logger.debug('Fraction completed: ${progress.fractionCompleted}');
        },
      ).result;

      _logger.debug('Downloaded file is located at: ${result.localFile.path}');

      if (filename.endsWith('.jpg') ||
          filename.endsWith('.png') ||
          filename.endsWith('.jpeg')) {
        // Handle image file
        // Image.file(File(result.localFile.path));
      } else {
        // Handle other file types if needed
      }
    } on StorageException catch (e) {
      _logger.debug(e.message);
    }
  }

  Future<void> downloadFileWeb(String key) async {
    final filename = key.split('/').last;
    try {
      final result = await Amplify.Storage.downloadFile(
        key: key,
        localFile: AWSFile.fromPath(filename),
        onProgress: (p0) => _logger
            .debug('Progress: ${(p0.transferredBytes / p0.totalBytes) * 100}%'),
      ).result;

      if (filename.endsWith('.jpg') ||
          filename.endsWith('.png') ||
          filename.endsWith('.jpeg')) {
        // Handle image file
        // Image.network(result.url);
      } else {
        // Handle other file types if needed
      }

      await _fetchImagesFromS3();
    } on StorageException catch (e) {
      _logger.debug('Download error - ${e.message}');
    }
  }

  Future<void> removeFile({
    required String key,
    required StorageAccessLevel accessLevel,
  }) async {
    try {
      await Amplify.Storage.remove(
        key: key,
        options: StorageRemoveOptions(accessLevel: accessLevel),
      ).result;
      setState(() {
        imageUrl = '';
      });
      await _fetchImagesFromS3();
    } on StorageException catch (e) {
      _logger.debug('Delete error - ${e.message}');
    }
  }

  Future<String> getUrl({
    required String key,
    required StorageAccessLevel accessLevel,
  }) async {
    try {
      final result = await Amplify.Storage.getUrl(
        key: key,
        options: const StorageGetUrlOptions(
          accessLevel: StorageAccessLevel.private,
          pluginOptions: S3GetUrlPluginOptions(
            validateObjectExistence: true,
            expiresIn: Duration(minutes: 1),
          ),
        ),
      ).result;
      setState(() {
        imageUrl = result.url.toString();
      });
      return result.url.toString();
    } on StorageException catch (e) {
      _logger.error('Get URL error - ${e.message}');
      rethrow;
    }
  }

  Future<void> _fetchImagesFromS3() async {
    try {
      final result = await Amplify.Storage.list(
        options: const StorageListOptions(
          accessLevel: StorageAccessLevel.private,
          pluginOptions: S3ListPluginOptions.listAll(),
        ),
      ).result;
      setState(() {
        list = result.items;
        imageKeys.clear();
        urls.clear();
      });
      for (StorageItem item in list) {
        if (item.key.endsWith('.jpg') ||
            item.key.endsWith('.png') ||
            item.key.endsWith('.jpeg') ||
            item.key.endsWith('.webp')) {
          setState(() {
            imageKeys.add(item.key);
          });
        }
      }
      for (String i in imageKeys) {
        final imageUrl =
            await getUrl(key: i, accessLevel: StorageAccessLevel.private);
        // print("URL: $imageUrl"); // For debugging
        setState(() {
          urls.add(imageUrl);
        });
      }
    } catch (e) {
      print("Error fetching images: $e");
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
    String solution = "";
    String id = "";
    if (leafNameAndProblem != null) {
      id = leafNameAndProblem['_id'];
      leafProblem = leafNameAndProblem['leafproblem'];
      leafName = leafNameAndProblem['leafname'];
      solution = leafNameAndProblem['solution'];
    } else {
      print('Leaf data not found for ID: $uniqueKey');
    }

    // Controllers for editing
    TextEditingController solutionController =
        TextEditingController(text: solution);
    // TextEditingController problemController =
    //     TextEditingController(text: leafProblem);

    await showDialog(
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
                    style: TextStyle(
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
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Solution:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  TextFormField(
                    controller: solutionController,
                    decoration: const InputDecoration(
                      hintText: 'Write solution here!',
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () async {
                      // Get the updated crop name and problem
                      String updatedSolutions = solutionController.text;

                      // Close the dialog before making the asynchronous call
                      Navigator.of(context).pop();

                      // Update data in the AWS backend
                      await MongoDatabase.updateSolutions(
                        id,
                        updatedSolutions,
                      );
                      // Fetch images again to update the UI
                      // await _fetchImagesFromS3();
                    },
                    child: const Text('Update Solutions'),
                  ),
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
      body: RefreshIndicator(
        onRefresh: () async {
          await _fetchImagesFromS3();
        },
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                ),
                padding: const EdgeInsets.all(10.0),
                itemCount: urls.length,
                itemBuilder: (BuildContext context, int index) {
                  final item = list[index];

                  return Hero(
                    tag: 'image$index', // Unique tag for each image
                    child: Card(
                      elevation: 5.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: InkWell(
                        onTap: () {
                          _showImageDetailsDialog(
                              urls[index], imageKeys[index], index);
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(16.0),
                                ),
                                child: Stack(
                                  children: [
                                    Image.network(
                                      urls[index],
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                    ),
                                    Positioned(
                                      top: 8.0,
                                      right: 8.0,
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          onTap: () {
                                            // Handle download
                                            downloadFileMobile(item.key);
                                          },
                                          borderRadius: BorderRadius.circular(
                                              20.0), // Adjust the radius as needed
                                          child: Container(
                                            padding: EdgeInsets.all(8.0),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color:
                                                  Colors.white.withOpacity(0.8),
                                            ),
                                            child: const Icon(
                                              Icons.download,
                                              color: Colors
                                                  .blue, // Set the color of the icon
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: FutureBuilder<String>(
                                future: _extractCropName(imageKeys[index]),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    if (snapshot.hasData) {
                                      return Text(
                                        snapshot.data!,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0,
                                          color: Colors.black87,
                                        ),
                                      );
                                    } else if (snapshot.hasError) {
                                      return Text(
                                        'Error: ${snapshot.error}',
                                        style: TextStyle(
                                          color: Colors.red,
                                        ),
                                      );
                                    } else {
                                      return const Text(
                                        'Loading...',
                                        style: TextStyle(
                                          color: Colors.grey,
                                        ),
                                      );
                                    }
                                  } else {
                                    return const Text(
                                      'Loading...',
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
