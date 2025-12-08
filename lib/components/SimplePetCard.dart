import 'package:flutter/material.dart';

class SimplePetCard extends StatelessWidget {
  final String imagePath;
  final String name;
  final String
      ownerName; // Bu, kullanıcının kendisi olacağı için "ownerName" yerine "cins" veya "yaş" gibi bir bilgi gelebilir.
  final VoidCallback? onTap;

  const SimplePetCard({
    Key? key,
    required this.imagePath,
    required this.name,
    required this.ownerName,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 🎉 DÜZELTME 1: Dışarıdan gelen orantılı genişliği kullanmak için sabit 'width: 140' kaldırıldı.
    // Bu kartın genişliği, onu saran SizedBox (ExploreScreen'de) tarafından ayarlanır.

    return GestureDetector(
      onTap: onTap,
      child: Container(
        // Genişlik ve yükseklik kontrolü dışarıdaki widget'a (SizedBox) bırakıldığı için
        // burada maksimum esneklik sağlıyoruz.
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🎉 DÜZELTME 2: Görüntü yüksekliğini, kartın genişliğine göre orantılı hale getiriyoruz (16:9 oranı gibi).
            // Bu, taşma sorunlarını çözmenin anahtarıdır.
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              child: AspectRatio(
                // Orantılı görüntü yüksekliği sağlar
                aspectRatio: 1.25, // Yaklaşık 5:4 en/boy oranı
                child: Image.asset(
                  imagePath,
                  width: double.infinity,
                  // height: 110, // Sabit yükseklik kaldırıldı
                  fit: BoxFit.cover,
                ),
              ),
            ),

            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Evcil Hayvan Adı
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis, // Taşma kontrolü
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),

                  // Sahibinin Adı / Ek Bilgi (Kullanıcının Hayvanı Olması Amacına Uygun)
                  Text(
                    // Kullanıcının kendi hayvanı olduğu için buraya cins/yaş gibi bilgi eklemek daha mantıklı olabilir.
                    // Şimdilik gelen ownerName'i gösteriyoruz, ancak bunu Evcil Hayvanın Cinsi/Yaşı olarak varsayabiliriz.
                    'Cins: ${ownerName}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis, // Taşma kontrolü
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black54,
                    ),
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
