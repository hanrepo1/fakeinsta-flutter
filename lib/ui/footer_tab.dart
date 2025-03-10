import 'package:flutter/material.dart';

class FooterTab extends StatelessWidget {
  final int selectedIndex; 
  final Function(int) onTabSelected;

  const FooterTab(
    {super.key, 
    required this.selectedIndex, 
    required this.onTabSelected
  }); 

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_circle),
          label: 'Add',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.video_collection),
          label: 'Reels',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
      currentIndex: selectedIndex,
      selectedItemColor: Colors.black, 
      unselectedItemColor: Colors.black54, 
      onTap: onTabSelected, 
      type: BottomNavigationBarType.fixed,
    );
  }
}