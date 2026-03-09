import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        physics: const BouncingScrollPhysics(),
        children: [
          const ListTile(
            leading: Icon(Icons.account_circle, size: 48, color: Color(0xFF1DB954)),
            title: Text('Profile', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            subtitle: Text('Manage your account'),
          ),
          const Divider(height: 32, color: Colors.white24),
          _buildSettingsTile(Icons.data_saver_on, 'Data Saver', 'Set audio quality'),
          _buildSettingsTile(Icons.language, 'Languages', 'App language: English'),
          _buildSettingsTile(Icons.volume_up, 'Playback', 'Crossfade, Gapless playback'),
          _buildSettingsTile(Icons.info_outline, 'About', 'Version 1.0.0'),
          const SizedBox(height: 32),
          Center(
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[900],
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              ),
              child: const Text('Log Out', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSettingsTile(IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: () {},
    );
  }
}
