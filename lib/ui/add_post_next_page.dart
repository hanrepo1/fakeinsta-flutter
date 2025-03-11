import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/shared_pref.dart';
import '../main_page.dart';
import '../model/user_model.dart';
import '../viewmodel/post_view_model.dart';

class AddPostNextPage extends StatefulWidget {
  final File image;

  const AddPostNextPage({Key? key, required this.image}) : super(key: key);

  @override
  State<AddPostNextPage> createState() => _AddPostNextPageState();
}

class _AddPostNextPageState extends State<AddPostNextPage> {
  final captionController = TextEditingController();
  bool tile1 = false;
  bool tile2 = false;
  bool tile3 = false;

  late User user;

  @override
  void initState() {
    super.initState();
    setState(() {
      _loadUserPref();
    });
  }

  Future<void> _loadUserPref() async {
    String? existUser = await SharedPref.getUserPref();
    if (existUser != null && existUser.isNotEmpty) {
      user = User.fromJson(jsonDecode(existUser));
    }
  }

  @override
  Widget build(BuildContext context) {
    final postViewModel = Provider.of<PostViewModel>(context);
    
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.arrow_back, color: Colors.black),
        title: const Center(child: Text('New Post', style: TextStyle(color: Colors.black))),
        backgroundColor: Colors.white,
        actions: [
          TextButton(
            child: const Text('Share', style: TextStyle(color: Colors.blue)),
            onPressed: () async {
              if (captionController.text.isNotEmpty) {
                bool success = await postViewModel.createPost(user.id, "", captionController.text, 0, 0, widget.image);
                if (success) {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => MainPage()),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(postViewModel.errorMessage!),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.file(
                    widget.image,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: captionController,
                      maxLines: 3,
                      maxLength: 255,
                      decoration: const InputDecoration(
                        hintText: 'Enter caption here',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
              Divider(),
              ListTile(
                title: Text('Tag People'),
                trailing: Icon(Icons.chevron_right),
                onTap: () {},
              ),
              Divider(),
              SwitchListTile(
                title: Text('Facebook'),
                value: tile1,
                onChanged: (bool value) {
                  setState(() {
                    tile1 = value;
                  });
                },
              ),
              Divider(),
              SwitchListTile(
                title: Text('Twitter'),
                value: tile2,
                onChanged: (bool value) {
                  setState(() {
                    tile2 = value;
                  });
                },
              ),
              Divider(),
              SwitchListTile(
                title: Text('Tumblr'),
                value: tile3,
                onChanged: (bool value) {
                  setState(() {
                    tile3 = value;
                  });
                },
              ),
              Divider(),
              ListTile(
                title: Text('Advanced Settings', style: TextStyle(color: Colors.grey)),
                trailing: Icon(Icons.chevron_right, color: Colors.grey),
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}