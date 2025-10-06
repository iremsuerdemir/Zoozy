import 'package:flutter/material.dart';
import 'package:zoozy/components/bottom_navigation_bar.dart';
import 'package:zoozy/screens/agreement_screen.dart';
import 'package:zoozy/screens/profile_screen.dart';

class JobsScreen extends StatelessWidget {
  const JobsScreen({super.key});

  // 🎨 Renk paleti
  static const Color primaryPurple = Color.fromARGB(255, 111, 79, 172);
  static const Color softPink = Color(0xFFF48FB1);
  static const Color cardIconBgColor = Color(0xFFF3E5F5);

  Widget _buildIconTextCard(IconData icon, String text) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: cardIconBgColor,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(icon, color: primaryPurple, size: 28),
        ),
        const SizedBox(height: 4),
        Text(
          text,
          style: const TextStyle(fontSize: 12, color: Colors.black54),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 50,
        title: const Row(
          children: [
            Icon(Icons.pets, color: primaryPurple, size: 28),
            SizedBox(width: 8),
            Text(
              "Zoozy",
              style: TextStyle(
                color: primaryPurple,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.chat_bubble_outline,
                    color: primaryPurple, size: 24),
                onPressed: () {},
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                //   Üst arka plan gradient
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [primaryPurple, softPink],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),

                //   Orta görsel
                Positioned(
                  left: screenWidth / 2 - 80,
                  top: 20,
                  child: Center(
                    child: Transform.scale(
                      scale: 1.3,
                      child: Image.asset(
                        'assets/images/jobs.png',
                        height: 160,
                        width: 160,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),

                //   Alt kısım: ikonlu kutular
                Positioned(
                  top: screenHeight * 0.25, // biraz aşağıda
                  left: screenWidth * 0.06,
                  right: screenWidth * 0.06,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildIconTextCard(Icons.list_alt, "İş Listeleri"),
                        _buildIconTextCard(Icons.calendar_month, "Takvim"),
                        _buildIconTextCard(Icons.pets, "Köpek Gezdir"),
                        _buildIconTextCard(Icons.help_outline, "Yardım"),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 100),

            //   Daire ikon
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: primaryPurple.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(Icons.pets, size: 60, color: primaryPurple),
              ),
            ),

            const SizedBox(height: 24),

            //   Bilgilendirme metni
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                "Birisi iş ilanı yayınladığında burada bilgilendirileceksiniz.\nBildirim almak için Backer olarak kaydolun.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  height: 1.4,
                ),
              ),
            ),

            const SizedBox(height: 24),

            //   Hizmet Sun butonu
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: primaryPurple,
                side: const BorderSide(color: primaryPurple, width: 1.5),
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AgreementScreen()),
                );
              },
              child: const Text(
                "HİZMET SUN",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),

      //   Alt menü çubuğu
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 3,
        selectedColor: primaryPurple,
        unselectedColor: Colors.grey[700]!,
        onTap: (index) {
          if (index == 3) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const JobsScreen()),
            );
          } else if (index == 4) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            );
          }
        },
      ),
    );
  }
}
