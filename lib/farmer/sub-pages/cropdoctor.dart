import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'dart:io';

final AmplifyLogger _logger = AmplifyLogger('CropDoctorApp');

class FormData {
  String leafName = '';
  String leafProblem = '';
}

class CropDoctor extends StatefulWidget {
  @override
  _CropDoctorState createState() => _CropDoctorState();
}

class _CropDoctorState extends State<CropDoctor> {
  List<StorageItem> list = [];
  var imageUrl = '';
  FormData formData = FormData();

  @override
  void initState() {
    super.initState();
    _listAllPublicFiles();
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
    bool? formSubmitted = await _showLeafFormDialog();

    // Check if the form was submitted before uploading the file
    if (formSubmitted == null || !formSubmitted) {
      _logger.debug('Form canceled, not uploading file');
      return;
    }

    // Remove numbers from the end of the leaf name
    String sanitizedLeafName = formData.leafName;

    // Generate a unique identifier using the current timestamp
    String uniqueIdentifier = DateTime.now().microsecondsSinceEpoch.toString();

    // After the form is submitted, upload the file
    try {
      await Amplify.Storage.uploadFile(
        localFile: AWSFile.fromPath(imageFile.path),
        key:
            '$sanitizedLeafName${formData.leafProblem}_$uniqueIdentifier.${imageFile.path.split('.').last}',
        onProgress: (p) =>
            _logger.debug('Uploading: ${p.transferredBytes}/${p.totalBytes}'),
      ).result;

      await _listAllPublicFiles();
    } on StorageException catch (e) {
      _logger.error('Error uploading file - ${e.message}');
    }
  }

  Future<void> _listAllPublicFiles() async {
    try {
      final result = await Amplify.Storage.list(
        options: const StorageListOptions(
          accessLevel: StorageAccessLevel.guest,
          pluginOptions: S3ListPluginOptions.listAll(),
        ),
      ).result;
      setState(() {
        list = result.items;
      });
    } on StorageException catch (e) {
      _logger.error('List error - ${e.message}');
    }
  }

  Future<bool?> _showLeafFormDialog() async {
    // Reset the formData object
    formData = FormData();

    return showDialog<bool?>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Enter Leaf Information'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Leaf Name'),
              onChanged: (value) {
                formData.leafName = value + '_';
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Leaf Problem'),
              onChanged: (value) {
                formData.leafProblem = value;
              },
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(false); // Form canceled
            },
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(true); // Form submitted
            },
            child: Text('Submit'),
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

      await _listAllPublicFiles();
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
      await _listAllPublicFiles();
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
        options: StorageGetUrlOptions(
          accessLevel: accessLevel,
          pluginOptions: const S3GetUrlPluginOptions(
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
      _logger.debug('Get URL error - ${e.message}');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: ListView.builder(
                itemCount: list.length,
                itemBuilder: (BuildContext context, int index) {
                  final item = list[index];
                  return ListTile(
                    onTap: () {
                      getUrl(
                        key: item.key,
                        accessLevel: StorageAccessLevel.guest,
                      );
                    },
                    title: Text(item.key),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        removeFile(
                          key: item.key,
                          accessLevel: StorageAccessLevel.guest,
                        );
                      },
                      color: Colors.red,
                    ),
                    leading: IconButton(
                      icon: const Icon(Icons.download),
                      onPressed: () {
                        downloadFileMobile(item.key);
                      },
                    ),
                  );
                },
              ),
            ),
          ),
          if (imageUrl != '')
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(80),
                child: Image.network(imageUrl, height: 200),
              ),
            ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton(
                onPressed: _uploadFile,
                child: const Text('Upload Image'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
