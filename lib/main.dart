import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart'; // provider paketi eklendi
import 'package:zoozy/providers/pet_provider.dart'; // pets provider importu eklendi
import 'package:zoozy/screens/add_service_rate_page.dart'
    show AddServiceRatePageFromPrefs;
import 'package:zoozy/screens/confirm_phone_screen.dart';
import 'package:zoozy/screens/login_page.dart';

final GoogleSignIn googleSignIn = GoogleSignIn(
  clientId:
      "301880499217-ke43kqtvdpue274f5d4lmjnbbt0enorg.apps.googleusercontent.com",
  scopes: ['email'],
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyCxCjJKz8p4hDgYuzpSs27mCRGAmc8BFI4",
      authDomain: "zoozy-proje.firebaseapp.com",
      projectId: "zoozy-proje",
      storageBucket: "zoozy-proje.appspot.com",
      messagingSenderId: "301880499217",
      appId: "1:301880499217:web:ab6f352ce3c0e0df43a5b0",
      measurementId: "G-KKZ5HXFDFD",
    ),
  );

  await initializeDateFormatting('tr_TR', null);

  if (kIsWeb) {
    await FacebookAuth.i.webAndDesktopInitialize(
      appId: "2324446061343469",
      cookie: true,
      xfbml: true,
      version: "v15.0",
    );
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => PetsProvider()), // burada provider tanımlanıyor
      ],
      child: const MyApp(),
    ),
  );
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
      locale: const Locale('tr', 'TR'),
      supportedLocales: const [Locale('tr', 'TR')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const LoginPage(), // burada da const önerilir
      routes: {
        '/addServiceRate': (context) => const AddServiceRatePageFromPrefs(),
        '/confirmPhone': (context) => const ConfirmPhoneScreen(),
      },
    );
  }
}
