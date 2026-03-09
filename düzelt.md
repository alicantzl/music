1. Ayarlar ve Dil "Yarım" Kalmışlığı
Yeni Analiz: 

settings_provider.dart
 ekledik ama uygulama içindeki Dialoglar (Örn: "Çalma Listesini Silmek İstiyor musunuz?") hala statik İngilizce veya Türkçe kalmış olabilir.
Eksik: "Otomatik Kapanma Zamanlayıcısı" (Sleep Timer) eklenmedi. Gece müzik dinleyen bir kullanıcı için bu en büyük eksik.




../../../hostedtoolcache/flutter/stable-3.41.4-arm64/packages/flutter/lib/src/widgets/text.dart:507:9: Context: Found this candidate, but the arguments don't match.
  const Text(
        ^^^^
lib/screens/settings_screen.dart:106:25: Error: The getter 'localeProvider' isn't defined for the type '_SettingsScreenState'.
 - '_SettingsScreenState' is from 'package:andoromusic/screens/settings_screen.dart' ('lib/screens/settings_screen.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'localeProvider'.
    final t = ref.watch(localeProvider);
                        ^^^^^^^^^^^^^^
lib/screens/settings_screen.dart:107:30: Error: The getter 'regionProvider' isn't defined for the type '_SettingsScreenState'.
 - '_SettingsScreenState' is from 'package:andoromusic/screens/settings_screen.dart' ('lib/screens/settings_screen.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'regionProvider'.
    final region = ref.watch(regionProvider);
                             ^^^^^^^^^^^^^^
lib/screens/settings_screen.dart:192:36: Error: The getter 'localeProvider' isn't defined for the type '_SettingsScreenState'.
 - '_SettingsScreenState' is from 'package:andoromusic/screens/settings_screen.dart' ('lib/screens/settings_screen.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'localeProvider'.
  String get _language => ref.read(localeProvider) == LocalizedStrings.tr ? 'Dil' : 'Language';
                                   ^^^^^^^^^^^^^^
lib/screens/settings_screen.dart:192:55: Error: The getter 'LocalizedStrings' isn't defined for the type '_SettingsScreenState'.
 - '_SettingsScreenState' is from 'package:andoromusic/screens/settings_screen.dart' ('lib/screens/settings_screen.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'LocalizedStrings'.
  String get _language => ref.read(localeProvider) == LocalizedStrings.tr ? 'Dil' : 'Language';
                                                      ^^^^^^^^^^^^^^^^
lib/screens/settings_screen.dart:193:34: Error: The getter 'localeProvider' isn't defined for the type '_SettingsScreenState'.
 - '_SettingsScreenState' is from 'package:andoromusic/screens/settings_screen.dart' ('lib/screens/settings_screen.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'localeProvider'.
  String get _region => ref.read(localeProvider) == LocalizedStrings.tr ? 'Bölge' : 'Region';
                                 ^^^^^^^^^^^^^^
lib/screens/settings_screen.dart:193:53: Error: The getter 'LocalizedStrings' isn't defined for the type '_SettingsScreenState'.
 - '_SettingsScreenState' is from 'package:andoromusic/screens/settings_screen.dart' ('lib/screens/settings_screen.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'LocalizedStrings'.
  String get _region => ref.read(localeProvider) == LocalizedStrings.tr ? 'Bölge' : 'Region';
                                                    ^^^^^^^^^^^^^^^^
Target kernel_snapshot_program failed: Exception
Failed to package /Users/runner/work/music/music.
Command PhaseScriptExecution failed with a nonzero exit code

note: Disabling previews because SWIFT_VERSION is set and SWIFT_OPTIMIZATION_LEVEL=-O, expected -Onone (in target 'Flutter' from project 'Pods')
warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/video_player_avfoundation/video_player_avfoundation_privacy.bundle' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/video_player_avfoundation/video_player_avfoundation_privacy.bundle/Info.plist' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/video_player_avfoundation/video_player_avfoundation_privacy.bundle/PrivacyInfo.xcprivacy' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/video_player_avfoundation/video_player_avfoundation.framework' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/video_player_avfoundation/video_player_avfoundation.framework.dSYM/Contents/Resources/DWARF/video_player_avfoundation' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/video_player_avfoundation/video_player_avfoundation.framework/Headers' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/video_player_avfoundation/video_player_avfoundation.framework/Headers/AVAssetTrackUtils.h' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/video_player_avfoundation/video_player_avfoundation.framework/Headers/FVPAVFactory.h' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/video_player_avfoundation/video_player_avfoundation.framework/Headers/FVPAssetProvider.h' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/video_player_avfoundation/video_player_avfoundation.framework/Headers/FVPDisplayLink.h' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/video_player_avfoundation/video_player_avfoundation.framework/Headers/FVPEventBridge.h' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/video_player_avfoundation/video_player_avfoundation.framework/Headers/FVPFrameUpdater.h' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/video_player_avfoundation/video_player_avfoundation.framework/Headers/FVPNativeVideoView.h' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/video_player_avfoundation/video_player_avfoundation.framework/Headers/FVPNativeVideoViewFactory.h' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/video_player_avfoundation/video_player_avfoundation.framework/Headers/FVPTextureBasedVideoPlayer.h' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/video_player_avfoundation/video_player_avfoundation.framework/Headers/FVPTextureBasedVideoPlayer_Test.h' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/video_player_avfoundation/video_player_avfoundation.framework/Headers/FVPVideoEventListener.h' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/video_player_avfoundation/video_player_avfoundation.framework/Headers/FVPVideoPlayer.h' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/video_player_avfoundation/video_player_avfoundation.framework/Headers/FVPVideoPlayerPlugin.h' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/video_player_avfoundation/video_player_avfoundation.framework/Headers/FVPVideoPlayerPlugin_Test.h' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/video_player_avfoundation/video_player_avfoundation.framework/Headers/FVPVideoPlayer_Internal.h' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/video_player_avfoundation/video_player_avfoundation.framework/Headers/FVPViewProvider.h' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/video_player_avfoundation/video_player_avfoundation.framework/Headers/messages.g.h' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/video_player_avfoundation/video_player_avfoundation.framework/Headers/video_player_avfoundation-umbrella.h' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/video_player_avfoundation/video_player_avfoundation.framework/Info.plist' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/video_player_avfoundation/video_player_avfoundation.framework/Modules/module.modulemap' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/video_player_avfoundation/video_player_avfoundation.framework/video_player_avfoundation' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/video_player_avfoundation/video_player_avfoundation.framework/video_player_avfoundation_privacy.bundle' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/url_launcher_ios/url_launcher_ios_privacy.bundle' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/url_launcher_ios/url_launcher_ios_privacy.bundle/Info.plist' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/url_launcher_ios/url_launcher_ios_privacy.bundle/PrivacyInfo.xcprivacy' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/url_launcher_ios/url_launcher_ios.framework' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/url_launcher_ios/url_launcher_ios.framework.dSYM/Contents/Resources/DWARF/url_launcher_ios' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/url_launcher_ios/url_launcher_ios.framework/Headers' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/url_launcher_ios/url_launcher_ios.framework/Headers/url_launcher_ios-Swift.h' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/url_launcher_ios/url_launcher_ios.framework/Headers/url_launcher_ios-umbrella.h' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/url_launcher_ios/url_launcher_ios.framework/Info.plist' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/url_launcher_ios/url_launcher_ios.framework/Modules/module.modulemap' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/url_launcher_ios/url_launcher_ios.framework/Modules/url_launcher_ios.swiftmodule/Project/arm64-apple-ios.swiftsourceinfo' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/url_launcher_ios/url_launcher_ios.framework/Modules/url_launcher_ios.swiftmodule/arm64-apple-ios.abi.json' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/url_launcher_ios/url_launcher_ios.framework/Modules/url_launcher_ios.swiftmodule/arm64-apple-ios.swiftdoc' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/url_launcher_ios/url_launcher_ios.framework/Modules/url_launcher_ios.swiftmodule/arm64-apple-ios.swiftmodule' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/url_launcher_ios/url_launcher_ios.framework/url_launcher_ios' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/url_launcher_ios/url_launcher_ios.framework/url_launcher_ios_privacy.bundle' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/sqflite_darwin/sqflite_darwin_privacy.bundle' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/sqflite_darwin/sqflite_darwin_privacy.bundle/Info.plist' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/sqflite_darwin/sqflite_darwin_privacy.bundle/PrivacyInfo.xcprivacy' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/sqflite_darwin/sqflite_darwin.framework' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/sqflite_darwin/sqflite_darwin.framework.dSYM/Contents/Resources/DWARF/sqflite_darwin' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/sqflite_darwin/sqflite_darwin.framework/Headers' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/sqflite_darwin/sqflite_darwin.framework/Headers/SqfliteImportPublic.h' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/sqflite_darwin/sqflite_darwin.framework/Headers/SqflitePluginPublic.h' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/sqflite_darwin/sqflite_darwin.framework/Headers/sqflite_darwin-umbrella.h' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/sqflite_darwin/sqflite_darwin.framework/Info.plist' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/sqflite_darwin/sqflite_darwin.framework/Modules/module.modulemap' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/sqflite_darwin/sqflite_darwin.framework/sqflite_darwin' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/sqflite_darwin/sqflite_darwin.framework/sqflite_darwin_privacy.bundle' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/share_plus/share_plus_privacy.bundle' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/share_plus/share_plus_privacy.bundle/Info.plist' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/share_plus/share_plus_privacy.bundle/PrivacyInfo.xcprivacy' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/share_plus/share_plus.framework' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/share_plus/share_plus.framework.dSYM/Contents/Resources/DWARF/share_plus' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/share_plus/share_plus.framework/Headers' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/share_plus/share_plus.framework/Headers/FPPSharePlusPlugin.h' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/share_plus/share_plus.framework/Headers/share_plus-umbrella.h' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/share_plus/share_plus.framework/Info.plist' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/share_plus/share_plus.framework/Modules/module.modulemap' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/share_plus/share_plus.framework/share_plus' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/share_plus/share_plus.framework/share_plus_privacy.bundle' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/permission_handler_apple/permission_handler_apple_privacy.bundle' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/permission_handler_apple/permission_handler_apple_privacy.bundle/Info.plist' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/permission_handler_apple/permission_handler_apple_privacy.bundle/PrivacyInfo.xcprivacy' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/permission_handler_apple/permission_handler_apple.framework' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/permission_handler_apple/permission_handler_apple.framework/Headers' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/permission_handler_apple/permission_handler_apple.framework/Headers/AppTrackingTransparencyPermissionStrategy.h' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/permission_handler_apple/permission_handler_apple.framework/Headers/AssistantPermissionStrategy.h' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/permission_handler_apple/permission_handler_apple.framework/Headers/AudioVideoPermissionStrategy.h' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/permission_handler_apple/permission_handler_apple.framework/Headers/BackgroundRefreshStrategy.h' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/permission_handler_apple/permission_handler_apple.framework/Headers/BluetoothPermissionStrategy.h' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/permission_handler_apple/permission_handler_apple.framework/Headers/Codec.h' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/permission_handler_apple/permission_handler_apple.framework/Headers/ContactPermissionStrategy.h' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/permission_handler_apple/permission_handler_apple.framework/Headers/CriticalAlertsPermissionStrategy.h' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/permission_handler_apple/permission_handler_apple.framework/Headers/EventPermissionStrategy.h' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/permission_handler_apple/permission_handler_apple.framework/Headers/LocationPermissionStrategy.h' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/permission_handler_apple/permission_handler_apple.framework/Headers/MediaLibraryPermissionStrategy.h' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/permission_handler_apple/permission_handler_apple.framework/Headers/NotificationPermissionStrategy.h' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/permission_handler_apple/permission_handler_apple.framework/Headers/PermissionHandlerEnums.h' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/permission_handler_apple/permission_handler_apple.framework/Headers/PermissionHandlerPlugin.h' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/permission_handler_apple/permission_handler_apple.framework/Headers/PermissionManager.h' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/permission_handler_apple/permission_handler_apple.framework/Headers/PermissionStrategy.h' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/permission_handler_apple/permission_handler_apple.framework/Headers/PhonePermissionStrategy.h' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/permission_handler_apple/permission_handler_apple.framework/Headers/PhotoPermissionStrategy.h' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/permission_handler_apple/permission_handler_apple.framework/Headers/SensorPermissionStrategy.h' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/permission_handler_apple/permission_handler_apple.framework/Headers/SpeechPermissionStrategy.h' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/permission_handler_apple/permission_handler_apple.framework/Headers/StoragePermissionStrategy.h' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/permission_handler_apple/permission_handler_apple.framework/Headers/UnknownPermissionStrategy.h' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/permission_handler_apple/permission_handler_apple.framework/Headers/permission_handler_apple-umbrella.h' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/permission_handler_apple/permission_handler_apple.framework/Info.plist' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/permission_handler_apple/permission_handler_apple.framework/Modules/module.modulemap' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/permission_handler_apple/permission_handler_apple.framework/permission_handler_apple' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/image_picker_ios/image_picker_ios_privacy.bundle' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/image_picker_ios/image_picker_ios_privacy.bundle/Info.plist' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/image_picker_ios/image_picker_ios_privacy.bundle/PrivacyInfo.xcprivacy' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/just_audio/just_audio.framework' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/just_audio/just_audio.framework.dSYM/Contents/Resources/DWARF/just_audio' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/just_audio/just_audio.framework/Headers' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/just_audio/just_audio.framework/Headers/AudioPlayer.h' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/just_audio/just_audio.framework/Headers/AudioSource.h' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/just_audio/just_audio.framework/Headers/BetterEventChannel.h' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/just_audio/just_audio.framework/Headers/ClippingAudioSource.h' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/just_audio/just_audio.framework/Headers/ConcatenatingAudioSource.h' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/just_audio/just_audio.framework/Headers/IndexedAudioSource.h' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/just_audio/just_audio.framework/Headers/IndexedPlayerItem.h' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/just_audio/just_audio.framework/Headers/JustAudioPlugin.h' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/just_audio/just_audio.framework/Headers/LoadControl.h' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/just_audio/just_audio.framework/Headers/LoopingAudioSource.h' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/just_audio/just_audio.framework/Headers/UriAudioSource.h' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/just_audio/just_audio.framework/Headers/just_audio-umbrella.h' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/image_picker_ios/image_picker_ios.framework' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/just_audio/just_audio.framework/Info.plist' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/image_picker_ios/image_picker_ios.framework.dSYM/Contents/Resources/DWARF/image_picker_ios' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/image_picker_ios/image_picker_ios.framework/Headers' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/image_picker_ios/image_picker_ios.framework/Headers/FIPViewProvider.h' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/just_audio/just_audio.framework/Modules/module.modulemap' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/image_picker_ios/image_picker_ios.framework/Headers/FLTImagePickerImageUtil.h' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/image_picker_ios/image_picker_ios.framework/Headers/FLTImagePickerMetaDataUtil.h' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/just_audio/just_audio.framework/just_audio' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/image_picker_ios/image_picker_ios.framework/Headers/FLTImagePickerPhotoAssetUtil.h' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/image_picker_ios/image_picker_ios.framework/Headers/FLTImagePickerPlugin.h' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/image_picker_ios/image_picker_ios.framework/Headers/FLTImagePickerPlugin_Test.h' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/image_picker_ios/image_picker_ios.framework/Headers/FLTPHPickerSaveImageToPathOperation.h' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/image_picker_ios/image_picker_ios.framework/Headers/image_picker_ios-umbrella.h' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/image_picker_ios/image_picker_ios.framework/Headers/messages.g.h' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/image_picker_ios/image_picker_ios.framework/Info.plist' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/image_picker_ios/image_picker_ios.framework/Modules/module.modulemap' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/image_picker_ios/image_picker_ios.framework/image_picker_ios' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/image_picker_ios/image_picker_ios.framework/image_picker_ios_privacy.bundle' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/connectivity_plus/connectivity_plus_privacy.bundle' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/connectivity_plus/connectivity_plus_privacy.bundle/Info.plist' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/connectivity_plus/connectivity_plus_privacy.bundle/PrivacyInfo.xcprivacy' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/audio_session/audio_session.framework' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/audio_session/audio_session.framework.dSYM/Contents/Resources/DWARF/audio_session' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/audio_session/audio_session.framework/Headers' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/audio_session/audio_session.framework/Headers/AudioSessionPlugin.h' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/audio_session/audio_session.framework/Headers/DarwinAudioSession.h' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/audio_session/audio_session.framework/Headers/audio_session-umbrella.h' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/audio_session/audio_session.framework/Info.plist' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/audio_session/audio_session.framework/Modules/module.modulemap' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/audio_session/audio_session.framework/audio_session' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/audio_service/audio_service.framework' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/audio_service/audio_service.framework.dSYM/Contents/Resources/DWARF/audio_service' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/audio_service/audio_service.framework/Headers' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/audio_service/audio_service.framework/Headers/AudioServicePlugin.h' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/audio_service/audio_service.framework/Headers/audio_service-umbrella.h' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/audio_service/audio_service.framework/Info.plist' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/audio_service/audio_service.framework/Modules/module.modulemap' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/audio_service/audio_service.framework/audio_service' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/connectivity_plus/connectivity_plus.framework' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/connectivity_plus/connectivity_plus.framework.dSYM/Contents/Resources/DWARF/connectivity_plus' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/connectivity_plus/connectivity_plus.framework/Headers' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/connectivity_plus/connectivity_plus.framework/Headers/connectivity_plus-Swift.h' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/connectivity_plus/connectivity_plus.framework/Headers/connectivity_plus-umbrella.h' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/connectivity_plus/connectivity_plus.framework/Info.plist' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/connectivity_plus/connectivity_plus.framework/Modules/connectivity_plus.swiftmodule/Project/arm64-apple-ios.swiftsourceinfo' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/connectivity_plus/connectivity_plus.framework/Modules/connectivity_plus.swiftmodule/arm64-apple-ios.abi.json' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/connectivity_plus/connectivity_plus.framework/Modules/connectivity_plus.swiftmodule/arm64-apple-ios.swiftdoc' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/connectivity_plus/connectivity_plus.framework/Modules/connectivity_plus.swiftmodule/arm64-apple-ios.swiftmodule' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/connectivity_plus/connectivity_plus.framework/Modules/module.modulemap' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/connectivity_plus/connectivity_plus.framework/connectivity_plus' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/connectivity_plus/connectivity_plus.framework/connectivity_plus_privacy.bundle' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/Runner.app' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/Runner.app.dSYM/Contents/Resources/DWARF/Runner' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/Runner.app/AppFrameworkInfo.plist' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/Runner.app/Assets.car' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/Runner.app/Base.lproj/LaunchScreen.storyboardc' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/Runner.app/Base.lproj/Main.storyboardc' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/Runner.app/Frameworks' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/Runner.app/Frameworks/audio_service.framework' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/Runner.app/Frameworks/audio_session.framework' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/Runner.app/Frameworks/connectivity_plus.framework' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/Runner.app/Frameworks/image_picker_ios.framework' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/Runner.app/Frameworks/just_audio.framework' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/Runner.app/Frameworks/share_plus.framework' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/Runner.app/Frameworks/sqflite_darwin.framework' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/Runner.app/Frameworks/url_launcher_ios.framework' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/Runner.app/Frameworks/video_player_avfoundation.framework' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/Runner.app/Info.plist' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/Runner.app/PkgInfo' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/Runner.app/Runner' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/Runner.app/permission_handler_apple_privacy.bundle' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/Runner.swiftmodule/Project/arm64-apple-ios.swiftsourceinfo' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/Runner.swiftmodule/arm64-apple-ios.abi.json' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/Runner.swiftmodule/arm64-apple-ios.swiftdoc' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/Runner.swiftmodule/arm64-apple-ios.swiftmodule' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/Pods_Runner.framework' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/Pods_Runner.framework/Headers' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/Pods_Runner.framework/Headers/Pods-Runner-umbrella.h' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/Pods_Runner.framework/Info.plist' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/Pods_Runner.framework/Modules/module.modulemap' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/Pods_Runner.framework/Pods_Runner' is located outside of the allowed root paths.

note: Disabling previews because SWIFT_VERSION is set and SWIFT_OPTIMIZATION_LEVEL=-O, expected -Onone (in target 'Runner' from project 'Runner')
note: Run script build phase 'Run Script' will be run during every build because the option to run the script phase "Based on dependency analysis" is unchecked. (in target 'Runner' from project 'Runner')
note: Run script build phase 'Thin Binary' will be run during every build because the option to run the script phase "Based on dependency analysis" is unchecked. (in target 'Runner' from project 'Runner')
note: Disabling previews because SWIFT_VERSION is set and SWIFT_OPTIMIZATION_LEVEL=-O, expected -Onone (in target 'Pods-Runner' from project 'Pods')
note: Disabling previews because SWIFT_VERSION is set and SWIFT_OPTIMIZATION_LEVEL=-O, expected -Onone (in target 'video_player_avfoundation' from project 'Pods')
note: Disabling previews because SWIFT_VERSION is set and SWIFT_OPTIMIZATION_LEVEL=-O, expected -Onone (in target 'url_launcher_ios' from project 'Pods')
note: Disabling previews because SWIFT_VERSION is set and SWIFT_OPTIMIZATION_LEVEL=-O, expected -Onone (in target 'sqflite_darwin' from project 'Pods')
note: Disabling previews because SWIFT_VERSION is set and SWIFT_OPTIMIZATION_LEVEL=-O, expected -Onone (in target 'video_player_avfoundation-video_player_avfoundation_privacy' from project 'Pods')
note: Disabling previews because SWIFT_VERSION is set and SWIFT_OPTIMIZATION_LEVEL=-O, expected -Onone (in target 'url_launcher_ios-url_launcher_ios_privacy' from project 'Pods')
note: Disabling previews because SWIFT_VERSION is set and SWIFT_OPTIMIZATION_LEVEL=-O, expected -Onone (in target 'sqflite_darwin-sqflite_darwin_privacy' from project 'Pods')
note: Disabling previews because SWIFT_VERSION is set and SWIFT_OPTIMIZATION_LEVEL=-O, expected -Onone (in target 'share_plus' from project 'Pods')
note: Disabling previews because SWIFT_VERSION is set and SWIFT_OPTIMIZATION_LEVEL=-O, expected -Onone (in target 'permission_handler_apple' from project 'Pods')
note: Disabling previews because SWIFT_VERSION is set and SWIFT_OPTIMIZATION_LEVEL=-O, expected -Onone (in target 'share_plus-share_plus_privacy' from project 'Pods')
note: Disabling previews because SWIFT_VERSION is set and SWIFT_OPTIMIZATION_LEVEL=-O, expected -Onone (in target 'permission_handler_apple-permission_handler_apple_privacy' from project 'Pods')
note: Disabling previews because SWIFT_VERSION is set and SWIFT_OPTIMIZATION_LEVEL=-O, expected -Onone (in target 'just_audio' from project 'Pods')
note: Disabling previews because SWIFT_VERSION is set and SWIFT_OPTIMIZATION_LEVEL=-O, expected -Onone (in target 'image_picker_ios' from project 'Pods')
note: Disabling previews because SWIFT_VERSION is set and SWIFT_OPTIMIZATION_LEVEL=-O, expected -Onone (in target 'image_picker_ios-image_picker_ios_privacy' from project 'Pods')
note: Disabling previews because SWIFT_VERSION is set and SWIFT_OPTIMIZATION_LEVEL=-O, expected -Onone (in target 'connectivity_plus' from project 'Pods')
note: Disabling previews because SWIFT_VERSION is set and SWIFT_OPTIMIZATION_LEVEL=-O, expected -Onone (in target 'connectivity_plus-connectivity_plus_privacy' from project 'Pods')
note: Disabling previews because SWIFT_VERSION is set and SWIFT_OPTIMIZATION_LEVEL=-O, expected -Onone (in target 'audio_session' from project 'Pods')
note: Disabling previews because SWIFT_VERSION is set and SWIFT_OPTIMIZATION_LEVEL=-O, expected -Onone (in target 'audio_service' from project 'Pods')
Error: Process completed with exit code 65.


2. Tasarımsal "Premium" Dokunuş Eksikliği
Eksik (Glassmorphism): Player ekranında arkada bulanık (Blur) bir görüntü var ama alt kısımdaki butonların olduğu panel çok düz. Oraya hafif şeffaf bir "Glass" efekti verilirse Apple Music kalitesine yaklaşır.
Hata: MiniPlayer (alt bar) ile Player ekranı arasındaki geçişte bazen şarkı ismi 1 milisaniye yer değiştiriyor (Jump effect). Bu hizalamalar milime

3. Bildirim (Notification) ve Arka Plan Senkronu
Hata: AudioService üzerinden bildirim panelinde şarkıyı ileri sardığında, eğer uygulama ön planda ve "Video" sayfasındaysa, video bazen sesle olan senkronunu kaybedebilir. Çünkü biz sadece uygulama içindeki Slider hareketlerini dinliyoruz.
Çözüm Eksikliği: Kilit ekranından şarkı değiştirildiğinde Video Controller'ın tamamen sıfırlanıp yeni şarkının videosuna "hazır" hale gelme hızı optimize edilmeli.

4. Video Player'ın "Aç-Kapa" Maliyeti (Performans)
Hata: 

PlayerScreen
 içinde her sayfa değişiminde 

_loadVideo
 fonksiyonu çalışıyor. Eğer kullanıcı videodan albüm kapağına geri dönerse, video controller'ı durduruyoruz ama bellekten tam atmıyoruz.
Kritik Eksik: Video yüklenirken (Loading) ekranında sadece ... yazıyor. Burada videonun ilk karesini (Thumbnail) gösterip üzerine bir yükleme ikonu koymak yerine siyah bir kutu bekletiyoruz. Bu "akıcı" hissi bozuyor.
3. Arama (Search) Ekranındaki "Boşluk"
Eksik: Şu anki arama ekranın sadece bir "Liste" mantığıyla çalışıyor. Spotify'daki gibi "Gözat (Browse)" kategorileri (Örn: Arabesk, Pop, Gece Modu, Spor) yok.
Hata: Kullanıcı yanlış bir şey yazarsa (Search query error), uygulama sadece boş bir sayfa gösteriyor. "Sonuç Bulunamadı" tasarımı yok.

Senkron Kayması: Bildirim panelinden şarkı atlandığında video bazen "eski şarkıda" takılı kalıyor. ref.listen ile her şarkı değişiminde video controller'ın tamamen dispose edilip sıfırdan kurulması hız açısından daha güvenli olur.

🎶 3. "Sleep Timer" (Uyku Zamanlayıcısı) Eksikliği
Analizimde en büyük "Ürün" eksikliği bu. Müzik uygulamalarında kullanıcıların %70'i yatarken müzik dinler.

Çözüm: Ayarlar kısmına "15 dk, 30 dk, 1 saat" gibi seçenekler eklenmeli ve bir Timer ile audio_handler durdurulmalı. Bu şu an devasa bir eksik.
📂 4. Playlist ve Veri Yönetimi
Hata: Çalma listesinden bir şarkıyı sildiğinde, Hive veritabanı güncelleniyor ama UI (ekran) bazen anlık tepki vermiyor. Sayfadan çıkıp girmen gerekiyor.
Analiz: 

PlaylistDetailScreen
 içinde bir Stream veya Provider dinleyicisi eksik. Veriyi "çekiyoruz" ama "dinlemiyoruz".

 