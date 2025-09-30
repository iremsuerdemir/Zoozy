import 'package:flutter/material.dart';
import 'package:zoozy/screens/login_page.dart';
import 'package:zoozy/screens/owner_login_page.dart';
import 'package:zoozy/screens/privacy_policy_page.dart';
import 'package:zoozy/screens/terms_of_service_page.dart';
import 'package:zoozy/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Zoozy App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      // Burada ilk açılacak ekranı ayarlıyorsun
      home: LoginPage(),
    );
  }
}
