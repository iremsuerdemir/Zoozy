import 'package:flutter/material.dart';
import 'package:zoozy/screens/owner_login_page.dart';

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
                  // Geri butonu + Kayıt başlığı
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      const SizedBox(width: 5),
                      const Text(
                        'Kayıt Ol',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Email
                  _buildTextField(
                    controller: emailController,
                    hintText: 'Email',
                    errorText: emailError,
                  ),
                  const SizedBox(height: 15),

                  // Kullanıcı Adı
                  _buildTextField(
                    controller: usernameController,
                    hintText: 'Kullanıcı Adı',
                    errorText: usernameError,
                  ),
                  const SizedBox(height: 15),

                  // Şifre
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

                  // Şifre Tekrar
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

                  // Davet Kodu
                  _buildTextField(
                    controller: referralController,
                    hintText: 'Davet Kodu (Opsiyonel)',
                    prefixIcon: const Icon(
                      Icons.card_giftcard,
                      color: Color(0xFF7A4FAD),
                    ),
                  ),
                  const SizedBox(height: 25),

                  // Kayıt Ol Butonu
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

                  // Sosyal Giriş Butonları (Facebook + Google)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {},
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
                        onTap: () {},
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

                  // Zaten hesabınız var mı? Giriş Yap
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
              validateForm(); // Her değişiklikte form geçerliliğini kontrol et
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
