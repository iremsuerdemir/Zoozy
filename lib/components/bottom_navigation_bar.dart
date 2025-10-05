import 'package:flutter/material.dart';
import 'package:zoozy/screens/jobs_screen.dart';
import 'package:zoozy/screens/profile_screen.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final Color selectedColor;
  final Color unselectedColor;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.selectedColor,
    required this.unselectedColor,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: selectedColor,
      unselectedItemColor: unselectedColor,
      showUnselectedLabels: true,
      onTap: (index) {
        if (index == 4) {
          // Profil butonuna basıldığında ProfileScreen sayfasına git
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProfileScreen()),
          );
        } else if (index == 3) {
          // Jobs butonuna basıldığında JobsScreen sayfasına git
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const JobsScreen()),
          );
        } else {
          // Diğer indexler için senin verdiğin onTap çalışsın
          onTap(index);
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.search_outlined),
          label: 'Keşfet',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.receipt_long),
          label: 'Talepler',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.image),
          label: 'Anlar',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.monetization_on_outlined),
          label: 'İşler',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'Profil',
        ),
      ],
    );
  }
}
