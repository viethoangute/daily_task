import 'package:daily_task/di/service_locator.dart';
import 'package:daily_task/presentation/splash/ui/splash_page.dart';
import 'package:daily_task/presentation/todo_page/ui/todo_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setupLocator();

  final isFirstLaunch = await checkFirstLaunch();

  runApp(MyApp(isFirstLaunch: isFirstLaunch));
}

Future<bool> checkFirstLaunch() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;

  if (isFirstLaunch) {
    await prefs.setBool('isFirstLaunch', false);
  }

  return isFirstLaunch;
}

class MyApp extends StatelessWidget {
  final bool isFirstLaunch;

  const MyApp({super.key, required this.isFirstLaunch});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: isFirstLaunch ? const SplashPage() : const TodoPage(),
    );
  }
}
