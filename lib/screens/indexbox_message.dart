import 'package:flutter/material.dart';
import 'package:zoozy/components/_inbox_actions_bar.dart';

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
    _tabController = TabController(length: 3, vsync: this);
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
            Tab(
              child: Stack(
                clipBehavior: Clip.none,
                children: [Center(child: Text('Bildirimler'))],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Talepler Sekmesi
class TaleplerEkrani extends StatelessWidget {
  const TaleplerEkrani({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Talepler Sekmesi'));
  }
}

/// İşler Sekmesi
class IslerEkrani extends StatelessWidget {
  const IslerEkrani({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('İşler Sekmesi'));
  }
}

/// Bildirimler Sekmesi
class BildirimlerEkrani extends StatelessWidget {
  const BildirimlerEkrani({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Bildirimler Sekmesi'));
  }
}
