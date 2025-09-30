import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:zoozy/screens/login_page.dart';

//  Web için GoogleSignIn
final GoogleSignIn googleSignIn = GoogleSignIn(
  clientId:
      "301880499217-webab6f352ce3c0e0df43a5b0.apps.googleusercontent.com", //  App ID'ye göre
  scopes: ['email'],
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase initialize
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyCxCjJKz8p4hDgYuzpSs27mCRGAmc8BFI4",
      authDomain: "zoozy-proje.firebaseapp.com",
      projectId: "zoozy-proje",
      storageBucket: "zoozy-proje.appspot.com",
      messagingSenderId: "301880499217",
      appId: "1:301880499217:web:ab6f352ce3c0e0df43a5b0", //  App ID
    ),
  );

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
      home: LoginPage(),
    );
  }
}
