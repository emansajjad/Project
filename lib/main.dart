import 'package:flutter/material.dart';
//import 'package:my_fyp/homeScreen.dart';
import 'package:my_fyp/splashScreen.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'FYP Project',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // Set the color scheme to use your custom color.
          colorScheme: ColorScheme.fromSeed(
            seedColor:
                const Color.fromARGB(255, 83, 99, 182), // Custom primary color
          ).copyWith(
            primary: const Color.fromARGB(
                255, 83, 99, 182), // Apply custom color as primary
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color.fromARGB(255, 83, 99, 182),
          ),
          textTheme: const TextTheme(
            bodyLarge: TextStyle(
                color: Color.fromARGB(255, 83, 99, 182)), // Text color for body
          ),
          useMaterial3: true,
        ),
        home: SplashScreen());
  }
}
