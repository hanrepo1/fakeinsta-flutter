import 'package:flutter/material.dart';

class ReelsPage extends StatelessWidget {
  const ReelsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.construction,
              size: 100.0,
              color: Colors.grey,
            ),
            const SizedBox(height: 20),
            const Text(
              'Reels page is under maintenance',
              style: TextStyle(
                fontSize: 24, 
                fontWeight: FontWeight.bold, 
                color: Colors.black, 
              ),
              textAlign: TextAlign.center, 
            ),
            const SizedBox(height: 10),
            const Text(
              'Please check back later.',
              style: TextStyle(
                fontSize: 16, 
                color: Colors.black54, 
              ),
              textAlign: TextAlign.center, 
            ),
          ],
        ),
      ),
    );
  }
}