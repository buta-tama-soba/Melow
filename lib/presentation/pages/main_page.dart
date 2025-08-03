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
      appBar: AppBar(
        toolbarHeight: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: Container(
            height: 80,
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).dividerColor.withOpacity(0.1),
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _TabButton(
                  icon: Icons.home,
                  label: 'ホーム',
                  isSelected: selectedIndex == 0,
                  onTap: () => ref.read(selectedIndexProvider.notifier).state = 0,
                ),
                _TabButton(
                  icon: Icons.edit,
                  label: '歌詞',
                  isSelected: selectedIndex == 1,
                  onTap: () => ref.read(selectedIndexProvider.notifier).state = 1,
                ),
                _TabButton(
                  icon: Icons.piano,
                  label: '演奏',
                  isSelected: selectedIndex == 2,
                  onTap: () => ref.read(selectedIndexProvider.notifier).state = 2,
                ),
                _TabButton(
                  icon: Icons.library_music,
                  label: 'ライブラリ',
                  isSelected: selectedIndex == 3,
                  onTap: () => ref.read(selectedIndexProvider.notifier).state = 3,
                ),
              ],
            ),
          ),
        ),
      ),
      body: IndexedStack(
        index: selectedIndex,
        children: const [
          HomePage(),
          LyricsPage(),
          PerformancePage(),
          LibraryPage(),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabButton({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 28,
              color: isSelected 
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected 
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}