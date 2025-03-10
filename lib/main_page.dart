import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ui/footer_tab.dart';
import 'ui/home_page.dart';
import 'ui/search_page.dart';
import 'ui/add_post_page.dart';
import 'ui/reels_page.dart';
import 'ui/profile_page.dart';
import 'viewmodel/post_view_model.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    const SearchPage(),
    AddPostPage(), 
    const ReelsPage(), 
    ProfilePage(), 
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], 
      bottomNavigationBar: FooterTab(
        selectedIndex: _selectedIndex,
        onTabSelected: _onItemTapped,
      ),
    );
  }
}