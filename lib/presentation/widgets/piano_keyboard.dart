import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:melow_flutter/core/themes/app_colors.dart';

class PianoKeyboard extends StatelessWidget {
  final String scale;
  final bool isEnabled;
  final Function(String) onKeyPressed;

  const PianoKeyboard({
    super.key,
    required this.scale,
    required this.isEnabled,
    required this.onKeyPressed,
  });

  static const Map<String, List<String>> scales = {
    'C Major': ['C', 'D', 'E', 'F', 'G', 'A', 'B'],
    'G Major': ['G', 'A', 'B', 'C', 'D', 'E', 'F#'],
    'D Major': ['D', 'E', 'F#', 'G', 'A', 'B', 'C#'],
    'A Minor': ['A', 'B', 'C', 'D', 'E', 'F', 'G'],
    'E Minor': ['E', 'F#', 'G', 'A', 'B', 'C', 'D'],
  };

  @override
  Widget build(BuildContext context) {
    final notes = scales[scale] ?? scales['C Major']!;

    return Container(
      height: 180.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: notes.map((note) {
          return Expanded(
            child: _PianoKey(
              note: note,
              isEnabled: isEnabled,
              onPressed: () => onKeyPressed(note),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _PianoKey extends StatefulWidget {
  final String note;
  final bool isEnabled;
  final VoidCallback onPressed;

  const _PianoKey({
    required this.note,
    required this.isEnabled,
    required this.onPressed,
  });

  @override
  State<_PianoKey> createState() => _PianoKeyState();
}

class _PianoKeyState extends State<_PianoKey> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (!widget.isEnabled) return;
    setState(() => _isPressed = true);
    _controller.forward();
    widget.onPressed();
  }

  void _handleTapUp(TapUpDetails details) {
    if (!widget.isEnabled) return;
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  void _handleTapCancel() {
    if (!widget.isEnabled) return;
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final isBlackKey = widget.note.contains('#');
    
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 2.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: _isPressed
                      ? [AppColors.keyPressed, AppColors.keyPressed.withOpacity(0.8)]
                      : isBlackKey
                          ? [AppColors.blackKey, AppColors.blackKey.withOpacity(0.9)]
                          : [AppColors.whiteKey, Colors.white],
                ),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(8.r),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  widget.note,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: _isPressed
                        ? Colors.white
                        : isBlackKey
                            ? Colors.white
                            : AppColors.textDark,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}