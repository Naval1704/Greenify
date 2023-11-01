import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:flutter/material.dart';
import 'package:greenify/aws/uploadimage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CropDoctor extends StatefulWidget {
  @override
  _CropDoctorState createState() => _CropDoctorState();
}

class _CropDoctorState extends State<CropDoctor> {
  List<File> pastImages = []; // List to store past images
  final String imagesKey = 'pastImages';

  Future<void> openCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    if (pickedFile != null) {
      // Do something with the captured image (e.g., display it).
    }
  }

  Future<void> openGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      // Do something with the selected image (e.g., display it).
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set the background to white
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(height: 40),
          Align(
            alignment: const AlignmentDirectional(0.00, 0.00),
            child: Container(
              width: double.infinity,
              height: 120,
              decoration: const BoxDecoration(
                color: Color(0xFFDFFFB7), // Set the background to white
              ),
              child: Align(
                alignment: const AlignmentDirectional(1.00, 1.00),
                child: Stack(
                  children: [
                    const Align(
                      alignment: AlignmentDirectional(-0.55, -0.60),
                      child: Text(
                        'Click pictures and get solutions for your crop.',
                        style: TextStyle(
                          fontFamily: 'Aclonica',
                          fontSize: 13,
                        ),
                      ),
                    ),
                    Align(
                      alignment: const AlignmentDirectional(-0.85, 0.40),
                      child: ElevatedButton(
                        onPressed: () async {
                          await uploadImage();
                          await listAlbum(); // Call the uploadImage method
                        }, // Call openCamera when pressed
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xFF14FF00),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.camera,
                                color: Colors.black), // Add a camera icon
                            SizedBox(width: 8),
                            Text('Take a Picture',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                    const Align(
                      alignment: AlignmentDirectional(0.85, 0.40),
                      child: Icon(Icons.agriculture_rounded,
                          size: 60,
                          color: Colors.green), // Add a Crop Doctor icon
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: AlignmentDirectional(0.00, 0.00),
            child: Padding(
              padding: EdgeInsets.only(top: 100),
              child: Container(
                width: double.infinity,
                height: 160,
                decoration: const BoxDecoration(
                  color: Color(0xFFF2F2F2),
                ),
                child: const Stack(
                  children: [
                    Positioned(
                      top: 12, // Adjust the top position as needed
                      left: -270,
                      right: 0,
                      child: Text(
                        'My Queries',
                        style: TextStyle(
                          fontFamily: 'Sans',
                          fontWeight: FontWeight.bold,
                          fontSize: 16, // Adjust the font size as needed
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional(0.00, 0.00),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'No crop problem yet',
                            style: TextStyle(
                              fontFamily: 'Sans',
                              fontWeight: FontWeight.w600,
                              fontSize: 15, // Adjust the font size as needed
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                              height:
                                  8), // Add some space between the two text elements
                          Text(
                            'Use "Take a Picture" Button to raise a new problem',
                            style: TextStyle(
                              fontFamily: 'Sans',
                              fontWeight:
                                  FontWeight.w400, // Lighter font weight
                              fontSize: 15, // Adjust the font size as needed
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: AlignmentDirectional(0.00, 1.00),
            child: Padding(
              padding: EdgeInsets.only(top: 100),
              child: ElevatedButton(
                onPressed: () {
                  // UploadImage();
                }, // Call openGallery when pressed
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF14FF00),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.image_search_sharp,
                        color: Colors.black), // Add a camera icon
                    SizedBox(width: 8),
                    Text('Select From Gallery',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
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
          accessLevel: StorageAccessLevel.private,
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
