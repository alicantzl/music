import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import '../providers/settings_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  late Box settingsBox;
  bool _dataSaver = false;
  bool _gapless = true;
  String _cacheSizeStr = 'Calculating...';

  @override
  void initState() {
    super.initState();
    settingsBox = Hive.box('settings');
    _dataSaver = settingsBox.get('dataSaver', defaultValue: false);
    _gapless = settingsBox.get('gapless', defaultValue: true);
    _calcCache();
  }

  Future<void> _calcCache() async {
    try {
      final tempDir = await getTemporaryDirectory();
      int totalSize = 0;
      if (tempDir.existsSync()) {
        tempDir.listSync(recursive: true, followLinks: false).forEach((entity) {
          if (entity is File) {
            totalSize += entity.lengthSync();
          }
        });
      }
      if (mounted) {
        setState(() {
          if (totalSize < 1024) {
             _cacheSizeStr = '$totalSize B';
          } else if (totalSize < 1024 * 1024) {
             _cacheSizeStr = '${(totalSize / 1024).toStringAsFixed(1)} KB';
          } else if (totalSize < 1024 * 1024 * 1024) {
             _cacheSizeStr = '${(totalSize / (1024 * 1024)).toStringAsFixed(1)} MB';
          } else {
             _cacheSizeStr = '${(totalSize / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
          }
        });
      }
    } catch (_) {
      if (mounted) {
         setState(() => _cacheSizeStr = 'Unknown');
      }
    }
  }

  Future<void> _clearCache() async {
    try {
      final tempDir = await getTemporaryDirectory();
      if (tempDir.existsSync()) {
        tempDir.listSync(recursive: true, followLinks: false).forEach((entity) {
          if (entity is File) {
             entity.deleteSync();
          }
        });
      }
      await _calcCache();
      if (mounted) {
         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cache cleared!')));
      }
    } catch (e) {
      if (mounted) {
         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to clear cache.')));
      }
    }
  }

  void _toggleDataSaver(bool val) {
    setState(() => _dataSaver = val);
    settingsBox.put('dataSaver', val);
  }

  void _toggleGapless(bool val) {
    setState(() => _gapless = val);
    settingsBox.put('gapless', val);
  }

  void _changeLanguage() {
    final currentLang = settingsBox.get('language', defaultValue: 'English');
    final nextLang = currentLang == 'English' ? 'Türkçe' : 'English';
    ref.read(localeProvider.notifier).setLanguage(nextLang);
  }

  void _changeRegion() {
    final currentRegion = ref.read(regionProvider);
    final nextRegion = currentRegion == 'US' ? 'TR' : 'US';
    ref.read(regionProvider.notifier).setRegion(nextRegion);
  }

  @override
  Widget build(BuildContext context) {
    final t = ref.watch(localeProvider);
    final region = ref.watch(regionProvider);
    final currentLang = settingsBox.get('language', defaultValue: 'English');
    final regionLabel = region == 'TR' ? 'Türkiye' : 'USA / International';
    final langLabel = t == LocalizedStrings.tr ? 'Dil' : 'Language';
    final regionTitle = t == LocalizedStrings.tr ? 'Bölge' : 'Region';

    return Scaffold(
      appBar: AppBar(
        title: Text(t.settings, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        physics: const BouncingScrollPhysics(),
        children: [
          ListTile(
            leading: const Icon(Icons.account_circle, size: 48, color: Color(0xFF1DB954)),
            title: Text(t == LocalizedStrings.tr ? 'Profil' : 'Profile', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            subtitle: Text(t == LocalizedStrings.tr ? 'Hesabınızı yönetin' : 'Manage your account'),
          ),
          const Divider(height: 32, color: Colors.white24),
          
          SwitchListTile(
            secondary: const Icon(Icons.data_saver_on, color: Colors.white),
            title: Text(t.dataSaver, style: const TextStyle(fontWeight: FontWeight.w500)),
            subtitle: Text(
              t == LocalizedStrings.tr ? 'Düşük ses kalitesi ile akış' : 'Set audio quality to low',
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            value: _dataSaver,
            activeColor: const Color(0xFF1DB954),
            onChanged: _toggleDataSaver,
          ),
          
          ListTile(
            leading: const Icon(Icons.language, color: Colors.white),
            title: Text(t.language, style: const TextStyle(fontWeight: FontWeight.w500)),
            subtitle: Text('$langLabel: $currentLang', style: const TextStyle(color: Colors.grey, fontSize: 12)),
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: _changeLanguage,
          ),

          ListTile(
            leading: const Icon(Icons.public, color: Colors.white),
            title: Text(t.region, style: const TextStyle(fontWeight: FontWeight.w500)),
            subtitle: Text('$regionTitle: $regionLabel', style: const TextStyle(color: Colors.grey, fontSize: 12)),
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: _changeRegion,
          ),

          SwitchListTile(
            secondary: const Icon(Icons.volume_up, color: Colors.white),
            title: Text(t.gaplessPlayback, style: const TextStyle(fontWeight: FontWeight.w500)),
            subtitle: Text(
              t == LocalizedStrings.tr ? 'Kesintisiz geçişler' : 'Seamless transitions',
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            value: _gapless,
            activeColor: const Color(0xFF1DB954),
            onChanged: _toggleGapless,
          ),

          ListTile(
            leading: const Icon(Icons.info_outline, color: Colors.white),
            title: Text(t.about, style: const TextStyle(fontWeight: FontWeight.w500)),
            subtitle: const Text('Version 1.0.0', style: TextStyle(color: Colors.grey, fontSize: 12)),
          ),

          const Divider(height: 32, color: Colors.white24),

          ListTile(
            leading: const Icon(Icons.delete_sweep, color: Colors.white),
            title: Text(t.clearCache, style: const TextStyle(fontWeight: FontWeight.w500)),
            subtitle: Text('$_cacheSizeStr', style: const TextStyle(color: Colors.grey, fontSize: 12)),
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: _clearCache,
          ),

          const SizedBox(height: 32),
          Center(
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[900],
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              ),
              child: Text(t.logOut, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
    );
  }
}
