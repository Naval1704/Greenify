import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class FarmerFormPage extends StatefulWidget {
  const FarmerFormPage({Key? key}) : super(key: key);

  @override
  _FarmerFormPageState createState() => _FarmerFormPageState();
}

class _FarmerFormPageState extends State<FarmerFormPage> {
  TextEditingController _landSizeController = TextEditingController();
  TextEditingController _cropsController = TextEditingController();
  TextEditingController _areaController = TextEditingController();
  File? _selectedImage; // Store the selected image file

  // Function to pick an image from the device
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _submitForm() {
    // Implement your form submission logic here
    // For now, let's just print the input values
    print('Land Size: ${_landSizeController.text}');
    print('Crops: ${_cropsController.text}');
    print('Area: ${_areaController.text}');
    print('Crop Images');
    if (_selectedImage != null) {
      print('Image Path: ${_selectedImage!.path}');
    } else {
      print('No image selected.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Farmer Form Page'),
        backgroundColor: const Color(0xFF1EFF34),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _landSizeController,
              decoration: InputDecoration(
                labelText: 'Land Size',
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _cropsController,
              decoration: InputDecoration(
                labelText: 'Crops',
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _areaController,
              decoration: InputDecoration(
                labelText: 'Area',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Pick Image'),
            ),
            SizedBox(height: 20),
            if (_selectedImage != null)
              Image.file(
                _selectedImage!,
                height: 100,
                width: 100,
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitForm,
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: FarmerFormPage(),
  ));
}
