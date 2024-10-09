import 'package:client/utils/navigation.dart';
import 'package:client/firebase_options.dart';
import 'package:client/pages/home/home_page.dart';
import 'package:client/pages/intro/intro_page.dart';
import 'package:client/utils/theme.dart';
import 'package:client/utils/theme_notifier.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,

  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeNotifier(),
      child: const MyApp(),
    ),
  );
  FlutterNativeSplash.remove();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(builder: (context, themeNotifier, child) {
      return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: themeNotifier.isDarkMode ? darkTheme : lightTheme,
          home: FutureBuilder<bool>(
              future: checkFirstLaunch(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  final bool isFirstLaunch = snapshot.data ?? true;
                  return isFirstLaunch ? const IntroScreen() :  const HomeScreen();
                }
              },
              ),
              onGenerateRoute: Routes.generateRoute,
              );
    });
  }

  Future<bool> checkFirstLaunch() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;
    if (isFirstLaunch) {
      await prefs.setBool('isFirstLaunch', false);
    }
    return isFirstLaunch;
  }
} 