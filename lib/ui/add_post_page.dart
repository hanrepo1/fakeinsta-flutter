import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:insta_flutter/ui/add_post_next_page.dart';

class AddPostPage extends StatefulWidget {
  const AddPostPage({super.key});

  @override
  State<AddPostPage> createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  File? _selectedImage;
  List<File> _galleryImages = [];

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _cropImage(File(pickedFile.path));
    }
  }

  Future<void> _cropImage(File image) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: image.path,
      aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.blue,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: true,
        ),
        IOSUiSettings(
          minimumAspectRatio: 1.0,
        ),
      ],
    );

    if (croppedFile != null) {
      setState(() {
        _selectedImage = File(croppedFile.path);
      });
    } else {
      log("Cropping failed or was canceled.");
    }
  }

  void _navigateToNextPage() {
    if (_selectedImage != null) {
      log(_selectedImage!.uri.toFilePath());
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddPostNextPage(image: _selectedImage!),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Text('New Post', style: TextStyle(fontSize: 20)),
                    TextButton(
                      onPressed: _navigateToNextPage,
                      child: Text('Next'),
                    ),
                  ],
                ),
                Expanded(
                  child: _selectedImage != null
                      ? Image.file(_selectedImage!)
                      : Center(child: Text('No image selected')),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1,
              ),
              itemCount: _galleryImages.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    _cropImage(_galleryImages[index]);
                  },
                  child: Image.file(
                    _galleryImages[index],
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: _pickImage,
            child: Text('Pick Image from Gallery'),
          ),
        ],
      ),
    );
  }
}