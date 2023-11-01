import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';

class Upload {
  static Future<void> uploadExampleData() async {
    const dataString = 'Example file contents';

    try {
      final result = await Amplify.Storage.uploadData(
        data: S3DataPayload.string(dataString),
        key: 'ExampleKey',
        onProgress: (progress) {
          safePrint('Transferred bytes: ${progress.transferredBytes}');
        },
      ).result;

      safePrint('Uploaded data to location: ${result.uploadedItem.key}');
    } on StorageException catch (e) {
      safePrint(e.message);
    }
  }
}
