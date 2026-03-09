  export TEMP_DIR\=/Users/runner/Library/Developer/Xcode/DerivedData/Runner-cjpwgbsjkzswpkdzrkkjepoqfffb/Build/Intermediates.noindex/Runner.build/Release-iphoneos/Runner.build
    export TEMP_FILES_DIR\=/Users/runner/Library/Developer/Xcode/DerivedData/Runner-cjpwgbsjkzswpkdzrkkjepoqfffb/Build/Intermediates.noindex/Runner.build/Release-iphoneos/Runner.build
    export TEMP_FILE_DIR\=/Users/runner/Library/Developer/Xcode/DerivedData/Runner-cjpwgbsjkzswpkdzrkkjepoqfffb/Build/Intermediates.noindex/Runner.build/Release-iphoneos/Runner.build
    export TEMP_ROOT\=/Users/runner/Library/Developer/Xcode/DerivedData/Runner-cjpwgbsjkzswpkdzrkkjepoqfffb/Build/Intermediates.noindex
    export TEMP_SANDBOX_DIR\=/Users/runner/Library/Developer/Xcode/DerivedData/Runner-cjpwgbsjkzswpkdzrkkjepoqfffb/Build/Intermediates.noindex/TemporaryTaskSandboxes
    export TEST_FRAMEWORK_SEARCH_PATHS\=\ /Applications/Xcode_16.4.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/Library/Frameworks\ /Applications/Xcode_16.4.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS18.5.sdk/Developer/Library/Frameworks
    export TEST_LIBRARY_SEARCH_PATHS\=\ /Applications/Xcode_16.4.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/usr/lib
    export TOOLCHAINS\=com.apple.dt.toolchain.XcodeDefault
    export TOOLCHAIN_DIR\=/Applications/Xcode_16.4.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain
    export TRACK_WIDGET_CREATION\=false
    export TREAT_MISSING_BASELINES_AS_TEST_FAILURES\=NO
    export TREAT_MISSING_SCRIPT_PHASE_OUTPUTS_AS_ERRORS\=NO
    export TREE_SHAKE_ICONS\=true
    export UID\=501
    export UNINSTALLED_PRODUCTS_DIR\=/Users/runner/Library/Developer/Xcode/DerivedData/Runner-cjpwgbsjkzswpkdzrkkjepoqfffb/Build/Intermediates.noindex/UninstalledProducts
    export UNLOCALIZED_RESOURCES_FOLDER_PATH\=Runner.app
    export UNLOCALIZED_RESOURCES_FOLDER_PATH_SHALLOW_BUNDLE_NO\=Runner.app/Resources
    export UNLOCALIZED_RESOURCES_FOLDER_PATH_SHALLOW_BUNDLE_YES\=Runner.app
    export UNSTRIPPED_PRODUCT\=NO
    export USER\=runner
    export USER_APPS_DIR\=/Users/runner/Applications
    export USER_LIBRARY_DIR\=/Users/runner/Library
    export USE_DYNAMIC_NO_PIC\=YES
    export USE_HEADERMAP\=YES
    export USE_HEADER_SYMLINKS\=NO
    export USE_RECURSIVE_SCRIPT_INPUTS_IN_SCRIPT_PHASES\=YES
    export VALIDATE_DEVELOPMENT_ASSET_PATHS\=YES_ERROR
    export VALIDATE_PRODUCT\=YES
    export VALID_ARCHS\=arm64\ arm64e\ armv7\ armv7s
    export VERBOSE_PBXCP\=NO
    export VERSIONING_SYSTEM\=apple-generic
    export VERSIONPLIST_PATH\=Runner.app/version.plist
    export VERSION_INFO_BUILDER\=runner
    export VERSION_INFO_FILE\=Runner_vers.c
    export VERSION_INFO_STRING\=\"@\(\#\)PROGRAM:Runner\ \ PROJECT:Runner-2\"
    export WORKSPACE_DIR\=/Users/runner/work/music/music/ios
    export WRAPPER_EXTENSION\=app
    export WRAPPER_NAME\=Runner.app
    export WRAPPER_SUFFIX\=.app
    export WRAP_ASSET_PACKS_IN_SEPARATE_DIRECTORIES\=NO
    export XCODE_APP_SUPPORT_DIR\=/Applications/Xcode_16.4.app/Contents/Developer/Library/Xcode
    export XCODE_PRODUCT_BUILD_VERSION\=16F6
    export XCODE_VERSION_ACTUAL\=1640
    export XCODE_VERSION_MAJOR\=1600
    export XCODE_VERSION_MINOR\=1640
    export XPCSERVICES_FOLDER_PATH\=Runner.app/XPCServices
    export YACC\=yacc
    export _DISCOVER_COMMAND_LINE_LINKER_INPUTS\=YES
    export _DISCOVER_COMMAND_LINE_LINKER_INPUTS_INCLUDE_WL\=YES
    export _WRAPPER_CONTENTS_DIR_SHALLOW_BUNDLE_NO\=/Contents
    export _WRAPPER_PARENT_PATH_SHALLOW_BUNDLE_NO\=/..
    export _WRAPPER_RESOURCES_DIR_SHALLOW_BUNDLE_NO\=/Resources
    export __DIAGNOSE_DEPRECATED_ARCHS\=YES
    export __IS_NOT_MACOS\=YES
    export __IS_NOT_MACOS_macosx\=NO
    export __IS_NOT_SIMULATOR\=YES
    export __IS_NOT_SIMULATOR_simulator\=NO
    export arch\=undefined_arch
    export variant\=normal
    /bin/sh -c /Users/runner/Library/Developer/Xcode/DerivedData/Runner-cjpwgbsjkzswpkdzrkkjepoqfffb/Build/Intermediates.noindex/Runner.build/Release-iphoneos/Runner.build/Script-9740EEB61CF901F6004384FC.sh
lib/services/youtube_service.dart:11:21: Error: A value of type 'VideoSearchList' can't be assigned to a variable of type 'SearchList?'.
 - 'VideoSearchList' is from 'package:youtube_explode_dart/src/search/search_list.dart' ('../../../.pub-cache/hosted/pub.dev/youtube_explode_dart-3.0.5/lib/src/search/search_list.dart').
 - 'SearchList' is from 'package:youtube_explode_dart/src/search/search_list.dart' ('../../../.pub-cache/hosted/pub.dev/youtube_explode_dart-3.0.5/lib/src/search/search_list.dart').
      _lastSearch = await _yt.search.search(query);
                    ^
Target kernel_snapshot_program failed: Exception
** BUILD FAILED **
Failed to package /Users/runner/work/music/music.

Command PhaseScriptExecution failed with a nonzero exit code


The following build commands failed:
note: Disabling previews because SWIFT_VERSION is set and SWIFT_OPTIMIZATION_LEVEL=-O, expected -Onone (in target 'Flutter' from project 'Pods')
	PhaseScriptExecution Run\ Script /Users/runner/Library/Developer/Xcode/DerivedData/Runner-cjpwgbsjkzswpkdzrkkjepoqfffb/Build/Intermediates.noindex/Runner.build/Release-iphoneos/Runner.build/Script-9740EEB61CF901F6004384FC.sh (in target 'Runner' from project 'Runner')
warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/url_launcher_ios/url_launcher_ios_privacy.bundle' is located outside of the allowed root paths.
	Building workspace Runner with scheme Runner and configuration Release

(2 failures)
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

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/share_plus/share_plus_privacy.bundle' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/share_plus/share_plus_privacy.bundle/Info.plist' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/share_plus/share_plus_privacy.bundle/PrivacyInfo.xcprivacy' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/sqflite_darwin/sqflite_darwin.framework' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/sqflite_darwin/sqflite_darwin.framework.dSYM/Contents/Resources/DWARF/sqflite_darwin' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/share_plus/share_plus.framework' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/sqflite_darwin/sqflite_darwin.framework/Headers' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/share_plus/share_plus.framework.dSYM/Contents/Resources/DWARF/share_plus' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/sqflite_darwin/sqflite_darwin.framework/Headers/SqfliteImportPublic.h' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/share_plus/share_plus.framework/Headers' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/sqflite_darwin/sqflite_darwin.framework/Headers/SqflitePluginPublic.h' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/share_plus/share_plus.framework/Headers/FPPSharePlusPlugin.h' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/share_plus/share_plus.framework/Headers/share_plus-umbrella.h' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/share_plus/share_plus.framework/Info.plist' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/share_plus/share_plus.framework/Modules/module.modulemap' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/share_plus/share_plus.framework/share_plus' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/share_plus/share_plus.framework/share_plus_privacy.bundle' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/sqflite_darwin/sqflite_darwin.framework/Headers/sqflite_darwin-umbrella.h' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/sqflite_darwin/sqflite_darwin.framework/Info.plist' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/sqflite_darwin/sqflite_darwin.framework/Modules/module.modulemap' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/sqflite_darwin/sqflite_darwin.framework/sqflite_darwin' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/sqflite_darwin/sqflite_darwin.framework/sqflite_darwin_privacy.bundle' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/permission_handler_apple/permission_handler_apple_privacy.bundle' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/permission_handler_apple/permission_handler_apple_privacy.bundle/Info.plist' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/permission_handler_apple/permission_handler_apple_privacy.bundle/PrivacyInfo.xcprivacy' is located outside of the allowed root paths.

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

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/just_audio/just_audio.framework/Info.plist' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/just_audio/just_audio.framework/Modules/module.modulemap' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/just_audio/just_audio.framework/just_audio' is located outside of the allowed root paths.

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

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/connectivity_plus/connectivity_plus_privacy.bundle' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/permission_handler_apple/permission_handler_apple.framework/Headers/PermissionManager.h' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/connectivity_plus/connectivity_plus_privacy.bundle/Info.plist' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/permission_handler_apple/permission_handler_apple.framework/Headers/PermissionStrategy.h' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/permission_handler_apple/permission_handler_apple.framework/Headers/PhonePermissionStrategy.h' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/connectivity_plus/connectivity_plus_privacy.bundle/PrivacyInfo.xcprivacy' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/permission_handler_apple/permission_handler_apple.framework/Headers/PhotoPermissionStrategy.h' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/permission_handler_apple/permission_handler_apple.framework/Headers/SensorPermissionStrategy.h' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/permission_handler_apple/permission_handler_apple.framework/Headers/SpeechPermissionStrategy.h' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/permission_handler_apple/permission_handler_apple.framework/Headers/StoragePermissionStrategy.h' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/permission_handler_apple/permission_handler_apple.framework/Headers/UnknownPermissionStrategy.h' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/permission_handler_apple/permission_handler_apple.framework/Headers/permission_handler_apple-umbrella.h' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/permission_handler_apple/permission_handler_apple.framework/Info.plist' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/permission_handler_apple/permission_handler_apple.framework/Modules/module.modulemap' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/permission_handler_apple/permission_handler_apple.framework/permission_handler_apple' is located outside of the allowed root paths.

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

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/Pods_Runner.framework' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/Pods_Runner.framework/Headers' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/Pods_Runner.framework/Headers/Pods-Runner-umbrella.h' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/Runner.app' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/Pods_Runner.framework/Info.plist' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/Runner.app.dSYM/Contents/Resources/DWARF/Runner' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/Pods_Runner.framework/Modules/module.modulemap' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/Runner.app/AppFrameworkInfo.plist' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/Pods_Runner.framework/Pods_Runner' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/Runner.app/Assets.car' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/Runner.app/Base.lproj/LaunchScreen.storyboardc' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/Runner.app/Base.lproj/Main.storyboardc' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/Runner.app/Frameworks' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/Runner.app/Frameworks/audio_service.framework' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/Runner.app/Frameworks/audio_session.framework' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/Runner.app/Frameworks/connectivity_plus.framework' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/Runner.app/Frameworks/just_audio.framework' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/Runner.app/Frameworks/share_plus.framework' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/Runner.app/Frameworks/sqflite_darwin.framework' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/Runner.app/Frameworks/url_launcher_ios.framework' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/Runner.app/Info.plist' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/Runner.app/PkgInfo' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/Runner.app/Runner' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/Runner.app/permission_handler_apple_privacy.bundle' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/Runner.swiftmodule/Project/arm64-apple-ios.swiftsourceinfo' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/Runner.swiftmodule/arm64-apple-ios.abi.json' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/Runner.swiftmodule/arm64-apple-ios.swiftdoc' is located outside of the allowed root paths.

warning: Stale file '/Users/runner/work/music/music/build/ios/Release-iphoneos/Runner.swiftmodule/arm64-apple-ios.swiftmodule' is located outside of the allowed root paths.

note: Disabling previews because SWIFT_VERSION is set and SWIFT_OPTIMIZATION_LEVEL=-O, expected -Onone (in target 'Pods-Runner' from project 'Pods')
note: Disabling previews because SWIFT_VERSION is set and SWIFT_OPTIMIZATION_LEVEL=-O, expected -Onone (in target 'permission_handler_apple' from project 'Pods')
note: Disabling previews because SWIFT_VERSION is set and SWIFT_OPTIMIZATION_LEVEL=-O, expected -Onone (in target 'url_launcher_ios' from project 'Pods')
note: Disabling previews because SWIFT_VERSION is set and SWIFT_OPTIMIZATION_LEVEL=-O, expected -Onone (in target 'sqflite_darwin' from project 'Pods')
note: Disabling previews because SWIFT_VERSION is set and SWIFT_OPTIMIZATION_LEVEL=-O, expected -Onone (in target 'share_plus' from project 'Pods')
note: Disabling previews because SWIFT_VERSION is set and SWIFT_OPTIMIZATION_LEVEL=-O, expected -Onone (in target 'just_audio' from project 'Pods')
note: Disabling previews because SWIFT_VERSION is set and SWIFT_OPTIMIZATION_LEVEL=-O, expected -Onone (in target 'connectivity_plus' from project 'Pods')
note: Disabling previews because SWIFT_VERSION is set and SWIFT_OPTIMIZATION_LEVEL=-O, expected -Onone (in target 'audio_session' from project 'Pods')
note: Disabling previews because SWIFT_VERSION is set and SWIFT_OPTIMIZATION_LEVEL=-O, expected -Onone (in target 'url_launcher_ios-url_launcher_ios_privacy' from project 'Pods')
note: Disabling previews because SWIFT_VERSION is set and SWIFT_OPTIMIZATION_LEVEL=-O, expected -Onone (in target 'sqflite_darwin-sqflite_darwin_privacy' from project 'Pods')
note: Disabling previews because SWIFT_VERSION is set and SWIFT_OPTIMIZATION_LEVEL=-O, expected -Onone (in target 'share_plus-share_plus_privacy' from project 'Pods')
note: Disabling previews because SWIFT_VERSION is set and SWIFT_OPTIMIZATION_LEVEL=-O, expected -Onone (in target 'permission_handler_apple-permission_handler_apple_privacy' from project 'Pods')
note: Disabling previews because SWIFT_VERSION is set and SWIFT_OPTIMIZATION_LEVEL=-O, expected -Onone (in target 'connectivity_plus-connectivity_plus_privacy' from project 'Pods')
Error: Process completed with exit code 65.