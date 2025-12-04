import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:zoozy/screens/explore_screen.dart';
import 'package:zoozy/screens/login_page.dart';
import 'package:zoozy/screens/owner_Login_Page.dart';

class PrivacyPolicyPage extends StatefulWidget {
  /// Yeni parametre: Sayfanın bir "onay" akışının parçası mı (örneğin ilk girişte)
  /// yoksa sadece bir "bilgilendirme" (örneğin SettingsScreen'den çağrıldığında) mi olduğunu belirtir.
  final bool isModal;

  const PrivacyPolicyPage({super.key, this.isModal = true});

  @override
  State<PrivacyPolicyPage> createState() => _PrivacyPolicyPageState();
}

class _PrivacyPolicyPageState extends State<PrivacyPolicyPage> {
  // Checkbox durumu (sadece isModal == true olduğunda aktif)
  bool isChecked = false;

  // 1️⃣ Arka plan (Gradient)
  Widget _buildBackground() {
    return Container(
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
    );
  }

  // 2️⃣ Üst başlık
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          const Text(
            'Gizlilik Politikası',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  // 3️⃣ Politika metni
  Widget _buildPolicyText(double fontSize) {
    return RichText(
      textAlign: TextAlign.justify,
      text: TextSpan(
        style: TextStyle(
          fontSize: fontSize,
          color: Colors.black87,
          height: 1.6,
          letterSpacing: 0.2,
        ),
        children: const [
          TextSpan(
            text:
                "PetBacker.com (“PetBacker”) gizliliğinize değer verir. Bu Gizlilik Politikası, "
                "web sitemizi, iletişim sistemimizi veya mobil uygulamamızı (“Platform”) ziyaret ettiğinizde "
                "ve Platform'da sunulan hizmetleri kullandığınızda hangi bilgileri topladığımızı, "
                "bu bilgileri nasıl kullandığımızı ve ifşa ettiğimizi açıklar.\n\n",
          ),
          TextSpan(
            text: "1. Kişisel Bilgilerin Toplanması\n",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          TextSpan(
            text:
                "PetBacker, kullanıcılarından hesap oluşturma, rezervasyon yapma veya ma gibi "
                "etkileşimler sırasında kişisel bilgiler toplar. Bu bilgiler ad, e-posta adresi, telefon numarası, "
                "konum bilgisi gibi verileri içerebilir.\n\n",
          ),
          TextSpan(
            text: "2. Çerezler ve Takip Teknolojileri\n",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          TextSpan(
            text:
                "PetBacker, platform kullanımınızı analiz etmek ve size özel içerik sunmak için çerezler ve diğer "
                "takip teknolojilerini kullanabilir. Tarayıcı ayarlarından çerezleri reddedebilirsiniz, ancak bu "
                "durum bazı özelliklerin çalışmasını engelleyebilir.\n\n",
          ),
          TextSpan(
            text: "3. Bilgilerin Kullanımı\n",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          TextSpan(
            text:
                "Toplanan bilgiler, hizmetlerin iyileştirilmesi, rezervasyon süreçlerinin yönetimi ve kullanıcı "
                "deneyiminin kişiselleştirilmesi için kullanılır.\n\n",
          ),
          TextSpan(
            text: "4. Üçüncü Taraf Paylaşımları\n",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          TextSpan(
            text:
                "Kişisel bilgileriniz yalnızca yasal gereklilikler doğrultusunda veya hizmetin sağlanabilmesi için "
                "gerekli olduğunda üçüncü taraflarla paylaşılabilir.\n\n",
          ),
          TextSpan(
            text: "5. Güvenlik\n",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          TextSpan(
            text:
                "Kişisel bilgilerinizin güvenliği için endüstri standartlarında önlemler alınmaktadır. "
                "Ancak internet üzerinden yapılan hiçbir veri aktarımının %100 güvenliği garanti edilemez.\n\n",
          ),
          TextSpan(
            text:
                "Detaylı bilgi için lütfen PetBacker web sitesindeki tam gizlilik politikasını inceleyin.\n",
          ),
        ],
      ),
    );
  }

  // 4️⃣ Checkbox satırı (yalnızca isModal == true iken görünür)
  Widget _buildAcceptanceRow() {
    if (!widget.isModal) return const SizedBox.shrink();

    return Row(
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) =>
              ScaleTransition(scale: animation, child: child),
          child: Checkbox(
            key: ValueKey<bool>(isChecked),
            value: isChecked,
            activeColor: Colors.purple,
            onChanged: (bool? value) {
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
    );
  }

  // 5️⃣ Devam Et butonu (yalnızca isModal == true iken görünür)
  Widget _buildContinueButton(BuildContext context) {
    if (!widget.isModal) return const SizedBox.shrink();

    return GestureDetector(
      onTap: isChecked
          ? () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const OwnerLoginPage()),
                (route) => false,
              );
            }
          : null,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isChecked
                ? [Colors.purple, Colors.deepPurpleAccent]
                : [Colors.grey.shade400, Colors.grey.shade300],
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
              color: isChecked ? Colors.white : Colors.black54,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  // 6️⃣ İçerik kartı (responsive)
  Widget _buildContentBody() {
    return Expanded(
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
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: _buildPolicyText(fontSize),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildAcceptanceRow(),
                  const SizedBox(height: 12),
                  _buildContinueButton(context),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // 7️⃣ Ana yapı
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(),
          SafeArea(
            child: Column(
              children: [
                _buildHeader(context),
                const SizedBox(height: 16),
                _buildContentBody(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
