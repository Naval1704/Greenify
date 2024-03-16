import 'package:flutter/material.dart';
import 'package:greenify/mongo/mongodb.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart';

final TextEditingController leafProblemController = TextEditingController();
final TextEditingController leafNameController = TextEditingController();
final TextEditingController solutionController = TextEditingController();
final AmplifyLogger _logger = AmplifyLogger('CropDoctorApp');
final _formKey = GlobalKey<FormState>();

class FormData {
  String leafName = '';
  String leafProblem = '';
  String solution = '';
}

class CropDoctor extends StatefulWidget {
  @override
  _CropDoctorState createState() => _CropDoctorState();
}

class _CropDoctorState extends State<CropDoctor> {
  List<StorageItem> list = [];
  var imageUrl = '';
  FormData formData = FormData();

  List<String> imageKeys = [];
  String cropName = '';
  List<String> urls = [];

  List<String> problemOptions = [];

  Map<String, dynamic>? get async => null;

  @override
  void initState() {
    super.initState();
    _fetchImagesFromS3();
    _loadProblemsFromCSV();
  }

  // Method to load problems from CSV
  Future<void> _loadProblemsFromCSV() async {
    try {
      // Load CSV file from assets (you need to place your CSV file in the assets folder)
      String csvData = await rootBundle.loadString('assets/problems.csv');
      // Parse CSV data
      List<List<dynamic>> rows = const CsvToListConverter().convert(csvData);
      // Extract problems from CSV rows
      List<String> problems = [];
      for (var row in rows) {
        problems
            .add(row[1].toString()); // Assuming problem is in the second column
      }
      setState(() {
        problemOptions = problems;
      });
    } catch (e) {
      print('Error loading problems from CSV: $e');
    }
  }

  Future<void> _uploadFile() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.camera),
                title: Text('Take a Photo'),
                onTap: () async {
                  Navigator.pop(context);
                  await _uploadFromCamera();
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Choose from Gallery'),
                onTap: () async {
                  Navigator.pop(context);
                  await _uploadFromGallery();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _uploadFromCamera() async {
    final image = await ImagePicker().getImage(source: ImageSource.camera);
    if (image != null) {
      await _processImageFile(File(image.path));
    }
  }

  Future<void> _uploadFromGallery() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png'],
      withReadStream: true,
      withData: false,
    );

    if (result != null) {
      await _processImageFile(File(result.files.single.path!));
    }
  }

  Future<void> _processImageFile(File imageFile) async {
    // Open the form to enter leaf name and problem
    bool? formSubmitted = await _showLeafFormDialog(imageFile);

    // Check if the form was submitted before processing the image file
    if (formSubmitted == null || !formSubmitted) {
      _logger.debug('Form canceled, not uploading file');
      return;
    }

    // Generate a unique identifier using the current timestamp
    String uniqueIdentifier = DateTime.now().microsecondsSinceEpoch.toString();
    const options = StorageUploadFileOptions(
      accessLevel: StorageAccessLevel.private,
    );

    // After the form is submitted, upload the file
    try {
      await Amplify.Storage.uploadFile(
        localFile: AWSFile.fromPath(imageFile.path),
        key: '$uniqueIdentifier.${imageFile.path.split('.').last}',
        options: options,
      ).result;

      await _fetchImagesFromS3();
    } on StorageException catch (e) {
      _logger.error('Error uploading file - ${e.message}');
    }

    solutionController.text = '';

    // Call the function to insert data when the button is pressed
    await MongoDatabase.insertLeafData(
      uniqueIdentifier.toString(),
      leafProblemController.text,
      leafNameController.text,
      solutionController.text,
      false,
    );
    leafNameController.clear();
    leafProblemController.clear();
  }

  Future<bool?> _showLeafFormDialog(File imageFile) async {
    String? selectedProblem;
    bool? formSubmitted = await showDialog<bool?>(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Enter Leaf Data',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20.0),
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: leafNameController,
                        decoration: InputDecoration(
                          labelText: 'Leaf Name',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          formData.leafName = value;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Leaf Name is required';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20.0),
                      DropdownButtonFormField<String>(
                        value: selectedProblem,
                        hint: Text('Select Problem'),
                        onChanged: (String? value) {
                          setState(() {
                            leafProblemController.text = value!;
                          });
                        },
                        items: [
                          ...problemOptions
                              .map((String problem) => DropdownMenuItem<String>(
                                    value: problem,
                                    child: Text(problem),
                                  )),
                        ],
                        decoration: InputDecoration(
                          labelText: 'Select Problem',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      TextFormField(
                        controller: leafProblemController,
                        decoration: InputDecoration(
                          labelText: 'Enter Custom Problem',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          leafProblemController.text = value;
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        leafNameController.clear();
                        leafProblemController.clear();
                        Navigator.of(context).pop(false);
                      },
                      child: Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          Navigator.of(context).pop(true);
                        }
                      },
                      child: Text('Submit'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );

    return formSubmitted;
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
      // Remove file from AWS storage
      await Amplify.Storage.remove(
        key: key,
        options: StorageRemoveOptions(accessLevel: accessLevel),
      ).result;

      // Remove corresponding URL and key from lists
      setState(() {
        if (imageKeys.contains(key)) {
          imageKeys.remove(key);
        }
        // Assuming urls list contains corresponding URLs for imageKeys
        urls.removeWhere((url) => url.contains(key));
      });

      // Delete corresponding data from database
      List<String> nameParts = key.split('.');
      String uniqueKey = nameParts[0];
      await MongoDatabase.deleteLeafData(uniqueKey);

      // Fetch images again to update the UI
      await _fetchImagesFromS3();
    } catch (e) {
      _logger.debug('Delete error: $e');
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
          bool checked =
              await checkedOrnot(item.key); // Check the 'checked' status
          if (!checked) {
            setState(() {
              imageKeys.add(item.key); // Add the key only if 'checked' is false
            });
          }
        }
      }
      for (String i in imageKeys) {
        final imageUrl = await getUrl(
          key: i,
          accessLevel: StorageAccessLevel.private,
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
    bool check = false;

    if (leafNameAndProblem != null) {
      leafProblem = leafNameAndProblem['leafproblem'];
      leafName = leafNameAndProblem['leafname'];
      check = leafNameAndProblem['checked'];
    } else {
      print('Leaf data not found for ID: $uniqueKey');
    }

    // Controllers for editing
    TextEditingController cropNameController =
        TextEditingController(text: leafName);
    TextEditingController problemController =
        TextEditingController(text: leafProblem);

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
                  TextFormField(
                    controller: cropNameController,
                    decoration: const InputDecoration(
                      hintText: 'Enter new crop name',
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
                  TextFormField(
                    controller: problemController,
                    decoration: const InputDecoration(
                      hintText: 'Enter new problem',
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () async {
                      // Get the updated crop name and problem
                      String updatedCropName = cropNameController.text;
                      String updatedProblem = problemController.text;

                      // Close the dialog before making the asynchronous call
                      Navigator.of(context).pop();

                      // Update data in the AWS backend
                      await MongoDatabase.updateData(
                        leafName,
                        leafProblem,
                        updatedProblem,
                        updatedCropName,
                        // Pass the solution parameter as needed
                      );
                      // Fetch images again to update the UI
                      await _fetchImagesFromS3();
                    },
                    child: const Text('Update'),
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
        child: urls.isEmpty
            ? const Center(
                child: Text(
                  'Upload the crop image',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : Column(
                children: [
                  Expanded(
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16.0,
                        mainAxisSpacing: 16.0,
                      ),
                      padding: const EdgeInsets.all(10.0),
                      itemCount: urls.length,
                      itemBuilder: (BuildContext context, int index) {
                        final item = list[index];

                        // Ensure that the index is within bounds before accessing urls
                        if (index < urls.length) {
                          return Card(
                            elevation: 5.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            color: Colors.white,
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
                                      borderRadius: const BorderRadius.vertical(
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
                                                  downloadFileMobile(item.key);
                                                },
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                                child: Container(
                                                  padding: EdgeInsets.all(5.0),
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.white
                                                        .withOpacity(0.8),
                                                  ),
                                                  child: const Icon(
                                                    Icons.download,
                                                    color: Colors.blue,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: 8.0,
                                            left: 8.0,
                                            child: Material(
                                              color: Colors.transparent,
                                              child: InkWell(
                                                onTap: () async {
                                                  bool confirmDelete =
                                                      await showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title: const Text(
                                                            'Confirm Deletion'),
                                                        content: const Text(
                                                          'Are you sure you want to delete this image?',
                                                        ),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop(false);
                                                            },
                                                            child: const Text(
                                                                'Cancel'),
                                                          ),
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop(true);
                                                            },
                                                            child: const Text(
                                                                'Delete'),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );

                                                  if (confirmDelete == true) {
                                                    List<String> nameParts =
                                                        item.key
                                                            .toString()
                                                            .split('.');
                                                    String uniqueKey =
                                                        nameParts[0];
                                                    await MongoDatabase
                                                        .deleteLeafData(
                                                            uniqueKey);
                                                    removeFile(
                                                      key: item.key,
                                                      accessLevel:
                                                          StorageAccessLevel
                                                              .private,
                                                    );
                                                  }
                                                },
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                                child: Container(
                                                  padding: EdgeInsets.all(5.0),
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.white
                                                        .withOpacity(0.8),
                                                  ),
                                                  child: const Icon(
                                                    Icons.delete,
                                                    color: Colors.red,
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
                                    padding: const EdgeInsets.all(2.0),
                                    child: FutureBuilder<String>(
                                      future:
                                          _extractCropName(imageKeys[index]),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.done) {
                                          if (snapshot.hasData) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(2.0),
                                              child: Text(
                                                snapshot.data!,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16.0,
                                                ),
                                              ),
                                            );
                                          } else if (snapshot.hasError) {
                                            return Text(
                                                'Error: ${snapshot.error}');
                                          } else {
                                            return Container(); // Empty container when data is loading
                                          }
                                        } else {
                                          return Container(); // Empty container when data is loading
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else {
                          // Handle the case where the index is out of bounds
                          return Container();
                        }
                      },
                    ),
                  ),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _uploadFile,
        label: const Text(
          'Upload Image',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        icon: const Icon(Icons.cloud_upload),
        backgroundColor: Colors.green,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
