import 'package:flutter/material.dart';

class ConfirmPhoneScreen extends StatelessWidget {
  const ConfirmPhoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Ekrandaki kalın mor buton rengi için özel bir renk tanımlıyoruz
    const Color purpleButtonColor = Color(0xFF8E6FB4);
    // Ekrandaki açık mor buton rengi için özel bir renk tanımlıyoruz
    const Color lightPurpleButtonColor = Color(0xFFD4C7E6);

    return Scaffold(
      // AppBar'da sol üstteki geri okunu ve beyaz arka planı ayarlıyoruz
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Geri gitme işlevi buraya eklenebilir
          },
        ),
      ),
      // Ekran içeriği
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
        children: <Widget>[
          // Başlık metni
          const Text(
            'Anlık Bildirimleri Telefonunuzda Alın',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16.0),
          // Açıklama metni
          const Text(
            'Numaranız gizli tutulur ve asla başka hiçbir üçüncü tarafa açıklanmaz. Yanıt vermemeniz durumunda sadece çalışanlarımızın sizinle e-posta veya uygulama üzerinden iletişime geçmesine izin veriyoruz. Telefonunuzu doğrulamak için size bir kod göndereceğiz.',
            style: TextStyle(fontSize: 16, height: 1.5, color: Colors.black87),
          ),
          const SizedBox(height: 32.0),
          // Ülke seçim alanı
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: 'Türkiye', // Varsayılan değer
                icon: const Icon(Icons.arrow_drop_down),
                isExpanded: true,
                style: const TextStyle(fontSize: 16, color: Colors.black),
                items:
                    <String>[
                      'Türkiye',
                      'Amerika Birleşik Devletleri',
                      'Almanya',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                onChanged: (String? newValue) {
                  // Ülke seçimi işlevi buraya eklenebilir
                },
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          // Telefon Numarası Giriş Alanı
          TextFormField(
            decoration: InputDecoration(
              hintText: '+90 5XX XXX XX XX', // Türk formatına uygun bir ipucu
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 16.0,
              ),
              border: const OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
            ),
            keyboardType: TextInputType.phone,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 32.0),
          // 'Bana SMS Gönder' Butonu (Açık Mor)
          SizedBox(
            height: 50,
            child: ElevatedButton.icon(
              onPressed: () {
                // SMS gönderme işlevi buraya eklenebilir
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: lightPurpleButtonColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                ),
                elevation: 0,
              ),
              icon: const Icon(
                Icons.email_outlined,
                color: Colors.white,
              ), // Zarfa benzeyen ikon
              label: const Text(
                'BANA SMS GÖNDER',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          // 'Daha Sonra Yap' Butonu (Koyu Mor)
          SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                // Daha sonra yap işlevi buraya eklenebilir
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: purpleButtonColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                ),
                elevation: 0,
              ),
              child: const Text(
                'DAHA SONRA YAP',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
