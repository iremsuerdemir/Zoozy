import 'package:flutter/material.dart';
import 'package:zoozy/components/bottom_navigation_bar.dart';
import 'package:zoozy/components/help_card.dart';
import 'package:zoozy/models/help_item.dart';
import 'package:zoozy/screens/support_request.page.dart';
import 'package:zoozy/screens/faq_page.dart';
import 'package:zoozy/screens/privacy_policy_page.dart';
import 'package:zoozy/screens/terms_of_service_page.dart';

class HelpCenterPage extends StatelessWidget {
  const HelpCenterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<HelpItem> helpItems = [
      HelpItem(
        icon: Icons.mail_outline,
        title: 'SSS',
        description: 'Sıkça sorulan soruları inceleyin.',
        action: () async {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const FaqPage()),
          );
        },
      ),
      HelpItem(
        icon: Icons.mail_outline,
        title: 'Destek Talebi',
        description: 'Bize ulaşın, sorununuzu bildirin.',
        action: () async {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SupportRequestPage()),
          );
        },
      ),
      HelpItem(
        icon: Icons.policy_outlined,
        title: 'Gizlilik Politikası',
        description: 'Verilerinizin nasıl korunduğunu öğrenin.',
        action: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const PrivacyPolicyPage(isModal: false),
            ),
          );
        },
      ),
      HelpItem(
        icon: Icons.article_outlined,
        title: 'Kullanım Koşulları',
        description: 'Hizmet şartlarımızı okuyun.',
        action: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const TermsOfServicePage(isForApproval: false),
            ),
          );
        },
      ),
    ];

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
          child: Column(
            children: [
              // 🔹 Geri Dön Butonu ve Başlık
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 28,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "Yardım Merkezi",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              // 🔹 Kartların olduğu içerik alanı
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(28),
                      topRight: Radius.circular(28),
                    ),
                  ),
                  child: GridView.builder(
                    padding: const EdgeInsets.all(20),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 20,
                      childAspectRatio: 0.68, // ← DÜZELTİLDİ
                    ),
                    itemCount: helpItems.length,
                    itemBuilder: (context, index) {
                      return HelpCard(item: helpItems[index]);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 4,
        selectedColor: const Color(0xFF7A4FAD),
        unselectedColor: Colors.grey,
        onTap: (index) {
          if (index == 0) Navigator.pushNamed(context, '/explore');
          if (index == 1) Navigator.pushNamed(context, '/requests');
          if (index == 2) Navigator.pushNamed(context, '/moments');
          if (index == 3) Navigator.pushNamed(context, '/jobs');
        },
      ),
    );
  }
}
