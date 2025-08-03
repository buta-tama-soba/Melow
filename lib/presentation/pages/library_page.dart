import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:melow_flutter/core/themes/app_colors.dart';
import 'package:melow_flutter/domain/entities/take.dart';

// Mock provider for takes
final takesProvider = StateProvider<List<Take>>((ref) => [
  Take(
    id: '1',
    title: '春の風が優しく - Take 3',
    createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    noteCount: 45,
    isFavorite: true,
  ),
  Take(
    id: '2',
    title: '春の風が優しく - Take 2',
    createdAt: DateTime.now().subtract(const Duration(hours: 4)),
    noteCount: 42,
    isFavorite: false,
  ),
  Take(
    id: '3',
    title: '春の風が優しく - Take 1',
    createdAt: DateTime.now().subtract(const Duration(hours: 6)),
    noteCount: 38,
    isFavorite: false,
  ),
]);

class LibraryPage extends ConsumerWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final takes = ref.watch(takesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ライブラリ'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () {
              // Show sort options
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // Show filter options
            },
          ),
        ],
      ),
      body: takes.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: EdgeInsets.all(16.w),
              itemCount: takes.length,
              itemBuilder: (context, index) {
                final take = takes[index];
                return _TakeCard(
                  take: take,
                  onFavoriteToggle: () {
                    final updatedTakes = [...takes];
                    updatedTakes[index] = take.copyWith(
                      isFavorite: !take.isFavorite,
                    );
                    ref.read(takesProvider.notifier).state = updatedTakes;
                  },
                );
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.library_music_outlined,
            size: 80.sp,
            color: AppColors.textSecondary,
          ),
          SizedBox(height: 16.h),
          Text(
            'まだテイクがありません',
            style: TextStyle(
              fontSize: 18.sp,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            '最初のメロディを作成しましょう！',
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _TakeCard extends StatelessWidget {
  final Take take;
  final VoidCallback onFavoriteToggle;

  const _TakeCard({
    required this.take,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        take.title,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        '${_formatDate(take.createdAt)} • ${take.noteCount}音符',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    take.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: take.isFavorite ? AppColors.error : null,
                  ),
                  onPressed: onFavoriteToggle,
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                _ActionButton(
                  icon: Icons.play_arrow,
                  label: '再生',
                  onTap: () {
                    // Play take
                  },
                  isPrimary: true,
                ),
                SizedBox(width: 8.w),
                _ActionButton(
                  icon: Icons.edit,
                  label: '編集',
                  onTap: () {
                    // Edit take
                  },
                ),
                SizedBox(width: 8.w),
                _ActionButton(
                  icon: Icons.download,
                  label: 'エクスポート',
                  onTap: () {
                    // Export take
                  },
                ),
                SizedBox(width: 8.w),
                _ActionButton(
                  icon: Icons.share,
                  label: '共有',
                  onTap: () {
                    // Share take
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes}分前';
      }
      return '${difference.inHours}時間前';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}日前';
    } else {
      return '${date.month}/${date.day}';
    }
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isPrimary;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8.r),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          decoration: BoxDecoration(
            color: isPrimary
                ? AppColors.primary
                : Theme.of(context).brightness == Brightness.dark
                    ? AppColors.surfaceDark
                    : AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16.sp,
                color: isPrimary ? Colors.white : null,
              ),
              SizedBox(width: 4.w),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: isPrimary ? Colors.white : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}