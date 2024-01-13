import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:flutter/material.dart';

class Tasks extends StatefulWidget {
  @override
  _TasksState createState() => _TasksState();
}

class _TasksState extends State<Tasks> {
  List<String> imageKeys = [];
  List<StorageItem> list = [];
  var imageUrl = '';
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
      var _logger;
      _logger.error('Get URL error - ${e.message}');
      rethrow;
    }
  }

  Future<void> _fetchImagesFromS3() async {
    try {
      //  result = Amplify.Storage.list();
      final result = await Amplify.Storage.list(
        options: const StorageListOptions(
          accessLevel: StorageAccessLevel.guest,
          pluginOptions: S3ListPluginOptions.listAll(),
        ),
      ).result;
      // print("Result size: ${result.items.length}");
      setState(() {
        list = result.items;
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
        // imageUrl=getUrl(key: i, accessLevel: StorageAccessLevel.guest).toString();
        // print("AAAAA:"+imageUrl);
        // urls.add(imageUrl);
        final imageUrl =
            await getUrl(key: i, accessLevel: StorageAccessLevel.guest);
        print("URL: $imageUrl"); // For debugging
        setState(() {
          urls.add(imageUrl);
        });
      }
    } catch (e) {
      print("Error fetching images: $e");
    }
  }

  void _showImageDetailsDialog(String imageUrl, String imageName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(16.0),
                ),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  imageName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
              ),
            ],
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
          itemCount: urls.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                _showImageDetailsDialog(
                    urls[index], 'Image Title'); // Pass the actual image name
              },
              child: Card(
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(16.0),
                        ),
                        child: Image.network(
                          urls[index],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Image Title', // Add a title or additional information
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
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
