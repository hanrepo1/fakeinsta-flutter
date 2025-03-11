import 'package:flutter/material.dart';
import 'constants/shared_pref.dart';
import 'ui/footer_tab.dart';
import 'ui/home_page.dart';
import 'ui/search_page.dart';
import 'ui/add_post_page.dart';
import 'ui/reels_page.dart';
import 'ui/profile_page.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with WidgetsBindingObserver {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    const SearchPage(),
    AddPostPage(), 
    const ReelsPage(), 
    ProfilePage(), 
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      SharedPref.removeAccessToken();
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _pages[_selectedIndex], 
        bottomNavigationBar: FooterTab(
          selectedIndex: _selectedIndex,
          onTabSelected: _onItemTapped,
        ),
      ),
    );
  }
}