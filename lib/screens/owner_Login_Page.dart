import 'package:flutter/material.dart';

class OwnerLoginPage extends StatefulWidget {
  const OwnerLoginPage({super.key});

  @override
  State<OwnerLoginPage> createState() => _OwnerLoginPageState();
}

class _OwnerLoginPageState extends State<OwnerLoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    // 1. Ekran boyutunu alıyoruz.
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      // AppBar'ın arkasındaki gövdenin uzamasını sağlıyoruz.
      extendBodyBehindAppBar: true,

      appBar: AppBar(
        backgroundColor: Colors.transparent, // ✅ Şeffaf AppBar
        elevation: 0,

        centerTitle: true,

        title: Padding(
          padding: EdgeInsets.only(top: 25.0),
          child: const Text(
            "Giriş Yap",
            style: TextStyle(
              color: Colors.white, // ✅ Gradient arkaplana uygun
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
            // Ekran görüntüsündeki gibi mor ve pembeye yakın tonlar
            colors: [Color(0xFFB2A4FF), Color(0xFFFFC1C1)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        child: SingleChildScrollView(
          // Ekranın en üstündeki AppBar altından ve en alttaki çubuktan (eğer varsa)
          // korunmak için padding ekliyoruz.
          padding: EdgeInsets.fromLTRB(
            20,
            MediaQuery.of(context).padding.top +
                AppBar().preferredSize.height +
                28, // Top padding: status bar + appbar
            20,
            MediaQuery.of(context).padding.bottom +
                20, // Bottom padding: bottom safe area + extra space
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),

              // Email TextField
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: "E-posta",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 15),

              // Password TextField
              TextField(
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
                      color: const Color(0xFF7A4FAD), // Göz simgesi rengi
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
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
                  onPressed: () {},
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
                  onPressed: () {},
                  child: Text(
                    "Şifrenizi mi unuttunuz?",
                    style: TextStyle(
                      color: Colors.white,

                      fontWeight: FontWeight.w500, // Daha az kalın
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Center(
                child: Text(
                  "veya ile devam et",
                  style: TextStyle(color: Colors.white), // Daha yumuşak beyaz
                ),
              ),
              const SizedBox(height: 15),

              // Facebook & Google Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Facebook Button
                  InkWell(
                    onTap: () {
                      // Facebook login logic
                    },
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
                  // Google Button
                  InkWell(
                    onTap: () {
                      // Google login logic
                    },
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
                    onTap: () {},
                    child: const Text(
                      "Kayıt Ol",
                      style: TextStyle(
                        color: const Color(0xFF7A4FAD),
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        decorationColor: const Color(0xFF7A4FAD),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              // Terms & Privacy
              Container(
                width: double.infinity, // Ekranı tam kaplaması için
                padding: const EdgeInsets.all(12),
                // margin: const EdgeInsets.only(top: 10, bottom: 20),
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
                    children: const [
                      TextSpan(
                        text: "Hizmet Şartları",
                        style: TextStyle(
                          color: Color(0xFF7A4FAD), // Mor ton
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          decorationColor: Color(0xFF7A4FAD),
                        ),
                      ),
                      TextSpan(
                        text: " ve ",
                        style: TextStyle(color: Colors.black87),
                      ),
                      TextSpan(
                        text: "Gizlilik Politikası’nı",
                        style: TextStyle(
                          color: Color(0xFF7A4FAD), // Mor ton
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          decorationColor: Color(0xFF7A4FAD),
                        ),
                      ),
                      TextSpan(
                        text: " kabul etmiş oluyorum.",
                        style: TextStyle(color: Colors.black87),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              // Alttaki beyaz boşluğu önlemek için gerekli olabilir
              // const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
