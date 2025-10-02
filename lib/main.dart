import 'package:flutter/foundation.dart' show kIsWeb; // <-- Bunu ekledik
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:zoozy/screens/login_page.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart'; // <-- Bunu ekledik

// Web için GoogleSignIn
final GoogleSignIn googleSignIn = GoogleSignIn(
  clientId: "301880499217-webab6f352ce3c0e0df43a5b0.apps.googleusercontent.com",
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
      appId: "1:301880499217:web:ab6f352ce3c0e0df43a5b0",
    ),
  );

  // 🔹 Web için Facebook SDK başlat
  if (kIsWeb) {
    await FacebookAuth.i.webAndDesktopInitialize(
      appId: "2324446061343469",
      cookie: true,
      xfbml: true,
      version: "v15.0",
    );

    if (!FacebookAuth.i.isWebSdkInitialized) {
      print("Facebook Web SDK başlatılamadı!");
    } else {
      print("Facebook Web SDK başarıyla başlatıldı.");
    }
  }

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
