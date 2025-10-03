import 'package:flutter/material.dart';
import 'package:zoozy/components/bottom_navigation_bar.dart';

import '../components/bottom_navigation_bar.dart'
    show CustomBottomNavBar; // kendi yolunu kullandım

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  // Menü butonu (arka planla aynı renk ama gölgeli kutu içinde)
  Widget buildMenuButton(IconData icon, String title) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: const Color(0xFF7A4FAD), size: 28),
          const SizedBox(height: 6),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // Bakiye/Kredi/İnceleme alanları
  Widget buildStatColumn(String label, String value, {String? subLabel}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF7A4FAD),
          ),
        ),
        if (subLabel != null)
          Text(
            subLabel,
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Gradient arka plan
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
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Üst başlık
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.pets, color: Colors.white, size: 28),
                          SizedBox(width: 6),
                          Text(
                            'Zoozy',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon:
                                const Icon(Icons.settings, color: Colors.white),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: const Icon(Icons.chat_bubble_outline,
                                color: Colors.white),
                            onPressed: () {},
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Profil Kartı
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.grey,
                          child:
                              Icon(Icons.person, color: Colors.white, size: 50),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Berk Şahin',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Profilini düzenlemek için tıkla',
                                style:
                                    TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        CircleAvatar(
                          radius: 18,
                          backgroundColor:
                              const Color.fromARGB(206, 238, 231, 231),
                          child: Icon(Icons.qr_code, color: Colors.purple),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Bilançolar
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        buildStatColumn('Bakiye', '0.00'),
                        buildStatColumn('Kredi', '0'),
                        buildStatColumn('Yorum', '0'),
                        buildStatColumn('Görev', '1/7'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Menü Butonları
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [], // gölge kaldırıldı
                    ),
                    child: GridView.count(
                      crossAxisCount: 4,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 10,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        buildMenuButton(
                            Icons.card_giftcard, 'Promosyonlar\nKuponlar'),
                        buildMenuButton(
                            Icons.monetization_on, 'Referans Programı'),
                        buildMenuButton(Icons.favorite, 'Favorilerim'),
                        buildMenuButton(Icons.account_balance_wallet, 'Bakiye'),
                        buildMenuButton(Icons.pets, 'Evcil Hayvanlarım'),
                        buildMenuButton(Icons.military_tech, 'Rozetlerim'),
                        buildMenuButton(Icons.handshake, 'Sponsor / Üyelik'),
                        buildMenuButton(Icons.help_center, 'Yardım Merkezi'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Listings Başlığı
                  const Row(
                    children: [
                      Text('İlanlar',
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF7A4FAD))),
                      SizedBox(width: 360),
                      Icon(Icons.help_outline,
                          color: Color(0xFF7A4FAD), size: 25),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Add Pet Service Kartı
                  InkWell(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: const [
                          CircleAvatar(
                            backgroundColor: Color.fromARGB(255, 205, 196, 216),
                            radius: 28,
                            child: const Icon(
                              Icons.add,
                              color: Color(0xFF7A4FAD),
                              size: 40,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Evcil Hayvan Hizmeti Ekle',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                                Text('Bakıcı / Evcil Hayvan Oteli Ol',
                                    style: TextStyle(color: Colors.grey)),
                              ],
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios,
                              color: Colors.grey, size: 18),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 4,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushNamed(context, '/explore');
          } else if (index == 1) {
            Navigator.pushNamed(context, '/requests');
          } else if (index == 2) {
            Navigator.pushNamed(context, '/moments');
          } else if (index == 3) {
            Navigator.pushNamed(context, '/jobs');
          } else if (index == 4) {}
        },
        selectedColor: const Color(0xFF7A4FAD),
        unselectedColor: Colors.grey,
      ),
    );
  }
}
