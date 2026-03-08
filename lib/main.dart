import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:audio_service/audio_service.dart';

import 'models/song_model.dart';
import 'models/playlist_model.dart';
import 'services/audio_handler.dart';
import 'providers/audio_handler_provider.dart';
import 'navigation/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Platform.isAndroid ? const Color(0xFF0A0A0F) : null,
    ),
  );

  await Hive.initFlutter();
  Hive.registerAdapter(SongModelAdapter());
  Hive.registerAdapter(PlaylistModelAdapter());
  
  await Future.wait([
    Hive.openBox('liked_songs'),
    Hive.openBox('playlists'),
    Hive.openBox('downloads'),
    Hive.openBox('settings'),
  ]);

  late final PureAudioHandler handler;
  try {
    handler = await AudioService.init<PureAudioHandler>(
      builder: () => PureAudioHandler(),
      config: const AudioServiceConfig(
        androidNotificationChannelId: 'com.puremusic.audio',
        androidNotificationChannelName: 'PureMusic',
        androidNotificationOngoing: true,
        androidStopForegroundOnPause: true,
        notificationColor: Color(0xFF1DB954),
        preloadArtwork: true,
        artDownscaleWidth: 300,
        artDownscaleHeight: 300,
      ),
    );
  } catch (e) {
    handler = PureAudioHandler();
  }

  runApp(
    ProviderScope(
      overrides: [
        audioHandlerProvider.overrideWithValue(handler),
      ],
      child: const PureMusicApp(),
    ),
  );
}

class PureMusicApp extends StatelessWidget {
  const PureMusicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'PureMusic',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF000000),
        primaryColor: const Color(0xFF1DB954),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF1DB954),
          surface: Color(0xFF121212),
        ),
      ),
      routerConfig: AppRouter.router,
    );
  }
}
