import 'package:flutter/material.dart';
import 'package:zoozy/components/_inbox_actions_bar.dart';
import 'package:zoozy/screens/agreement_screen.dart';

// Mevcut kodunuzdaki Talepler, İşler ve Bildirimler Ekranları değişmiyor.
// Ancak, IlanYayiniEkrani artık modal bottom sheet olarak kullanılacağı için
// yapısını değiştiriyoruz.

class IndexboxMessageScreen extends StatefulWidget {
  const IndexboxMessageScreen({super.key});

  @override
  State<IndexboxMessageScreen> createState() => _IndexboxMessageScreenState();
}

class _IndexboxMessageScreenState extends State<IndexboxMessageScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // Tab controller'ı "İşler" sekmesi olan 1. indeksten başlatıyoruz
    _tabController = TabController(length: 3, vsync: this, initialIndex: 1);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {}); // Tab değişince header butonu günceller
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Stack(
        children: [
          _buildBackground(),
          SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                const SizedBox(height: 16),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      children: [
                        _InboxTabBar(tabController: _tabController),
                        Expanded(
                          child: TabBarView(
                            controller: _tabController,
                            children: const [
                              TaleplerEkrani(),
                              IslerEkrani(),
                              BildirimlerEkrani(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFB39DDB), Color(0xFFF48FB1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
            onPressed: () => Navigator.pop(context),
          ),
          const Spacer(),
          const Text(
            'Gelen Kutusu',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          InboxActionsBar(
            tabIndex: _tabController.index,
            onPressed: () {
              print('Düzenle/Tik butonuna basıldı');
            },
          ),
        ],
      ),
    );
  }
}

class _InboxTabBar extends StatelessWidget {
  final TabController tabController;
  const _InboxTabBar({required this.tabController});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: TabBar(
          controller: tabController,
          labelColor: const Color(0xFF673AB7),
          unselectedLabelColor: Colors.grey,
          indicatorColor: const Color(0xFF673AB7),
          indicatorWeight: 3,
          indicatorSize: TabBarIndicatorSize.tab,
          tabs: const [
            Tab(text: 'Talepler'),
            Tab(text: 'İşler'),
            Tab(text: 'Bildirimler'),
          ],
        ),
      ),
    );
  }
}

/// Talepler Sekmesi
class TaleplerEkrani extends StatelessWidget {
  const TaleplerEkrani({super.key});

  // Modal bottom sheet'i gösteren yeni metod
  void _showIlanYayiniModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // İçeriğe göre yüksekliği ayarlamak için
      backgroundColor: Colors.transparent, // Köşe yuvarlaklığını korumak için
      builder: (context) {
        // Modalın üst kısmına yuvarlak köşe vermek için ClipRRect kullanıyoruz
        return const IlanYayiniIcerigi();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Henüz Mesaj Yok',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Bakıcılar taleplerinize cevap verdiğinde, mesajlarını burada göreceksiniz.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            OutlinedButton(
              onPressed: () =>
                  _showIlanYayiniModal(context), // Modal gösteriliyor
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 12,
                ),
                side: const BorderSide(color: Color(0xFFB39DDB), width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'TALEP OLUŞTUR',
                style: TextStyle(
                  color: Color(0xFFB39DDB),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// İşler Sekmesi
class IslerEkrani extends StatelessWidget {
  const IslerEkrani({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Henüz İş Yok',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                'İlk ilanınızı oluşturun ve yeni iş mesajlarından haberdar olun.',
                style: TextStyle(fontSize: 16, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 40),
            OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AgreementScreen(),
                  ),
                );
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 14,
                ),
                side: const BorderSide(color: Color(0xFFB39DDB), width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                backgroundColor: Colors.white,
              ),
              child: const Text(
                'İLAN OLUŞTUR',
                style: TextStyle(
                  color: Color(0xFFB39DDB),
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Bildirimler Sekmesi
class BildirimlerEkrani extends StatelessWidget {
  const BildirimlerEkrani({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Bildirimler Sekmesi'));
  }
}

// Yeni: Modal bottom sheet içeriği
// IlanYayiniEkrani'nı bu şekilde yeniden adlandırıp Scaffold'ı çıkarıyoruz
class IlanYayiniIcerigi extends StatelessWidget {
  const IlanYayiniIcerigi({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      child: Container(
        color: Colors.white, // Modalın arka plan rengi
        padding: const EdgeInsets.all(24.0),
        child: Column(
          // İçeriğin boyutuna göre yer kaplaması için
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Bu kısım, resimdeki kapatma düğmesi için
            Center(
              child: Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "İlan Yayını",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Yakınınızdaki destekçilere evcil hayvanlarınızla ilgili yardıma ihtiyacınız olduğunu bildirmek için ilan yayınlayın.",
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 24),
            // İlk satır: Pansiyon, Gündüz Bakımı, Evde Bakım, Gezdirme
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                _buildServiceCard(Icons.house_outlined, "Pansiyon"),
                // Icons.sunny_snowing yerine daha uygun bir ikon seçimi yapıyoruz
                _buildServiceCard(Icons.wb_sunny_outlined, "Gündüz Bakımı"),
                _buildServiceCard(Icons.chair_outlined, "Evde Bakım"),
                _buildServiceCard(Icons.directions_walk, "Gezdirme"),
              ],
            ),
            const SizedBox(height: 20),
            // İkinci satır: Taksi, Bakım, Eğitim
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                _buildServiceCard(Icons.local_taxi_outlined, "Taksi"),
                _buildServiceCard(Icons.cut_outlined, "Bakım"),
                _buildServiceCard(Icons.school_outlined, "Eğitim"),
                // Kalan boşluğu doldurmak için Expanded/SizedBox kullanıldı
                const Expanded(child: SizedBox.shrink()),
              ],
            ),
            // Bottom sheet'in altında boşluk bırakmak için (isteğe bağlı)
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Resimdeki kartların daha iyi görünmesi için Card yerine
  // tıklanabilir bir yapı olan InkWell/GestureDetector ve Container kullandık.
  static Widget _buildServiceCard(IconData icon, String title) {
    // Card'ın yerini Container/GestureDetector alıyor
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Column(
          children: [
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                color: const Color(0xFFF3E5F5), // Resimdeki açık mor arka plan
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(icon, size: 30, color: const Color(0xFF673AB7)),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
