import 'package:flutter/material.dart';
import 'package:zoozy/screens/owner_login_page.dart';
import 'package:zoozy/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RegisterPage(),
    );
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController rePasswordController = TextEditingController();
  final TextEditingController referralController = TextEditingController();

  bool obscurePassword = true;
  bool obscureRePassword = true;

  String? emailError;
  String? usernameError;
  String? passwordError;
  String? rePasswordError;

  Future<void> _signInWithGoogle() async {
    try {
      // 1. GoogleSignIn paketini kullanmak yerine doğrudan Firebase'in
      //    GoogleAuthProvider'ını kullanın.
      GoogleAuthProvider googleProvider = GoogleAuthProvider();

      // Web'de pop-up ile giriş yapılmasını sağlayan metot.
      // Bu, Firebase'in kimlik bilgilerini doğru şekilde yakalamasını sağlar.
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithPopup(googleProvider);

      // Başarılı giriş sonrası yönlendirme
      if (!mounted) return;

      // Kullanıcının kayıt olma ekranından sonra gitmesi gereken yer HomeScreen()
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } on FirebaseAuthException catch (e) {
      // Firebase özel hatalarını yakala (Örn: Hesap zaten var, vs.)
      print('Firebase Google Sign-In Hatası: ${e.code} - ${e.message}');
      if (!mounted) return;

      String errorMessage = 'Google ile giriş başarısız: ${e.message}';
      if (e.code == 'popup-closed-by-user') {
        errorMessage = 'Giriş penceresi kullanıcı tarafından kapatıldı.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } catch (e) {
      // Diğer genel hataları yakala
      print('Genel Google Sign-In Hatası: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Google ile giriş sırasında beklenmeyen bir hata oluştu!')),
      );
    }
  }

  // FACEBOOK İLE GİRİŞ (Google yapısına uygun olarak eklendi)
  Future<void> _signInWithFacebook() async {
    try {
      // flutter_facebook_auth paketi, web ve mobil akışını otomatik yönetir.
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
      );

      if (result.status == LoginStatus.success) {
        // 1. Facebook'tan alınan jetonu al
        final AccessToken accessToken = result.accessToken!;

        // 2. Jetonu kullanarak Firebase Kimlik Bilgisi oluştur
        final credential = FacebookAuthProvider.credential(accessToken.token);

        // 3. Firebase ile giriş yap (signInWithCredential hem mobil hem web'de çalışır)
        final UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);

        // Başarılı giriş sonrası yönlendirme
        if (!mounted) return;

        // Kullanıcının kayıt olma ekranından sonra gitmesi gereken yer HomeScreen()
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else if (result.status == LoginStatus.cancelled) {
        // Kullanıcı pencereyi kapattı (Hata yerine uyarı gösterilir)
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Facebook ile giriş iptal edildi.')),
        );
      } else {
        // Facebook'tan dönen diğer hatalar
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Facebook giriş başarısız: ${result.message}')),
        );
      }
    } on FirebaseAuthException catch (e) {
      // Firebase özel hataları (Örn: Hesap zaten var)
      print('Firebase Facebook Sign-In Hatası: ${e.code} - ${e.message}');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Firebase Facebook Hatası: ${e.message}')),
      );
    } catch (e) {
      // Diğer genel hatalar
      print('Genel Facebook Sign-In Hatası: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Facebook ile giriş sırasında beklenmeyen bir hata oluştu!')),
      );
    }
  }

  bool isFormValid() {
    return emailError == null &&
        usernameError == null &&
        passwordError == null &&
        rePasswordError == null &&
        emailController.text.isNotEmpty &&
        usernameController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        rePasswordController.text.isNotEmpty;
  }

  void validateForm() {
    emailError = null;
    usernameError = null;
    passwordError = null;
    rePasswordError = null;

    if (emailController.text.isEmpty) {
      emailError = "Email boş bırakılamaz";
    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(emailController.text)) {
      emailError = "Geçersiz email formatı";
    }

    if (usernameController.text.isEmpty) {
      usernameError = "Kullanıcı adı boş bırakılamaz";
    }

    if (passwordController.text.isEmpty) {
      passwordError = "Şifre boş bırakılamaz";
    } else if (passwordController.text.length < 6) {
      passwordError = "Şifre en az 6 karakter olmalı";
    }

    if (rePasswordController.text.isEmpty) {
      rePasswordError = "Lütfen şifreyi tekrar girin";
    } else if (rePasswordController.text != passwordController.text) {
      rePasswordError = "Şifreler eşleşmiyor";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFB2A4FF), Color(0xFFFFC1C1)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back,
                            color: Colors.white, size: 28),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      const Text(
                        'Kayıt Ol',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: emailController,
                    hintText: 'Email',
                    errorText: emailError,
                  ),
                  const SizedBox(height: 15),
                  _buildTextField(
                    controller: usernameController,
                    hintText: 'Kullanıcı Adı',
                    errorText: usernameError,
                  ),
                  const SizedBox(height: 15),
                  _buildTextField(
                    controller: passwordController,
                    hintText: 'Şifre',
                    obscureText: obscurePassword,
                    errorText: passwordError,
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          obscurePassword = !obscurePassword;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 15),
                  _buildTextField(
                    controller: rePasswordController,
                    hintText: 'Şifreyi Tekrar Gir',
                    obscureText: obscureRePassword,
                    errorText: rePasswordError,
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscureRePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          obscureRePassword = !obscureRePassword;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 15),
                  _buildTextField(
                    controller: referralController,
                    hintText: 'Davet Kodu (Opsiyonel)',
                    prefixIcon: const Icon(
                      Icons.card_giftcard,
                      color: Color(0xFF7A4FAD),
                    ),
                  ),
                  const SizedBox(height: 25),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          validateForm();
                        });
                        if (isFormValid()) {
                          // Home Page veya diğer ekran yönlendirme işlemi
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isFormValid()
                            ? const Color(0xFF7A4FAD)
                            : const Color.fromARGB(255, 246, 243, 247),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(
                            color: Color(0xFF7A4FAD),
                            width: 2,
                          ),
                        ),
                      ),
                      child: Text(
                        'Kayıt Ol',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isFormValid() ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Ya da şunlarla devam et',
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: _signInWithFacebook,
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: Center(
                            child: Image.network(
                              "https://upload.wikimedia.org/wikipedia/commons/0/05/Facebook_Logo_%282019%29.png",
                              width: 45,
                              height: 45,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      InkWell(
                        onTap: _signInWithGoogle, // Google Sign-In bağlandı
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Image.network(
                              "https://cdn-icons-png.flaticon.com/512/300/300221.png",
                              width: 45,
                              height: 45,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const OwnerLoginPage(),
                        ),
                      );
                    },
                    child: RichText(
                      text: const TextSpan(
                        text: 'Zaten bir hesabınız var mı? ',
                        style: TextStyle(color: Colors.white),
                        children: [
                          TextSpan(
                            text: 'Giriş Yap',
                            style: TextStyle(
                              color: Color(0xFF7A4FAD),
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    bool obscureText = false,
    Widget? prefixIcon,
    Widget? suffixIcon,
    String? errorText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          obscureText: obscureText,
          onChanged: (value) {
            setState(() {
              validateForm();
            });
          },
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 18,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 5, left: 5),
            child: Text(
              errorText,
              style: const TextStyle(color: Colors.red, fontSize: 13),
            ),
          ),
      ],
    );
  }
}
