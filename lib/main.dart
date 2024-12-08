import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'helpers/state_manager.dart';
import 'package:permission_handler/permission_handler.dart';
import 'screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await requestMicrophonePermission();
  runApp(MyApp());
}

Future<void> requestMicrophonePermission() async {
  var status = await Permission.microphone.status;
  if (status
      .isDenied) {
    await Permission.microphone.request();
  } else if (status
      .isPermanentlyDenied) {
    await openAppSettings();
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
      NewsProvider()
        ..loadTheme(),
      child: Consumer<NewsProvider>(
        builder: (context, newsProvider, child) {
          return MaterialApp(
            title: 'News Lenz',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                backgroundColor: Colors.white,
                selectedItemColor: Colors.blue,
                unselectedItemColor: Colors.grey,
              ),
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              primarySwatch: Colors.blue,
              bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                backgroundColor: Colors.black,
                selectedItemColor: Colors.white,
                unselectedItemColor:
                Colors.white70,
              ),
            ),
            themeMode:
            newsProvider.isDarkTheme ? ThemeMode.dark : ThemeMode.light,
            home: const MainScreen(),
          );
        },
      ),
    );
  }
}
