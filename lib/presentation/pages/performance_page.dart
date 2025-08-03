import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:melow_flutter/core/themes/app_colors.dart';
import 'package:melow_flutter/presentation/widgets/piano_keyboard.dart';
import 'package:melow_flutter/presentation/widgets/lyrics_display.dart';

// Providers
final isRecordingProvider = StateProvider<bool>((ref) => false);
final tempoProvider = StateProvider<double>((ref) => 120.0);
final selectedScaleProvider = StateProvider<String>((ref) => 'C Major');
final performanceModeProvider = StateProvider<PerformanceMode>((ref) => PerformanceMode.character);

enum PerformanceMode { character, timing }

class PerformancePage extends ConsumerWidget {
  const PerformancePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isRecording = ref.watch(isRecordingProvider);
    final tempo = ref.watch(tempoProvider);
    final selectedScale = ref.watch(selectedScaleProvider);
    final performanceMode = ref.watch(performanceModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('演奏'),
        actions: [
          IconButton(
            icon: Icon(
              isRecording ? Icons.stop_circle : Icons.fiber_manual_record,
              color: isRecording ? AppColors.error : AppColors.primary,
              size: 28.sp,
            ),
            onPressed: () {
              ref.read(isRecordingProvider.notifier).state = !isRecording;
            },
          ),
          SizedBox(width: 8.w),
        ],
      ),
      body: Column(
        children: [
          // Settings Panel
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.surfaceDark
                  : AppColors.surfaceLight,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Tempo Control
                Row(
                  children: [
                    Icon(Icons.speed, size: 20.sp),
                    SizedBox(width: 8.w),
                    Text(
                      'テンポ: ${tempo.toInt()} BPM',
                      style: TextStyle(fontSize: 14.sp),
                    ),
                    Expanded(
                      child: Slider(
                        value: tempo,
                        min: 60,
                        max: 200,
                        divisions: 140,
                        onChanged: (value) {
                          ref.read(tempoProvider.notifier).state = value;
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                // Performance Mode Toggle
                Row(
                  children: [
                    Expanded(
                      child: _ModeButton(
                        label: '文字モード',
                        isSelected: performanceMode == PerformanceMode.character,
                        onTap: () {
                          ref.read(performanceModeProvider.notifier).state = 
                              PerformanceMode.character;
                        },
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: _ModeButton(
                        label: 'タイミングモード',
                        isSelected: performanceMode == PerformanceMode.timing,
                        onTap: () {
                          ref.read(performanceModeProvider.notifier).state = 
                              PerformanceMode.timing;
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Lyrics Display Area
          Expanded(
            child: Container(
              margin: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.cardDark
                    : AppColors.cardLight,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: AppColors.primary.withOpacity(0.3),
                ),
              ),
              child: LyricsDisplay(
                performanceMode: performanceMode,
                isRecording: isRecording,
              ),
            ),
          ),
          
          // Piano Keyboard
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.surfaceDark
                  : AppColors.surfaceLight,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'ピアノ ($selectedScale)',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.undo),
                            onPressed: isRecording ? () {
                              // Undo last note
                            } : null,
                            iconSize: 20.sp,
                          ),
                          IconButton(
                            icon: const Icon(Icons.settings),
                            onPressed: () {
                              // Show scale settings
                            },
                            iconSize: 20.sp,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                PianoKeyboard(
                  scale: selectedScale,
                  isEnabled: isRecording,
                  onKeyPressed: (note) {
                    // Handle note press
                  },
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ModeButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ModeButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : AppColors.textSecondary,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: isSelected
                  ? Colors.white
                  : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}