import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'constants/app_colors.dart';
import 'state/app_state.dart';
import 'screens/auth/auth_screen.dart';
import 'screens/main_nav_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
  } catch (e) {
    debugPrint("Firebase init exception: $e");
    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp();
      }
    } catch (_) {}
  }

  runApp(const VegBoxApp());
}

class VegBoxApp extends StatelessWidget {
  const VegBoxApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppState();

    return AnimatedBuilder(
      animation: appState,
      builder: (context, _) {
        return MaterialApp(
          title: 'VegBox - Organik & Segar',
          debugShowCheckedModeBanner: false,
          themeMode: appState.themeMode,
          // Light Theme
          theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.light,
            fontFamily: 'Poppins',
            scaffoldBackgroundColor: AppColors.bgLight,
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.primary,
              primary: AppColors.primary,
              secondary: AppColors.primaryMint,
              surface: AppColors.surfaceLight,
              brightness: Brightness.light,
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: AppColors.bgLight,
              surfaceTintColor: Colors.transparent,
              elevation: 0,
              iconTheme: IconThemeData(color: AppColors.textDark),
              titleTextStyle: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: AppColors.textDark,
              ),
            ),
          ),
          // Dark Theme
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            fontFamily: 'Poppins',
            scaffoldBackgroundColor: AppColors.bgDark,
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.primaryMint,
              primary: AppColors.primaryMint,
              secondary: AppColors.primaryLight,
              surface: AppColors.surfaceDark,
              brightness: Brightness.dark,
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: AppColors.bgDark,
              surfaceTintColor: Colors.transparent,
              elevation: 0,
              iconTheme: IconThemeData(color: AppColors.textLight),
              titleTextStyle: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: AppColors.textLight,
              ),
            ),
          ),
          // If logged in -> MainNavScreen, otherwise -> AuthScreen
          home: appState.isLoggedIn
              ? const MainNavScreen()
              : const AuthScreen(),
        );
      },
    );
  }
}
