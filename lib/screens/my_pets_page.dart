import 'package:flutter/material.dart';

import 'package:zoozy/components/selectedService.dart' as globals;
import 'package:zoozy/screens/grooming_service_page.dart';
import 'package:zoozy/screens/my_cities_page.dart';
import 'package:zoozy/screens/petTrainingPage.dart';

import 'package:zoozy/screens/reguests_screen.dart';
import 'package:zoozy/screens/service_date_page.dart';
import 'package:zoozy/screens/visit_type_page.dart';
import 'package:zoozy/screens/walk_count_page.dart';

class MyPetsPage extends StatelessWidget {
  final List<Map<String, dynamic>> pets = [
    {
      "name": "Dog",
      "color": Colors.orange,
      "icon": ":dog:",
    },
    {
      "name": "Cat",
      "color": Colors.purple,
      "icon": ":cat:",
    },
    {
      "name": "Rabbit",
      "color": Colors.lightBlue,
      "icon": ":rabbit2:",
    },
    {
      "name": "Guinea Pig",
      "color": Colors.greenAccent,
      "icon": ":hamster:",
    },
    {
      "name": "Ferret",
      "color": Colors.deepOrangeAccent,
      "icon": ":otter:",
    },
    {
      "name": "Bird",
      "color": Colors.redAccent,
      "icon": ":dove_of_peace:",
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
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => RequestsScreen()));
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
              onTap: () {
                Navigator.pop(context); // Modalı kapat

                // Global değişkene göre yönlendirme
                switch (globals.selectedService) {
                  case "Pansiyon":
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ServiceDatePage()),
                    );
                    break;
                  case "Gündüz Bakımı":
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ServiceDatePage()),
                    );
                    break;
                  case "Evde Bakım":
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => VisitTypePage()),
                    );
                    break;
                  case "Gezdirme":
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => WalkCountPage()),
                    );
                    break;
                  case "Taksi":
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ServiceDatePage()),
                    );
                    break;
                  case "Bakım":
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => GroomingServicePage()),
                    );
                    break;
                  case "Eğitim":
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PetTrainingPage()),
                    );
                    break;
                  default:
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyPetsPage()),
                    );
                    break;
                }
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
