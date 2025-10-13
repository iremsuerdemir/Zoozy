import 'package:flutter/material.dart';

class CaregiverCardAsset extends StatefulWidget {
  final String name;
  final String imagePath;
  final String suitability;
  final double price;

  const CaregiverCardAsset({
    super.key,
    required this.name,
    required this.imagePath,
    required this.suitability,
    required this.price,
  });

  @override
  State<CaregiverCardAsset> createState() => _CaregiverCardAssetState();
}

class _CaregiverCardAssetState extends State<CaregiverCardAsset> {
  bool liked = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${widget.name} seçildi')),
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.40,
        height: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          image: DecorationImage(
            image: AssetImage(widget.imagePath),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 80,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(24),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      const Color.fromARGB(255, 67, 30, 100).withOpacity(0.7),
                      const Color.fromARGB(255, 51, 27, 90).withOpacity(0.85),
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),

          
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    liked = !liked;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.5),
                  ),
                  padding: const EdgeInsets.all(6),
                  child: Icon(
                    Icons.favorite,
                    color: liked ? Colors.redAccent : Colors.white,
                    size: 20,
                    shadows: const [
                      Shadow(
                        color: Colors.black26,
                        blurRadius: 2,
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                ),
              ),
            ),

         
            Positioned(
              left: 12,
              bottom: 12,
              right: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      shadows: [
                        Shadow(
                          blurRadius: 3,
                          color: Colors.black45,
                          offset: Offset(1, 1),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          widget.suitability,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '\$${widget.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
