import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class S3Handler extends StatefulWidget {
  const S3Handler({super.key});

  @override
  State<S3Handler> createState() => _S3Handler();
}

class _S3Handler extends State<S3Handler> {

  @override
  void initState() {
    super.initState();
    // _checkAuthStatus();
    _listAllPublicFiles();
  }
  get _logger => null;
  List<StorageItem> list = [];
  var imageUrl = '';

  ///
  /// Upload a given file from Local storage to AWS S3. The File can have any of
  /// Guest/Private/Protected access levels.
  ///
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
    final filepath = '${documentsDir.path}/$key';
    try {
      await Amplify.Storage.downloadFile(
        key: key,
        localFile: AWSFile.fromPath(filepath),
        onProgress: (p0) => _logger
            .debug('Progress: ${(p0.transferredBytes / p0.totalBytes) * 100}%'),
      ).result;
      await _listAllPublicFiles();
    } on StorageException catch (e) {
      _logger.error('Download error - ${e.message}');
    }
  }

  // download file on web
  Future<void> downloadFileWeb(String key) async {
    try {
      await Amplify.Storage.downloadFile(
        key: key,
        localFile: AWSFile.fromPath(key),
        onProgress: (p0) => _logger
            .debug('Progress: ${(p0.transferredBytes / p0.totalBytes) * 100}%'),
      ).result;
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

  // ignore: annotate_overrides
  
  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
