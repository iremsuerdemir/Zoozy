import 'dart:developer';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// Sayfalar
import 'package:zoozy/screens/about_me_page.dart';
import 'package:zoozy/screens/add_location.dart';
import 'package:zoozy/screens/add_service_rate_page.dart'
    show AddServiceRatePageFromPrefs;
import 'package:zoozy/screens/board_note_page.dart';
import 'package:zoozy/screens/caregiverProfilPage.dart';
import 'package:zoozy/screens/describe_services_page.dart';
import 'package:zoozy/screens/groomer_note.dart';
import 'package:zoozy/screens/grooming_service_page.dart';
import 'package:zoozy/screens/help_center_page.dart';
import 'package:zoozy/screens/identification_document_page.dart';
import 'package:zoozy/screens/indexbox_message.dart';
import 'package:zoozy/screens/login_page.dart';
import 'package:zoozy/screens/my_badgets_screen.dart';
import 'package:zoozy/screens/my_cities_page.dart';
import 'package:zoozy/screens/owner_Login_Page.dart';
import 'package:zoozy/screens/password_forgot_screen.dart';
import 'package:zoozy/screens/profile_screen.dart';
import 'package:zoozy/screens/reguests_screen.dart';
import 'package:zoozy/screens/service_name_page.dart';
import 'package:zoozy/screens/services.dart';
import 'package:zoozy/screens/services_rates.dart';
import 'package:zoozy/screens/session_count_page.dart';
import 'package:zoozy/screens/settings_screen.dart';
import 'package:zoozy/screens/upload_photo_screen.dart';
import 'package:zoozy/screens/visit_type_page.dart';
import 'package:zoozy/screens/walk_count_page.dart';
import 'package:zoozy/screens/explore_screen.dart';
import 'package:zoozy/screens/confirm_phone_screen.dart';

//   GoogleSignIn
final GoogleSignIn googleSignIn = GoogleSignIn(
  clientId:
      "301880499217-ke43kqtvdpue274f5d4lmjnbbt0enorg.apps.googleusercontent.com",
  scopes: ['email'],
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase başlatma
  if (kIsWeb) {
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
  } else {
    await Firebase.initializeApp();
  }

  //   Tarih formatları & Türkçe ayarlar
  await initializeDateFormatting('tr_TR', null);

  //   Facebook Web için başlatma
  if (kIsWeb) {
    await FacebookAuth.i.webAndDesktopInitialize(
      appId: "2324446061343469",
      cookie: true,
      xfbml: true,
      version: "v15.0",
    );
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

      //   Uygulama dili zorunlu Türkçe
      locale: const Locale('tr', 'TR'),
      supportedLocales: const [Locale('tr', 'TR')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      //   İlk açılan sayfa
      home: LoginPage(),
      /*CaregiverProfilpage(
        displayName: "İrem Su Erdemir",
        userName: "iremsuerdemir",
        location: "Edirne, Türkiye",
        bio: "Hayvanları çok seven, profesyonel bakım sağlayıcı.",
        userPhoto: "https://cdn-icons-png.flaticon.com/512/194/194938.png",
      ),
*/
      routes: {
        '/addServiceRate': (context) => const AddServiceRatePageFromPrefs(),
        '/confirmPhone': (context) => const ConfirmPhoneScreen(),
        //   Diğer sayfalar gerektiğinde buraya eklenebilir
      },
    );
  }
}
