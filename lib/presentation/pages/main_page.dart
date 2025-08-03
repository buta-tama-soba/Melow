import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melow_flutter/presentation/pages/home_page.dart';
import 'package:melow_flutter/presentation/pages/lyrics_page.dart';
import 'package:melow_flutter/presentation/pages/performance_page.dart';
import 'package:melow_flutter/presentation/pages/library_page.dart';

final selectedIndexProvider = StateProvider<int>((ref) => 0);

class MainPage extends ConsumerWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(selectedIndexProvider);
    
    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: const [
          HomePage(),
          LyricsPage(),
          PerformancePage(),
          LibraryPage(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          ref.read(selectedIndexProvider.notifier).state = index;
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'ホーム',
          ),
          NavigationDestination(
            icon: Icon(Icons.edit_outlined),
            selectedIcon: Icon(Icons.edit),
            label: '歌詞',
          ),
          NavigationDestination(
            icon: Icon(Icons.piano_outlined),
            selectedIcon: Icon(Icons.piano),
            label: '演奏',
          ),
          NavigationDestination(
            icon: Icon(Icons.library_music_outlined),
            selectedIcon: Icon(Icons.library_music),
            label: 'ライブラリ',
          ),
        ],
      ),
    );
  }
}