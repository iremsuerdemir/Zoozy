import 'package:flutter/material.dart';
import 'package:zoozy/screens/reguests_screen.dart';
import 'package:zoozy/services/guest_access_service.dart';
import 'service_date_page.dart'; // MyCitiesPage dosyanızın doğru yolunu yazın

class MyPetsPage extends StatelessWidget {
  final List<Map<String, dynamic>> pets = [
    {
      "name": "Dog",
      "color": Colors.orange,
      "icon": "🐶",
    },
    {
      "name": "Cat",
      "color": Colors.purple,
      "icon": "🐱",
    },
    {
      "name": "Rabbit",
      "color": Colors.lightBlue,
      "icon": "🐇",
    },
    {
      "name": "Guinea Pig",
      "color": Colors.greenAccent,
      "icon": "🐹",
    },
    {
      "name": "Ferret",
      "color": Colors.deepOrangeAccent,
      "icon": "🦦",
    },
    {
      "name": "Bird",
      "color": Colors.redAccent,
      "icon": "🕊",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFB388FF),
                  Color(0xFFFF8A80),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () async {
              if (!await GuestAccessService.ensureLoggedIn(context)) {
                return;
              }
              if (Navigator.canPop(context)) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RequestsScreen(),
                  ),
                );
              }
            },
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.pets, color: Colors.white, size: 24),
              SizedBox(width: 6),
              Text(
                "Hayvanlarım",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ],
          ),
          centerTitle: true,
          actions: [
            SizedBox(width: 48),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          itemCount: pets.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.9,
          ),
          itemBuilder: (context, index) {
            return InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () async {
                if (!await GuestAccessService.ensureLoggedIn(context)) {
                  return;
                }
                // ModalRoute'dan gelen serviceName'i al
                final args = ModalRoute.of(context)?.settings.arguments
                    as Map<String, dynamic>?;
                String? serviceName =
                    args != null ? args['serviceName'] as String? : null;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ServiceDatePage(petName: pets[index]["name"]),
                    settings: RouteSettings(
                      arguments: {
                        'petName': pets[index]["name"],
                        'serviceName': serviceName ?? '',
                      },
                    ),
                  ),
                );
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                child: Column(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        decoration: BoxDecoration(
                          color: pets[index]["color"],
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            pets[index]["icon"],
                            style: TextStyle(fontSize: 50),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          pets[index]["name"],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
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
    );
  }
}
