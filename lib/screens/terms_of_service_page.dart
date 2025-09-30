import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:zoozy/screens/home_screen.dart';
import 'package:zoozy/screens/owner_login_page.dart';
import 'package:zoozy/screens/privacy_policy_page.dart';

class TermsOfServicePage extends StatefulWidget {
  const TermsOfServicePage({super.key});

  @override
  State<TermsOfServicePage> createState() => _TermsOfServicePageState();
}

class _TermsOfServicePageState extends State<TermsOfServicePage> {
  bool isChecked = false;

  final String termsText = """
PetBacker hizmetlerini kullanarak aşağıdaki şartları kabul etmiş sayılırsınız. 
Lütfen bu şartları dikkatlice okuyun. Bu metin, kullanıcı ile PetBacker arasında bir sözleşme niteliğindedir.

1. Hizmetin Tanımı  
PetBacker, evcil hayvan sahiplerini ve hizmet sağlayıcıları bir araya getiren bir platformdur. 
Sağlanan hizmetler, PetBacker tarafından doğrudan verilmez, üçüncü taraf sağlayıcılar tarafından sunulur.

2. Kullanıcı Yükümlülükleri  
Kullanıcılar, sağladıkları bilgilerin doğru ve güncel olduğunu beyan eder. 
Platformun kötüye kullanılması durumunda, hesap kalıcı olarak askıya alınabilir.

3. Ödeme ve İptal  
Ödemeler, PetBacker tarafından güvenli bir şekilde işlenir. 
İptal politikaları, ilgili hizmet sağlayıcının belirlediği kurallara göre uygulanır.

4. Sorumluluk Reddi  
PetBacker, hizmet sağlayıcıların eylemlerinden veya sunulan hizmetlerin kalitesinden sorumlu değildir.

5. Gizlilik  
Kullanıcı bilgileri, Gizlilik Politikası çerçevesinde korunur ve üçüncü taraflarla yalnızca gerekli durumlarda paylaşılır.
""";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gradient arka plan
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFB39DDB), // Açık mor
                  Color(0xFFF48FB1), // Açık pembe
                ],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // Üst başlık
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        "Hizmet Şartları",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Responsive içerik alanı
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final double maxContentWidth = math.min(
                        constraints.maxWidth * 0.9,
                        900,
                      );

                      final double fontSize = constraints.maxWidth > 1000
                          ? 18
                          : (constraints.maxWidth < 360 ? 14 : 16);

                      return Center(
                        child: Container(
                          width: maxContentWidth,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                spreadRadius: 2,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              // Scrollable metin
                              Expanded(
                                child: SingleChildScrollView(
                                  physics: const BouncingScrollPhysics(),
                                  child: SelectableText(
                                    termsText,
                                    textAlign: TextAlign.justify,
                                    style: TextStyle(
                                      fontSize: fontSize,
                                      color: Colors.black87,
                                      height: 1.6,
                                      letterSpacing: 0.2,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Checkbox satırı
                              Row(
                                children: [
                                  AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 300),
                                    transitionBuilder: (child, animation) =>
                                        ScaleTransition(
                                          scale: animation,
                                          child: child,
                                        ),
                                    child: Checkbox(
                                      key: ValueKey<bool>(isChecked),
                                      value: isChecked,
                                      activeColor: Colors.purple,
                                      onChanged: (value) {
                                        setState(() {
                                          isChecked = value ?? false;
                                        });
                                      },
                                    ),
                                  ),
                                  const Expanded(
                                    child: Text(
                                      "Okudum, onayladım",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),

                              // Devam Et butonu
                              GestureDetector(
                                onTap: isChecked
                                    ? () {
                                        Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const PrivacyPolicyPage(),
                                          ),
                                          (route) => false,
                                        );
                                      }
                                    : null,
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: isChecked
                                          ? [
                                              Colors.purple,
                                              Colors.deepPurpleAccent,
                                            ]
                                          : [
                                              Colors.grey.shade400,
                                              Colors.grey.shade300,
                                            ],
                                    ),
                                    borderRadius: BorderRadius.circular(14),
                                    boxShadow: [
                                      if (isChecked)
                                        const BoxShadow(
                                          color: Colors.purpleAccent,
                                          blurRadius: 8,
                                          offset: Offset(0, 4),
                                        ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Devam Et",
                                      style: TextStyle(
                                        color: isChecked
                                            ? Colors.white
                                            : Colors.black54,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
