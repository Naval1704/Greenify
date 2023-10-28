import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class CropDoctor extends StatefulWidget {
  @override
  _CropDoctorState createState() => _CropDoctorState();
}

class _CropDoctorState extends State<CropDoctor> {
  List<File> pastImages = []; // List to store past images
  final String imagesKey = 'pastImages';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set the background to white
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Align(
            alignment: AlignmentDirectional(0.00, -0.50),
            child: Container(
              width: double.infinity,
              height: 116,
              decoration: BoxDecoration(
                color: Colors.white, // Set the background to white
              ),
              child: Align(
                alignment: AlignmentDirectional(1.00, 1.00),
                child: Stack(
                  children: [
                    Align(
                      alignment: AlignmentDirectional(-1.00, 0.00),
                      child: Text(
                        'Click pictures and get solutions for your crop.',
                        style: TextStyle(
                          fontFamily: 'Aclonica',
                          fontSize: 11,
                        ),
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional(-0.81, 0.83),
                      child: ElevatedButton(
                        onPressed: () {
                          print('Button pressed ...');
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xFF6CFF69), // Set button color to #6CFF69
                        ),
                        child: Text('Take a Picture'),
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
              child: Container(
                width: double.infinity,
                height: 159,
                decoration: BoxDecoration(
                  color: Color(0xFF9B9EA4),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Align(
                  alignment: AlignmentDirectional(0.00, 0.00),
                  child: Stack(
                    children: [
                      Align(
                        alignment: AlignmentDirectional(-0.80, -1.00),
                        child: Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text(
                            'My Queries',
                            style: TextStyle(
                              fontFamily: 'Aclonica',
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional(0.00, 0.00),
                        child: Text(
                          'Use "Take A Picture" button to raise a new problem',
                        ),
                      ),
                    ],
                  ),
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
                  print('Button pressed ...');
                },
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF6CFF69), // Set button color to #6CFF69
                ),
                child: Text('Select from Gallery'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
