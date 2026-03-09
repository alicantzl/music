import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LocalizedStrings {
  final String greetingMorning;
  final String greetingAfternoon;
  final String greetingEvening;
  final String greetingNight;
  final String home;
  final String search;
  final String library;
  final String settings;
  final String language;
  final String region;
  final String trendingHits;
  final String madeForYou;
  final String allSongs;
  final String editPlaylist;
  final String save;
  final String cancel;
  final String dataSaver;
  final String gaplessPlayback;
  final String clearCache;
  final String about;
  final String logOut;
  final String sleepTimer;
  final String searchHint;
  final String noResults;
  final String browseAll;
  final String sleepTimerOff;

  LocalizedStrings({
    required this.greetingMorning,
    required this.greetingAfternoon,
    required this.greetingEvening,
    required this.greetingNight,
    required this.home,
    required this.search,
    required this.library,
    required this.settings,
    required this.language,
    required this.region,
    required this.trendingHits,
    required this.madeForYou,
    required this.allSongs,
    required this.editPlaylist,
    required this.save,
    required this.cancel,
    required this.dataSaver,
    required this.gaplessPlayback,
    required this.clearCache,
    required this.about,
    required this.logOut,
    required this.sleepTimer,
    required this.searchHint,
    required this.noResults,
    required this.browseAll,
    required this.sleepTimerOff,
  });

  static final en = LocalizedStrings(
    greetingMorning: 'Good morning',
    greetingAfternoon: 'Good afternoon',
    greetingEvening: 'Good evening',
    greetingNight: 'Good night',
    home: 'Home',
    search: 'Search',
    library: 'Library',
    settings: 'Settings',
    language: 'Language',
    region: 'Region',
    trendingHits: 'Trending Hits',
    madeForYou: 'Made For You',
    allSongs: 'All Songs',
    editPlaylist: 'Edit Playlist',
    save: 'Save',
    cancel: 'Cancel',
    dataSaver: 'Data Saver',
    gaplessPlayback: 'Gapless Playback',
    clearCache: 'Clear App Cache',
    about: 'About',
    logOut: 'Log Out',
    sleepTimer: 'Sleep Timer',
    searchHint: 'What do you want to listen to?',
    noResults: 'No results found.',
    browseAll: 'Browse All',
    sleepTimerOff: 'Timer Off',
  );

  static final tr = LocalizedStrings(
    greetingMorning: 'Günaydın',
    greetingAfternoon: 'Tünaydın',
    greetingEvening: 'İyi akşamlar',
    greetingNight: 'İyi geceler',
    home: 'Ana Sayfa',
    search: 'Ara',
    library: 'Kitaplık',
    settings: 'Ayarlar',
    language: 'Dil',
    region: 'Bölge',
    trendingHits: 'Trendler',
    madeForYou: 'Sana Özel',
    allSongs: 'Tüm Şarkılar',
    editPlaylist: 'Çalma Listesini Düzenle',
    save: 'Kaydet',
    cancel: 'İptal',
    dataSaver: 'Veri Tasarrufu',
    gaplessPlayback: 'Kesintisiz Çalma',
    clearCache: 'Önbelleği Temizle',
    about: 'Hakkında',
    logOut: 'Oturumu Kapat',
    sleepTimer: 'Uyku Zamanlayıcısı',
    searchHint: 'Ne dinlemek istiyorsun?',
    noResults: 'Sonuç bulunamadı.',
    browseAll: 'Tümünü Gözat',
    sleepTimerOff: 'Zamanlayıcı Kapalı',
  );
}

class LocaleNotifier extends Notifier<LocalizedStrings> {
  late Box _box;

  @override
  LocalizedStrings build() {
    _box = Hive.box('settings');
    final lang = _box.get('language', defaultValue: 'English');
    return lang == 'Türkçe' ? LocalizedStrings.tr : LocalizedStrings.en;
  }

  void setLanguage(String lang) {
    _box.put('language', lang);
    state = lang == 'Türkçe' ? LocalizedStrings.tr : LocalizedStrings.en;
  }
}

final localeProvider = NotifierProvider<LocaleNotifier, LocalizedStrings>(LocaleNotifier.new);

class RegionNotifier extends Notifier<String> {
  late Box _box;

  @override
  String build() {
    _box = Hive.box('settings');
    return _box.get('region', defaultValue: 'US');
  }

  void setRegion(String region) {
    _box.put('region', region);
    state = region;
  }
}

final regionProvider = NotifierProvider<RegionNotifier, String>(RegionNotifier.new);
