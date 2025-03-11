import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:insta_flutter/viewmodel/auth_view_model.dart';
import 'package:insta_flutter/viewmodel/user_view_model.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'main_page.dart';
import 'viewmodel/post_view_model.dart';
import 'viewmodel/story_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _checkPermissions();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthViewModel()),
        ChangeNotifierProvider(create: (context) => UserViewModel()),
        ChangeNotifierProvider(create: (context) => PostViewModel()),
        ChangeNotifierProvider(create: (context) => StoryViewModel()),
      ],
      child: MainApp(),
    ),
  );
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> _checkPermissions() async {
  var photoStatus = await Permission.photos.status;
  var videoStatus = await Permission.videos.status;

  if (!photoStatus.isGranted) {
    photoStatus = await Permission.photos.request();
  }
  if (!videoStatus.isGranted) {
    videoStatus = await Permission.videos.request();
  }

  if (photoStatus.isGranted && videoStatus.isGranted) {
    log("Photo and Video permissions granted");
  } else {
    _showPermissionDeniedDialog();
  }
}

void _showPermissionDeniedDialog() {
  showDialog(
    context: navigatorKey.currentContext!,
    builder: (context) {
      return AlertDialog(
        title: Text("Permissions Required"),
        content: Text("This app requires access to your photos and videos to function properly. Please grant the permissions in the app settings."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              openAppSettings();
            },
            child: Text("Open Settings"),
          ),
          TextButton(
            onPressed: () {
              SystemNavigator.pop();
            },
            child: Text("Close App"),
          ),
        ],
      );
    },
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    
    return SafeArea(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Instagram UI',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MainPage(),
      ),
    );
  }
}
