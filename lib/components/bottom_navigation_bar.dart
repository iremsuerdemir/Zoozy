import 'package:flutter/material.dart';
import 'package:zoozy/screens/jobs_screen.dart';
import 'package:zoozy/screens/moments_screen.dart';
import 'package:zoozy/screens/profile_screen.dart';
import '../screens/reguests_screen.dart'; // doğru ekranı import et
import '../screens/explore_screen.dart'; // ExploreScreen importu eklendi

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int)? onTap; // opsiyonel yapabiliriz
  final Color selectedColor;
  final Color unselectedColor;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    this.onTap, // artık opsiyonel
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
        if (index == 0) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ExploreScreen()),
          );
        } else if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const RequestsScreen(),
            ), // doğru isim
          );
        } else if (index == 3) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const JobsScreen()),
          );
        } else if (index == 4) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProfileScreen()),
          );
        } else if (index == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MomentsScreen()),
          );
        } else {
          if (onTap != null) {
            onTap!(index); // opsiyonel kontrol
          }
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
        BottomNavigationBarItem(icon: Icon(Icons.image), label: 'Anlar'),
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
