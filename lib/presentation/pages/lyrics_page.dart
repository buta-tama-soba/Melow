import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:melow_flutter/core/themes/app_colors.dart';

// Provider for lyrics text
final lyricsProvider = StateProvider<String>((ref) => '');

// Provider for selected input method
final lyricsInputMethodProvider = StateProvider<int>((ref) => 0);

class LyricsPage extends ConsumerStatefulWidget {
  const LyricsPage({super.key});

  @override
  ConsumerState<LyricsPage> createState() => _LyricsPageState();
}

class _LyricsPageState extends ConsumerState<LyricsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _lyricsController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _lyricsController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lyrics = ref.watch(lyricsProvider);

    return Column(
        children: [
          // Tab Bar
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.surfaceDark
                  : AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textSecondary,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              tabs: const [
                Tab(text: '手動入力'),
                Tab(text: 'URL'),
                Tab(text: 'X/Twitter'),
                Tab(text: 'AI生成'),
              ],
            ),
          ),
          
          // Tab Views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Manual Input
                _buildManualInput(),
                // URL Input
                _buildUrlInput(),
                // Twitter Input
                _buildTwitterInput(),
                // AI Generation
                _buildAiGeneration(),
              ],
            ),
          ),
          
          // Preview and Action Button
          if (lyrics.isNotEmpty) ...[
            Container(
              margin: EdgeInsets.all(16.w),
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.cardDark
                    : AppColors.cardLight,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: AppColors.primary.withOpacity(0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'プレビュー',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    lyrics,
                    style: TextStyle(fontSize: 16.sp),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to performance page
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  minimumSize: Size(double.infinity, 48.h),
                ),
                child: const Text(
                  '演奏を開始',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ],
      );
  }

  Widget _buildManualInput() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          TextField(
            controller: _lyricsController,
            maxLines: 10,
            decoration: InputDecoration(
              hintText: 'ここに歌詞を入力してください...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              filled: true,
            ),
            onChanged: (value) {
              ref.read(lyricsProvider.notifier).state = value;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildUrlInput() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          TextField(
            controller: _urlController,
            decoration: InputDecoration(
              hintText: '歌詞のURLを貼り付けてください...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              filled: true,
              suffixIcon: IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  // Fetch lyrics from URL
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTwitterInput() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'X/TwitterのURLを貼り付けてください...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              filled: true,
              suffixIcon: IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  // Fetch from Twitter
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAiGeneration() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          Text(
            '雰囲気を選んでください',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.h),
          Wrap(
            spacing: 12.w,
            runSpacing: 12.h,
            children: [
              _buildMoodChip('楽しい', Icons.sentiment_very_satisfied),
              _buildMoodChip('悲しい', Icons.sentiment_dissatisfied),
              _buildMoodChip('元気', Icons.flash_on),
              _buildMoodChip('落ち着いた', Icons.spa),
              _buildMoodChip('ロマンチック', Icons.favorite),
              _buildMoodChip('ノスタルジック', Icons.access_time),
            ],
          ),
          SizedBox(height: 24.h),
          ElevatedButton.icon(
            onPressed: () {
              // Generate AI lyrics
            },
            icon: const Icon(Icons.auto_awesome),
            label: const Text('歌詞を生成'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondary,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodChip(String label, IconData icon) {
    return ActionChip(
      label: Text(label),
      avatar: Icon(icon, size: 18.sp),
      onPressed: () {
        // Select mood
      },
      backgroundColor: AppColors.primary.withOpacity(0.1),
      labelStyle: TextStyle(
        color: AppColors.primary,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}