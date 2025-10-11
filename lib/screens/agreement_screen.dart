import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:zoozy/screens/jobs_screen.dart';
import 'package:zoozy/screens/services.dart';

// Madde işaretleri için özel widget
class BulletTextItem extends StatelessWidget {
  final Widget text;

  const BulletTextItem({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            '\u2022',
            style: TextStyle(
              fontSize: 16,
              height: 1.5,
              color: Colors.black87,
            ),
          ),
          const SizedBox(width: 8.0),
          Expanded(child: text),
        ],
      ),
    );
  }
}

class AgreementScreen extends StatefulWidget {
  const AgreementScreen({super.key});

  @override
  State<AgreementScreen> createState() => _AgreementScreenState();
}

class _AgreementScreenState extends State<AgreementScreen> {
  bool isChecked = false;

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
                // AppBar benzeri üst bar
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 28,
                        ),
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => JobsScreen())),
                      ),
                      const Text(
                        'Anlaşmalar',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Responsive içerik
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final double maxContentWidth =
                          math.min(constraints.maxWidth * 0.9, 900);
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
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Başlık ve resim
                                      Center(
                                        child: Image.asset(
                                          'assets/images/login_3.png',
                                          height: 150,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      Text(
                                        'Aşağıdaki koşulları anladığınızı kabul edersiniz:',
                                        style: TextStyle(
                                          fontSize: fontSize + 2,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 16),

                                      // Maddeler
                                      BulletTextItem(
                                        text: Text(
                                          '18 yaşından büyük olmanız, hayvanları sevmeniz ve daha önce evcil hayvan bakmış olmanız gerekmektedir.',
                                          style: TextStyle(fontSize: fontSize),
                                        ),
                                      ),
                                      const Divider(),
                                      BulletTextItem(
                                        text: Text(
                                          'Verilen tüm bilgiler doğru olmalıdır ve yüklenen fotoğraflar reklam için kullanıma uygun olmalıdır. Doğrulama amacıyla telefon numarası, kimlik ve e-posta sağlamanız gerekebilir. Gerekirse geçmiş kontroller yapılabilir ve şüpheli hesaplar kaldırılabilir.',
                                          style: TextStyle(fontSize: fontSize),
                                        ),
                                      ),
                                      const Divider(),
                                      BulletTextItem(
                                        text: RichText(
                                          text: TextSpan(
                                            style: TextStyle(
                                                color: Colors.black87,
                                                fontSize: fontSize,
                                                height: 1.5),
                                            children: const [
                                              TextSpan(
                                                text:
                                                    'Hizmetlerinizden gelir elde edebilirsiniz. Bir müşteri sizi işe aldığında kazancınız ',
                                              ),
                                              TextSpan(
                                                text: '%75 - %80',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              TextSpan(
                                                text:
                                                    ' arasında değişir. Eğer iletişim bilgileri önceden paylaşıldı ve hizmet platform dışı gerçekleştirildiyse, ',
                                              ),
                                              TextSpan(
                                                text: '%40',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xFFE53935)),
                                              ),
                                              TextSpan(
                                                text:
                                                    ' oranında bir ceza ödemeniz gerekebilir veya hesabınız geçici olarak askıya alınabilir. Cezanın bir kısmı hayvan barınaklarına bağışlanabilir.',
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const Divider(),
                                      BulletTextItem(
                                        text: Text(
                                          'Müşteri lehine bir anlaşmazlık söz konusu olduğunda, yeterli hizmet sağlayamadığınız takdirde alınan veya alınacak tüm ödemeleri geri ödemeyi kabul edersiniz.',
                                          style: TextStyle(fontSize: fontSize),
                                        ),
                                      ),
                                      const Divider(),
                                      BulletTextItem(
                                        text: RichText(
                                          text: TextSpan(
                                            style: TextStyle(
                                                color: Colors.black87,
                                                fontSize: fontSize,
                                                height: 1.5),
                                            children: const [
                                              TextSpan(
                                                  text:
                                                      'Siz platformun çalışanı değilsiniz, yalnızca hizmet sağlayan bir kullanıcı olarak sorumlusunuz. Acil durumlarda veya yerel kuralların ihlali durumunda tüm sorumluluk size aittir. Platform yalnızca '),
                                              TextSpan(
                                                  text: 'yardımcı olur',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              TextSpan(text: ' ve '),
                                              TextSpan(
                                                  text:
                                                      'hizmetleriniz için ödenen evcil hayvan sigortası',
                                                  style: TextStyle(
                                                      color: Color(0xFF673AB7),
                                                      decoration: TextDecoration
                                                          .underline)),
                                              TextSpan(
                                                  text:
                                                      ' ile veteriner masraflarını azaltır.'),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
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
                                  Expanded(
                                    child: Text(
                                      "Okudum, onayladım",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),

                              // Devam Et butonu
                              // Devam Et butonu
                              GestureDetector(
                                onTap: isChecked
                                    ? () {
                                        // Koşullar onaylandı, ServicesScreen'e yönlendir
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const Services(),
                                          ),
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
