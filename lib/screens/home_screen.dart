import 'package:flutter/material.dart';
import 'package:zoozy/components/bottom_navigation_bar.dart'
    show CustomBottomNavBar;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Color purpleMain = const Color(0xFF6F3A9B);
  final Color purpleLight = const Color(0xFFF1E9FA);

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(82),
        child: SafeArea(
          bottom: false,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            color: Colors.white,
            child: Row(
              children: [
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: purpleLight,
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Icon(Icons.pets, color: purpleMain, size: 26),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'PetBacker',
                      style: TextStyle(
                        color: purpleMain,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.chat_bubble_outline,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: const [
            // İçeriği daha sonra ekleyeceksin
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedColor: purpleMain,
        unselectedColor: Colors.grey.shade600,
      ),
    );
  }
}
