import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:melow_flutter/core/themes/app_colors.dart';
import 'package:melow_flutter/presentation/widgets/recent_takes_card.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Melow',
          style: TextStyle(
            fontSize: 28.sp,
            fontWeight: FontWeight.bold,
            foreground: Paint()
              ..shader = const LinearGradient(
                colors: [AppColors.primary, AppColors.secondary],
              ).createShader(
                const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0),
              ),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Section
              Container(
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.secondary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'こんにちは！',
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      '今日も素敵なメロディを作りましょう',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),
              
              // Quick Actions
              Text(
                'クイックアクション',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Expanded(
                    child: _QuickActionCard(
                      icon: Icons.add_circle_outline,
                      title: '新しい曲',
                      subtitle: '歌詞から作成',
                      gradient: const [
                        AppColors.primary,
                        AppColors.primaryLight,
                      ],
                      onTap: () {
                        // Navigate to lyrics page
                      },
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: _QuickActionCard(
                      icon: Icons.auto_awesome,
                      title: 'AI生成',
                      subtitle: '自動で歌詞を作成',
                      gradient: const [
                        AppColors.secondary,
                        AppColors.secondaryLight,
                      ],
                      onTap: () {
                        // Navigate to AI generation
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),
              
              // Recent Takes
              Text(
                '最近のテイク',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.h),
              const RecentTakesCard(),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final List<Color> gradient;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: 40.sp,
              color: Colors.white,
            ),
            SizedBox(height: 12.h),
            Text(
              title,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}