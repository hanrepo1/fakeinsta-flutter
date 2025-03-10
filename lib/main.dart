import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:insta_flutter/viewmodel/combined_view_model.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'main_page.dart';
import 'viewmodel/post_view_model.dart';
import 'viewmodel/story_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _checkPermissions();
  // runApp(
  //   MultiProvider(
  //     providers: [
  //       ChangeNotifierProvider(create: (context) => PostViewModel()..fetchPosts()),
  //       ChangeNotifierProvider(create: (context) => StoryViewModel()..fetchStory()),
  //     ],
  //     child: MainApp(),
  //   ),
  // );
  runApp(MainApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> _checkPermissions() async {
  // Check current permission status
  var photoStatus = await Permission.photos.status;
  var videoStatus = await Permission.videos.status;

  // Request permissions if not granted
  if (!photoStatus.isGranted) {
    photoStatus = await Permission.photos.request();
  }
  if (!videoStatus.isGranted) {
    videoStatus = await Permission.videos.request();
  }

  // Check if permissions are granted
  if (photoStatus.isGranted && videoStatus.isGranted) {
    print("Photo and Video permissions granted");
  } else {
    // Show a dialog to inform the user why permissions are needed
    _showPermissionDeniedDialog();
  }
}

void _showPermissionDeniedDialog() {
  // Show a dialog to inform the user
  showDialog(
    context: navigatorKey.currentContext!,
    builder: (context) {
      return AlertDialog(
        title: Text("Permissions Required"),
        content: Text("This app requires access to your photos and videos to function properly. Please grant the permissions in the app settings."),
        actions: [
          TextButton(
            onPressed: () {
              // Close the dialog
              Navigator.of(context).pop();
              // Optionally, you can navigate to app settings
              openAppSettings();
            },
            child: Text("Open Settings"),
          ),
          TextButton(
            onPressed: () {
              // Close the app if the user chooses not to grant permissions
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
    
    return ChangeNotifierProvider(
      create: (context) => CombinedViewModel(),
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
