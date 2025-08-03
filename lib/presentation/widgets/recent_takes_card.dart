import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:melow_flutter/core/themes/app_colors.dart';
import 'package:melow_flutter/presentation/pages/library_page.dart';

class RecentTakesCard extends ConsumerWidget {
  const RecentTakesCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final takes = ref.watch(takesProvider);
    final recentTakes = takes.take(3).toList();

    if (recentTakes.isEmpty) {
      return Card(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Center(
            child: Column(
              children: [
                Icon(
                  Icons.music_note,
                  size: 48.sp,
                  color: AppColors.textSecondary,
                ),
                SizedBox(height: 12.h),
                Text(
                  'まだテイクがありません',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Column(
      children: recentTakes.map((take) {
        return Card(
          margin: EdgeInsets.only(bottom: 8.h),
          child: ListTile(
            leading: Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryLight],
                ),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 24.sp,
              ),
            ),
            title: Text(
              take.title,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Text(
              _formatDate(take.createdAt),
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.textSecondary,
              ),
            ),
            trailing: IconButton(
              icon: Icon(
                take.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: take.isFavorite ? AppColors.error : AppColors.textSecondary,
                size: 20.sp,
              ),
              onPressed: () {
                // Toggle favorite
              },
            ),
            onTap: () {
              // Play take
            },
          ),
        );
      }).toList(),
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