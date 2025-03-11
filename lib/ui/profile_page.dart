import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:insta_flutter/main_page.dart';
import 'package:insta_flutter/ui/login_page.dart';

import '../constants/shared_pref.dart';
import '../model/user_model.dart';
import '../services/http_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilPageProfilePageState();
}

class _ProfilPageProfilePageState extends State<ProfilePage> {
  late bool isLogin, isLoading;
  User? user;

  @override
  void initState() {
    super.initState();
    setState(() {
      isLogin = false;
      _loadUserPref();
      isLoading = true;
    });
  }

  Future<void> _loadUserPref() async {
    String? existUser = await SharedPref.getUserPref();
    String? token = await SharedPref.getAccessToken();
    if (token != null) {
      log("tokenExist : $token");
      HTTPService().setup(bearerToken: token);
    }
    if (existUser != null && existUser.isNotEmpty) {
      setState(() {
        user = User.fromJson(jsonDecode(existUser));
        log("_loadUserPref : ${user!.username}");
        isLogin = true;
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    log(isLogin.toString());
    if(!isLogin) {
      return const LoginPage();
    } else {
      return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Center(
            child: Text(
              user!.username,
              style: TextStyle(color: Colors.black),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                icon: Icon(Icons.logout, color: Colors.black),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Confirm Logout"),
                      content: const Text("Are you sure you want to logout?"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () {
                            SharedPref.removeAccessToken();
                            SharedPref.removeUserPref();
                            Navigator.of(context).pop();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => MainPage()),
                            );
                          },
                          child: const Text("Logout"),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(
                          'https://storage.googleapis.com/a1aa/image/hV5vOMjSUfsqv17ly4WscIYbSc3-PpQzVYE0OW_FkZo.jpg'),
                    ),
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "@"+user!.username,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text(
                          '20',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text('Posts'),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          '806',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text('Followers'),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          '826',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text('Following'),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        child: Text('Edit Profile'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.grey[200],
                          backgroundColor: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        child: Icon(Icons.share),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.grey[200],
                          backgroundColor: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(5, (index) {
                    return CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(
                          'https://storage.googleapis.com/a1aa/image/le8aBLT8LtOBGiwJUTojbpay1DWkL7yrexb85bbhCx4.jpg'),
                    );
                  }),
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(Icons.grid_on, color: Colors.black),
                    Icon(Icons.video_call, color: Colors.grey),
                    Icon(Icons.person, color: Colors.grey),
                  ],
                ),
              ),
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 1,
                  mainAxisSpacing: 1,
                ),
                itemCount: 9,
                itemBuilder: (context, index) {
                  return Image.network(
                    'https://storage.googleapis.com/a1aa/image/7z6MneNvwyedTjm39gu_FlxVb8ouqLj9QWrjSjnvKkE.jpg',
                    fit: BoxFit.cover,
                  );
                },
              ),
            ],
          ),
        ),
      );
    }
  }
}