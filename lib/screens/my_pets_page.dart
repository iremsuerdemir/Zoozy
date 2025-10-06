import 'package:flutter/material.dart';

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
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
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
            return Card(
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
            );
          },
        ),
      ),
    );
  }
}
