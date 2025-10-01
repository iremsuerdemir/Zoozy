import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:zoozy/screens/forgot_password.dart';
import 'package:zoozy/screens/home_screen.dart';
import 'package:zoozy/screens/privacy_policy_page.dart';
import 'package:zoozy/screens/register_page.dart';
import 'package:zoozy/screens/terms_of_service_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class OwnerLoginPage extends StatefulWidget {
  const OwnerLoginPage({super.key});

  @override
  State<OwnerLoginPage> createState() => _OwnerLoginPageState();
}

class _OwnerLoginPageState extends State<OwnerLoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  void _login() async {
    if (_formKey.currentState!.validate()) {
      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();

      try {
        // Firebase ile gerçek kimlik doğrulama işlemi
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Başarılı giriş
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Giriş başarılı! Sayfaya yönlendiriliyorsunuz..."),
            backgroundColor: Colors.green,
          ),
        );

        // 4 saniye bekletme ve yönlendirme
        await Future.delayed(const Duration(seconds: 4));

        if (mounted) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const HomeScreen()));
        }
      } on FirebaseAuthException catch (e) {
        // Kimlik doğrulama hatalarını yakala ve kullanıcıya göster
        String message;
        if (e.code == 'user-not-found') {
          message = 'Bu e-posta adresiyle kayıtlı kullanıcı bulunamadı.';
        } else if (e.code == 'wrong-password') {
          message = 'Yanlış şifre. Lütfen tekrar deneyin.';
        } else {
          message = 'Giriş hatası';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.red,
          ),
        );
      } catch (e) {
        // Diğer bilinmeyen hatalar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Bilinmeyen bir hata oluştu: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Facebook Sign In
  Future<void> _signInWithFacebook() async {
    try {
      // 1. Facebook ile giriş yap
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'], // İstenen izinler
      );

      if (result.status == LoginStatus.success) {
        // Facebook'tan alınan kimlik bilgilerini al
        final AccessToken accessToken = result.accessToken!;

        // 2. Firebase kimlik bilgisi oluştur
        final credential = FacebookAuthProvider.credential(accessToken.token);

        // 3. Firebase ile giriş yap
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);

        // Başarılı giriş bildirimi
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Facebook ile giriş başarılı! Hoşgeldiniz ${userCredential.user?.displayName ?? ""}",
              ),
              backgroundColor: Colors.green,
            ),
          );

          // Ana sayfaya yönlendirme
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const HomeScreen()));
        }
      } else if (result.status == LoginStatus.cancelled) {
        // Kullanıcı girişi iptal etti
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Facebook ile giriş iptal edildi."),
              backgroundColor: Colors.orange,
            ),
          );
        }
      } else {
        // Giriş başarısız
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Facebook ile giriş başarısız: ${result.message}"),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      // Bilinmeyen hata
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Facebook ile giriş sırasında hata oluştu: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Google Sign-In İşlemi
  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        // Kullanıcı girişten vazgeçti
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Google ile giriş başarılı! Hoşgeldiniz ${userCredential.user?.displayName ?? ""}",
          ),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => HomeScreen()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Google ile giriş başarısız: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Padding(
          padding: EdgeInsets.only(top: 25.0),
          child: Text(
            "Giriş Yap",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(top: 25.0),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      body: Container(
        height: screenHeight,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFB2A4FF), Color(0xFFFFC1C1)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            20,
            MediaQuery.of(context).padding.top +
                AppBar().preferredSize.height +
                28,
            20,
            MediaQuery.of(context).padding.bottom + 20,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                // Email
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: "E-posta",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Lütfen e-posta adresinizi girin.';
                    }
                    if (!RegExp(
                      r'^[\w-.]+@([\w-]+\.)+[\w]{2,4}$',
                    ).hasMatch(value)) {
                      return 'Geçerli bir e-posta adresi girin.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                // Password
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    hintText: "Şifre",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: const Color(0xFF7A4FAD),
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Lütfen şifrenizi girin.';
                    }
                    if (value.trim().length < 6) {
                      return 'Şifre en az 6 karakter olmalıdır.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                // Login Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7A4FAD),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: _login,
                    child: const Text(
                      "E-posta ile Giriş Yap",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                // Forgot Password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ForgotPassword(),
                        ),
                      );
                    },
                    child: const Text(
                      "Şifrenizi mi unuttunuz?",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Center(
                  child: Text(
                    "veya ile devam et",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 15),
                //  Facebook & Google Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: _signInWithFacebook, // Facebook
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
                      onTap: _signInWithGoogle, // 🔹 Google Sign-In
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Hesabınız yok mu? ",
                      style: TextStyle(color: Colors.white),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterPage(),
                          ),
                        );
                      },
                      child: const Text(
                        "Kayıt Ol",
                        style: TextStyle(
                          color: Color(0xFF7A4FAD),
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          decorationColor: Color(0xFF7A4FAD),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Text.rich(
                    TextSpan(
                      text: "Kayıt Ol veya Giriş Yap’a tıklayarak, ",
                      style: const TextStyle(color: Colors.black87),
                      children: [
                        TextSpan(
                          text: "Hizmet Şartları",
                          style: const TextStyle(
                            color: Color(0xFF7A4FAD),
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            decorationColor: Color(0xFF7A4FAD),
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const TermsOfServicePage(),
                                ),
                              );
                            },
                        ),
                        const TextSpan(text: " ve "),
                        TextSpan(
                          text: "Gizlilik Politikası’nı",
                          style: const TextStyle(
                            color: Color(0xFF7A4FAD),
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            decorationColor: Color(0xFF7A4FAD),
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const PrivacyPolicyPage(),
                                ),
                              );
                            },
                        ),
                        const TextSpan(text: " kabul etmiş oluyorum."),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
