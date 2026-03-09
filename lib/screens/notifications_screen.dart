import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.notifications_off_outlined, size: 80, color: Colors.grey),
            const SizedBox(height: 24),
            const Text('No new notifications', 
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 8),
            Text('We\'ll let you know when there\'s new\nartists, playlists or events for you.', 
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey[400])),
          ],
        ),
      ),
    );
  }
}
