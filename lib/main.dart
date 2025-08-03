import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:melow_flutter/presentation/pages/main_page.dart';
import 'package:melow_flutter/core/themes/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 必要な初期化処理
  await _initializeApp();
  
  runApp(
    const ProviderScope(
      child: MelowApp(),
    ),
  );
}

Future<void> _initializeApp() async {
  // データベースの初期化
  // 設定の読み込み
  // その他の初期化処理
}

class MelowApp extends ConsumerWidget {
  const MelowApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScreenUtilInit(
      designSize: const Size(390, 844), // iPhone 14 Pro
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return AdaptiveTheme(
          light: AppTheme.lightTheme,
          dark: AppTheme.darkTheme,
          initial: AdaptiveThemeMode.dark,
          builder: (theme, darkTheme) => MaterialApp(
            title: 'Melow',
            theme: theme,
            darkTheme: darkTheme,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('ja', 'JP'),
              Locale('en', 'US'),
            ],
            locale: const Locale('ja', 'JP'),
            home: const MainPage(),
            debugShowCheckedModeBanner: false,
          ),
        );
      },
    );
  }
}