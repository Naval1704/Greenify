import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:greenify/farmer/providers/s3handler.dart';
import 'package:greenify/farmer/widgets/app_drawer.dart';

class ListBucketScreen extends StatefulWidget {
  @override
  _ListBucketScreenState createState() => _ListBucketScreenState();
}

class _ListBucketScreenState extends State<ListBucketScreen> {
  final List<String> images = [];

  void _showDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('An Error Occurred!'),
          content: Text(message),
          actions: [
            TextButton(
              child: Text('Okay'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  Future<List<String>>? _getS3Objects() {
    try {
      return S3Handler.listItems();
    } on StorageException catch (e) {
      var message = e.message;
      _showDialog(message);
    } catch (error) {
      var message = "Unable to access S3 Bucket!";
      _showDialog(message);
    }
  }

  void _clearCachedFiles() async {
    final documentsDir = await getApplicationDocumentsDirectory();
    final files = Directory(documentsDir.path).listSync();

    files.forEach((element) {
      element.deleteSync();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
        content: Text('Local Images have been deleted'),
      ),
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var images = _getS3Objects();

    return Scaffold(
      appBar: AppBar(
        title: Text('Images in S3 Bucket'),
      ),
      drawer: AppDrawer(),
      body: ShowImages(images),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.delete),
        backgroundColor: Colors.red,
        onPressed: _clearCachedFiles,
      ),
    );
  }
}

class ShowImages extends StatelessWidget {
  const ShowImages(this.images);

  final Future<List<String>>? images;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: images,
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.data == null || snapshot.data!.isEmpty) {
          return Center(child: Text('No images available.'));
        } else {
          return ImageGrid(images: snapshot.data as List<String>);
        }
      },
    );
  }
}

class ImageGrid extends StatelessWidget {
  const ImageGrid({Key? key, required this.images}) : super(key: key);
  final List<String> images;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      itemBuilder: (ctx, i) {
        return SampleItem(images[i]);
      },
      itemCount: images.length,
      padding: const EdgeInsets.all(10),
    );
  }
}

class SampleItem extends StatefulWidget {
  final String imagePath;

  const SampleItem(this.imagePath);

  @override
  _SampleItemState createState() => _SampleItemState();
}

class _SampleItemState extends State<SampleItem> {
  bool? downloadInProgress;
  bool? _downloadSuccess;

  // Alert Dialog to show any error messages.
  void _showDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('An Error Occurred!'),
          content: Text(message),
          actions: [
            TextButton(
              child: Text('Okay'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  void downloadFile(String path) async {
    setState(() {
      downloadInProgress = true;
      _downloadSuccess = null;
    });

    try {
      await S3Handler.downloadFile(path);
      _downloadSuccess = true;
    } on StorageException catch (e) {
      var message = e.message;
      _downloadSuccess = false;
      _showDialog(message);
    } catch (error) {
      _downloadSuccess = false;
      var message = "Unable to download the Image!";
      _showDialog(message);
    }

    setState(() {
      downloadInProgress = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final imageAvailable = File(widget.imagePath).existsSync();

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: imageAvailable
          ? GridTile(
              child: Image.asset(
                widget.imagePath,
                fit: BoxFit.cover,
              ),
            )
          : GridTile(
              child: downloadInProgress == null
                  ? GestureDetector(
                      onTap: () {
                        downloadFile(widget.imagePath.split("/").last);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blueAccent),
                        ),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.image_outlined,
                              size: 100,
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            Text(widget.imagePath.split("/").last),
                          ],
                        ),
                      ),
                    )
                  : Center(
                      child: CircularProgressIndicator(),
                    ),
            ),
    );
  }
}
