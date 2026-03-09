import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/mini_player.dart';
import '../providers/settings_provider.dart';

class MainScreen extends ConsumerWidget {
  final Widget child;

  const MainScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(localeProvider);
    return Scaffold(
      body: child,
      bottomSheet: const MiniPlayer(),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          currentIndex: _calculateSelectedIndex(context),
          onTap: (index) => _onItemTapped(index, context),
          backgroundColor: const Color(0xFF0A0A0A),
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey[600],
          showSelectedLabels: true,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
          unselectedLabelStyle: const TextStyle(fontSize: 10),
          elevation: 0,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home_outlined),
              activeIcon: const Icon(Icons.home_filled),
              label: t.home,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.search_rounded),
              activeIcon: const Icon(Icons.search_rounded, size: 28),
              label: t.search,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.library_music_outlined),
              activeIcon: const Icon(Icons.library_music),
              label: t.library,
            ),
          ],
        ),
      ),
    );
  }

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/search')) return 1;
    if (location.startsWith('/library')) return 2;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    if (index == 0) context.go('/');
    if (index == 1) context.go('/search');
    if (index == 2) context.go('/library');
  }
}
