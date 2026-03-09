import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late Box settingsBox;
  bool _dataSaver = false;
  bool _gapless = true;
  String _language = 'English';

  @override
  void initState() {
    super.initState();
    settingsBox = Hive.box('settings');
    _dataSaver = settingsBox.get('dataSaver', defaultValue: false);
    _gapless = settingsBox.get('gapless', defaultValue: true);
    _language = settingsBox.get('language', defaultValue: 'English');
  }

  void _toggleDataSaver(bool val) {
    setState(() => _dataSaver = val);
    settingsBox.put('dataSaver', val);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(val ? 'Data Saver Enabled' : 'Data Saver Disabled')),
    );
  }

  void _toggleGapless(bool val) {
    setState(() => _gapless = val);
    settingsBox.put('gapless', val);
  }

  void _changeLanguage() {
    final langs = ['English', 'Türkçe', 'Español'];
    final nextIndex = (langs.indexOf(_language) + 1) % langs.length;
    final nextLang = langs[nextIndex];
    setState(() => _language = nextLang);
    settingsBox.put('language', nextLang);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Language applied: $nextLang')),
    );
  }

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
          
          SwitchListTile(
            secondary: const Icon(Icons.data_saver_on, color: Colors.white),
            title: const Text('Data Saver', style: TextStyle(fontWeight: FontWeight.w500)),
            subtitle: const Text('Set audio quality to low for streaming', style: TextStyle(color: Colors.grey, fontSize: 12)),
            value: _dataSaver,
            activeColor: const Color(0xFF1DB954),
            onChanged: _toggleDataSaver,
          ),
          
          ListTile(
            leading: const Icon(Icons.language, color: Colors.white),
            title: const Text('Languages', style: TextStyle(fontWeight: FontWeight.w500)),
            subtitle: Text('App language: $_language', style: const TextStyle(color: Colors.grey, fontSize: 12)),
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: _changeLanguage,
          ),

          SwitchListTile(
            secondary: const Icon(Icons.volume_up, color: Colors.white),
            title: const Text('Gapless Playback', style: TextStyle(fontWeight: FontWeight.w500)),
            subtitle: const Text('Enable seamless transitions', style: TextStyle(color: Colors.grey, fontSize: 12)),
            value: _gapless,
            activeColor: const Color(0xFF1DB954),
            onChanged: _toggleGapless,
          ),

          const ListTile(
            leading: Icon(Icons.info_outline, color: Colors.white),
            title: Text('About', style: TextStyle(fontWeight: FontWeight.w500)),
            subtitle: Text('Version 1.0.0', style: TextStyle(color: Colors.grey, fontSize: 12)),
          ),

          const SizedBox(height: 32),
          Center(
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Logging out of your account...')),
                );
              },
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
}
