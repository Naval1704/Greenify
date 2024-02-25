import 'package:flutter/material.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
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

  @override
  void initState() {
    super.initState();
    _fetchImagesFromS3();
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
    // Open the form to enter solutions
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

    // Call the function to insert data when the button is pressed
    // await MongoDatabase.insertLeafData(
    //   uniqueIdentifier.toString(),
    //   solutionsController.text,
    // );

    if (_formKey.currentState!.validate()) {
      solutionsController.clear();
      // Close the dialog or navigate away as needed
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
      });
    } catch (e) {
      print("Error fetching images: $e");
    }
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
                itemCount: list.length,
                itemBuilder: (BuildContext context, int index) {
                  final item = list[index];

                  return Card(
                    elevation: 5.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: InkWell(
                      onTap: () {
                        // Handle card tap
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(16.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Image.network(
                                  imageUrl, // You may need to update this with the correct URL
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text(
                              'Solutions: ${formData.solutions}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () async {
                                  // Handle delete
                                },
                                color: Colors.red,
                              ),
                              IconButton(
                                icon: const Icon(Icons.download),
                                onPressed: () {
                                  // Handle download
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: ElevatedButton.icon(
        onPressed: _uploadFile,
        icon: const Icon(
          Icons.upload,
          color: Colors.white,
        ),
        label: const Text(
          'Upload',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17),
        ),
        style: ElevatedButton.styleFrom(
          primary: Colors.redAccent,
          minimumSize: Size(150, 50), // Set the minimum size
          padding:
              EdgeInsets.symmetric(horizontal: 10), // Set horizontal padding
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
