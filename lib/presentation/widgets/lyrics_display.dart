import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:melow_flutter/core/themes/app_colors.dart';
import 'package:melow_flutter/presentation/pages/performance_page.dart';
import 'package:melow_flutter/presentation/pages/lyrics_page.dart';

// Providers
final currentLyricIndexProvider = StateProvider<int>((ref) => 0);
final currentCharIndexProvider = StateProvider<int>((ref) => 0);

class LyricsDisplay extends ConsumerWidget {
  final PerformanceMode performanceMode;
  final bool isRecording;

  const LyricsDisplay({
    super.key,
    required this.performanceMode,
    required this.isRecording,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lyrics = ref.watch(lyricsProvider);
    final currentLyricIndex = ref.watch(currentLyricIndexProvider);
    final currentCharIndex = ref.watch(currentCharIndexProvider);

    if (lyrics.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.music_note,
              size: 64.sp,
              color: AppColors.textSecondary,
            ),
            SizedBox(height: 16.h),
            Text(
              '歌詞が読み込まれていません',
              style: TextStyle(
                fontSize: 16.sp,
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              '歌詞タブから追加してください',
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    if (performanceMode == PerformanceMode.character) {
      return _CharacterModeDisplay(
        lyrics: lyrics,
        currentLyricIndex: currentLyricIndex,
        currentCharIndex: currentCharIndex,
        isRecording: isRecording,
      );
    } else {
      return _TimingModeDisplay(
        lyrics: lyrics,
        currentLyricIndex: currentLyricIndex,
      );
    }
  }
}

class _CharacterModeDisplay extends StatelessWidget {
  final String lyrics;
  final int currentLyricIndex;
  final int currentCharIndex;
  final bool isRecording;

  const _CharacterModeDisplay({
    required this.lyrics,
    required this.currentLyricIndex,
    required this.currentCharIndex,
    required this.isRecording,
  });

  @override
  Widget build(BuildContext context) {
    final lines = lyrics.split('\n');
    
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(lines.length, (lineIndex) {
            final line = lines[lineIndex];
            final isCurrentLine = lineIndex == currentLyricIndex;
            final isCompletedLine = lineIndex < currentLyricIndex;
            
            return Container(
              margin: EdgeInsets.only(bottom: 16.h),
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: isCurrentLine && isRecording
                    ? AppColors.primary.withOpacity(0.1)
                    : isCompletedLine
                        ? AppColors.success.withOpacity(0.1)
                        : Colors.transparent,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: isCurrentLine && isRecording
                      ? AppColors.primary
                      : isCompletedLine
                          ? AppColors.success
                          : AppColors.textSecondary.withOpacity(0.3),
                  width: isCurrentLine && isRecording ? 2 : 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Line ${lineIndex + 1}',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      if (isCurrentLine && isRecording)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Text(
                            '録音中',
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      if (isCompletedLine)
                        Icon(
                          Icons.check_circle,
                          size: 16.sp,
                          color: AppColors.success,
                        ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Wrap(
                    children: List.generate(line.length, (charIndex) {
                      final isCurrentChar = isCurrentLine && 
                                          charIndex == currentCharIndex && 
                                          isRecording;
                      final isCompletedChar = isCurrentLine && 
                                            charIndex < currentCharIndex ||
                                            isCompletedLine;
                      
                      return Container(
                        margin: EdgeInsets.all(2.w),
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: isCurrentChar
                              ? AppColors.primary
                              : isCompletedChar
                                  ? AppColors.success.withOpacity(0.3)
                                  : Colors.transparent,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          line[charIndex],
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: isCurrentChar
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isCurrentChar
                                ? Colors.white
                                : isCompletedChar
                                    ? AppColors.success
                                    : null,
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _TimingModeDisplay extends StatelessWidget {
  final String lyrics;
  final int currentLyricIndex;

  const _TimingModeDisplay({
    required this.lyrics,
    required this.currentLyricIndex,
  });

  @override
  Widget build(BuildContext context) {
    final lines = lyrics.split('\n');
    final currentLine = currentLyricIndex < lines.length 
        ? lines[currentLyricIndex] 
        : '';

    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '現在の行: ${currentLyricIndex + 1} / ${lines.length}',
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'タップして文字を配置:',
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 16.h),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceDark,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Stack(
                children: [
                  // Grid lines for guidance
                  CustomPaint(
                    size: Size.infinite,
                    painter: GridPainter(),
                  ),
                  // Draggable characters
                  ...List.generate(currentLine.length, (index) {
                    return Positioned(
                      left: 50.0 + index * 40.0,
                      top: 50.0,
                      child: Draggable<String>(
                        data: currentLine[index],
                        feedback: Material(
                          color: Colors.transparent,
                          child: Container(
                            padding: EdgeInsets.all(8.w),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Text(
                              currentLine[index],
                              style: TextStyle(
                                fontSize: 20.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        child: Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Text(
                            currentLine[index],
                            style: TextStyle(
                              fontSize: 18.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.textSecondary.withOpacity(0.1)
      ..strokeWidth = 1;

    // Draw vertical lines
    for (double x = 0; x < size.width; x += 40) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }

    // Draw horizontal lines
    for (double y = 0; y < size.height; y += 40) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}