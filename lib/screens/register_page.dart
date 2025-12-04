import 'package:flutter/material.dart';
import 'package:zoozy/screens/explore_screen.dart';
import 'package:zoozy/screens/owner_login_page.dart';
import 'package:zoozy/services/guest_access_service.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoozy/services/auth_service.dart';

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
  bool _isLoading = false;

  String? emailError;
  String? usernameError;
  String? passwordError;
  String? rePasswordError;

  final AuthService _authService = AuthService();

  /// BACKEND API ile Google kayıt/login
  Future<void> _signInWithGoogle() async {
    try {
      setState(() => _isLoading = true);

      final FirebaseAuth auth = FirebaseAuth.instance;
      final GoogleSignIn googleSignIn = GoogleSignIn();

      // Mobile ve Web arasında başlık kontrol
      if (Theme.of(context).platform == TargetPlatform.android ||
          Theme.of(context).platform == TargetPlatform.iOS) {
        final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
        if (googleUser == null) {
          setState(() => _isLoading = false);
          return;
        }

        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        await auth.signInWithCredential(credential);
      } else {
        // Web için
        GoogleAuthProvider googleProvider = GoogleAuthProvider();
        googleProvider
          ..addScope('email')
          ..addScope('profile');

        await auth.signInWithPopup(googleProvider);
      }

      final user = auth.currentUser;

      if (user != null && mounted) {
        // Backend API'ye Google bilgilerini gönder
        final response = await _authService.googleLogin(
          firebaseUid: user.uid,
          email: user.email ?? '',
          displayName: user.displayName ?? 'Kullanıcı',
          photoUrl: user.photoURL,
        );

        if (response.success && response.user != null) {
          // SharedPreferences kaydı
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('username', response.user!.displayName);
          await prefs.setString('email', response.user!.email.toLowerCase());
          await prefs.setString('firebaseUid', user.uid);
          await GuestAccessService.disableGuestMode();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Hoş geldiniz ${response.user!.displayName}!",
              ),
              backgroundColor: Colors.green,
            ),
          );

          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ExploreScreen()),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Google ile giriş başarısız: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
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

  /// BACKEND API ile kayıt
  void _register() async {
    setState(() => validateForm());

    if (isFormValid()) {
      setState(() => _isLoading = true);

      try {
        // Backend API'ye kayıt isteği
        final response = await _authService.register(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
          displayName: usernameController.text.trim(),
        );

        if (!mounted) return;

        if (response.success && response.user != null) {
          // SharedPreferences kaydı
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('username', response.user!.displayName);
          await prefs.setString('email', response.user!.email.toLowerCase());
          await GuestAccessService.disableGuestMode();

          if (mounted) {
            // Kayıt başarılı green snackbar göster
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                    'Kayıt başarılı! Giriş yap ekranına yönlendiriliyorsunuz...'),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 2),
              ),
            );

            // 2 saniye sonra OwnerLoginPage'e yönlendir
            await Future.delayed(const Duration(seconds: 2));

            if (mounted) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const OwnerLoginPage()),
              );
            }
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Hata: $e"),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
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
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 28,
                        ),
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
                      onPressed: _isLoading ? null : _register,
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
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                              'Kayıt Ol',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color:
                                    isFormValid() ? Colors.white : Colors.black,
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
                  InkWell(
                    onTap: _isLoading ? null : _signInWithGoogle,
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
          onChanged: (_) => setState(() => validateForm()),
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
