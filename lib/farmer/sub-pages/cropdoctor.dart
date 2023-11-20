// import 'package:amplify_flutter/amplify_flutter.dart';
// import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:flutter/material.dart';
// import 'package:greenify/aws/uploadimage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
// import 'package:amplify_secure_storage/amplify_secure_storage.dart';
// import 'package:greenify/amplifyconfiguration.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';

final AmplifyLogger _logger = AmplifyLogger('CropDoctorApp');

class CropDoctor extends StatefulWidget {
  @override
  _CropDoctorState createState() => _CropDoctorState();
}

class _CropDoctorState extends State<CropDoctor> {
  List<StorageItem> list = [];
  var imageUrl = '';

  @override
  void initState() {
    super.initState();
    _listAllPublicFiles();
  }

  // upload a file to the S3 bucket
  Future<void> _uploadFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png'],
      withReadStream: true,
      withData: false,
    );

    if (result == null) {
      _logger.debug('No file selected');
      return;
    }

    final platformFile = result.files.single;

    try {
      await Amplify.Storage.uploadFile(
        localFile: AWSFile.fromStream(
          platformFile.readStream!,
          size: platformFile.size,
        ),
        key: platformFile.name,
        onProgress: (p) =>
            _logger.debug('Uploading: ${p.transferredBytes}/${p.totalBytes}'),
      ).result;
      await _listAllPublicFiles();
    } on StorageException catch (e) {
      _logger.error('Error uploading file - ${e.message}');
    }
  }

  // list all files in the S3 bucket
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

  // download file on mobile
  Future<void> downloadFileMobile(String key) async {
    final documentsDir = await getApplicationDocumentsDirectory();
    final filename = key.split('/').last;
    final filepath = '${documentsDir.path}/$filename';
    try {
      final result = await Amplify.Storage.downloadFile(
        key: key,
        localFile: AWSFile.fromPath(filepath),
        onProgress: (progress) {
          safePrint('Fraction completed: ${progress.fractionCompleted}');
        },
      ).result;

      safePrint('Downloaded file is located at: ${result.localFile.path}');

      // Handle the downloaded file based on its type (generic, image, video)
      if (filename.endsWith('.jpg') ||
          filename.endsWith('.png') ||
          filename.endsWith('.jpeg')) {
        // Handle image file
        // Example: Display the image using Flutter's Image.file widget
        // Image.file(File(result.localFile.path));
      } else if (filename.endsWith('.mp4') || filename.endsWith('.mov')) {
        // Handle video file
        // Example: Play the video using Flutter's video_player package
        // VideoPlayerController.file(File(result.localFile.path));
      } else {
        // Handle other file types if needed
      }
    } on StorageException catch (e) {
      safePrint(e.message);
    }
  }

  // download file on web
  Future<void> downloadFileWeb(String key) async {
    final filename =
        key.split('/').last; // Extracting the filename from the key
    try {
      final result = await Amplify.Storage.downloadFile(
        key: key,
        localFile: AWSFile.fromPath(filename),
        onProgress: (p0) => _logger
            .debug('Progress: ${(p0.transferredBytes / p0.totalBytes) * 100}%'),
      ).result;

      // Handle the downloaded file based on its type (generic, image, video)
      if (filename.endsWith('.jpg') ||
          filename.endsWith('.png') ||
          filename.endsWith('.jpeg')) {
        // Handle image file
        // Example: Display the image using Flutter's Image.network widget
        // Image.network(result.url);
      } else if (filename.endsWith('.mp4') || filename.endsWith('.mov')) {
        // Handle video file
        // Example: Play the video using Flutter's video_player package
        // VideoPlayerController.network(result.url);
      } else {
        // Handle other file types if needed
      }

      await _listAllPublicFiles();
    } on StorageException catch (e) {
      _logger.error('Download error - ${e.message}');
    }
  }

  // delete file from S3 bucket
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
        // set the imageUrl to empty if the deleted file is the one being displayed
        imageUrl = '';
      });
      await _listAllPublicFiles();
    } on StorageException catch (e) {
      _logger.error('Delete error - ${e.message}');
    }
  }

  // get the url of a file in the S3 bucket
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
      _logger.error('Get URL error - ${e.message}');
      rethrow;
    }
  }

  // final String imagesKey = 'pastImages';

  // Future<void> openCamera() async {
  //   final picker = ImagePicker();
  //   final pickedFile = await picker.getImage(source: ImageSource.camera);
  //   if (pickedFile != null) {
  //     // Do something with the captured image (e.g., display it).
  //     _uploadFile;
  //   }
  // }
  //
  // Future<void> openGallery() async {
  //   final picker = ImagePicker();
  //   final pickedFile = await picker.getImage(source: ImageSource.gallery);
  //   if (pickedFile != null) {
  //     // Do something with the selected image (e.g., display it).
  //     _uploadFile;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Crop Doctor'),
      // ),
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
          // display the image with the url
          if (imageUrl != '')
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(80),
                child: Image.network(imageUrl, height: 200),
              ),
            ),
          // upload file button
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

// Future<void> listAlbum() async {
//   try {
//     String? nextToken;
//     bool hasNextPage;
//     do {
//       final result = await Amplify.Storage.list(
//         path: 'album/',
//         options: StorageListOptions(
//           accessLevel: StorageAccessLevel.private,
//           pageSize: 50,
//           nextToken: nextToken,
//           pluginOptions: const S3ListPluginOptions(
//             excludeSubPaths: true,
//           ),
//         ),
//       ).result;
//       safePrint('Listed items: ${result.items}');
//       nextToken = result.nextToken;
//       hasNextPage = result.hasNextPage;
//     } while (hasNextPage);
//   } on StorageException catch (e) {
//     safePrint('Error listing files: ${e.message}');
//     rethrow;
//   }
// }

// import 'package:amplify_flutter/amplify.dart';
// import 'package:amplify_storage_s3/amplify_storage_s3.dart';

// Future<String> getUrl({
//   required String key,
//   required StorageAccessLevel accessLevel,
// }) async {
//   try {
//     final result = await Amplify.Storage.getUrl(
//       key: key,
//       options: StorageGetUrlOptions(
//         accessLevel: accessLevel,
//         pluginOptions: const S3GetUrlPluginOptions(
//           validateObjectExistence: true,
//           expiresIn: Duration(minutes: 1),
//         ),
//       ),
//     ).result;
//     setState(() {
//       var imageUrl = result.url.toString();
//     });
//     return result.url.toString();
//   } on StorageException catch (e) {
//     var _logger;
//     _logger.error('Get URL error - ${e.message}');
//     rethrow;
//   }
// }

// void setState(Null Function() param0) {}

// import 'package:path_provider/path_provider.dart';
//
// Future<void> downloadToLocalFile(String key) async {
//   final documentsDir = await getApplicationDocumentsDirectory();
//   final filepath = documentsDir.path + '/example.txt';
//   try {
//     final result = await Amplify.Storage.downloadFile(
//       key: key,
//       localFile: AWSFile.fromPath(filepath),
//       onProgress: (progress) {
//         safePrint('Fraction completed: ${progress.fractionCompleted}');
//       },
//     ).result;
//
//     safePrint('Downloaded file is located at: ${result.localFile.path}');
//   } on StorageException catch (e) {
//     safePrint(e.message);
//   }
// }
