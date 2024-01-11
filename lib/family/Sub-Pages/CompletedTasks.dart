import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:file_picker/file_picker.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'dart:io';

final AmplifyLogger _logger = AmplifyLogger('CropDoctorApp');

class CompletedTasks extends StatefulWidget {
  @override
  _CompletedTasksState createState() => _CompletedTasksState();
}

class _CompletedTasksState extends State<CompletedTasks> {
  List<StorageItem> list = [];
  var imageUrl = '';

  @override
  void initState() {
    super.initState();
    _listAllPublicFiles();
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

  Future<void> listAlbum() async {
    try {
      String? nextToken;
      bool hasNextPage;
      do {
        final result = await Amplify.Storage.list(
          path: 'album/',
          options: StorageListOptions(
            accessLevel: StorageAccessLevel.guest,
            pageSize: 50,
            nextToken: nextToken,
            pluginOptions: const S3ListPluginOptions(
              excludeSubPaths: true,
            ),
          ),
        ).result;
        safePrint('Listed items: ${result.items}');
        nextToken = result.nextToken;
        hasNextPage = result.hasNextPage;
      } while (hasNextPage);
    } on StorageException catch (e) {
      safePrint('Error listing files: ${e.message}');
      rethrow;
    }
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
        ],
      ),
    );
  }
}
