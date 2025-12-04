import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoozy/screens/chat_conversation_screen.dart';
import 'package:zoozy/models/notification_item.dart';

// NOT: Projenizde zaten ChatMessage modeli tanımlıysa onu kullanın.
// Bu örnek kod ChatMessage sınıfının fromJson metoduna dayanmaktadır.

/// ---------------------- InboxActionsBar (yoksa ekledim) ----------------------
class InboxActionsBar extends StatelessWidget {
  final int tabIndex;
  final bool isEditing;
  final VoidCallback onToggleEditMode;
  final VoidCallback onNotificationMarkAllRead;
  final VoidCallback? onPressed;

  const InboxActionsBar({
    super.key,
    required this.tabIndex,
    required this.isEditing,
    required this.onToggleEditMode,
    required this.onNotificationMarkAllRead,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    // Tab 0 -> Mesajlarım: Düzenle / Bitir butonu
    if (tabIndex == 0) {
      return IconButton(
        icon: Icon(
          isEditing ? Icons.check : Icons.edit_outlined,
          color: Colors.white,
          size: 28,
        ),
        onPressed: onToggleEditMode,
      );
    }
    // Tab 1 -> Bildirimler: Tümünü okundu yap (tik)
    else if (tabIndex == 1) {
      return IconButton(
        icon: const Icon(
          Icons.done_all,
          color: Colors.white,
          size: 28,
        ),
        onPressed: onNotificationMarkAllRead,
      );
    }
    // Diğer durumlar
    return const SizedBox(width: 28);
  }
}

/// ---------------------- BildirimlerEkrani ----------------------
class BildirimlerEkrani extends StatefulWidget {
  const BildirimlerEkrani({super.key});

  @override
  State<BildirimlerEkrani> createState() => _BildirimlerEkraniState();
}

class _BildirimlerEkraniState extends State<BildirimlerEkrani> {
  // Örnek bildirim listesi (gerçekte server / local storage ile değiştirilebilir)
  List<NotificationItem> _notifications = [
    NotificationItem(
      title: 'Yeni Mesaj!',
      body: 'Emir Öztürk size bir teklif gönderdi.',
      isRead: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
    NotificationItem(
      title: 'İlanınız Onaylandı',
      body: 'Gündüz bakımı ilanınız yayına alındı.',
      isRead: false,
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    NotificationItem(
      title: 'Bakım Tamamlandı',
      body: 'Dostunuzun bakımı başarıyla tamamlandı.',
      isRead: true,
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  // Bildirimi okundu olarak işaretler
  void _markAsRead(int index) {
    setState(() {
      _notifications[index].isRead = true;
    });
  }

  // Tüm bildirimleri okundu yapar (InboxActionsBar'dan çağrılır)
  void _markAllAsRead() {
    setState(() {
      for (var n in _notifications) {
        n.isRead = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_notifications.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: _notifications.length,
      itemBuilder: (context, index) {
        final notification = _notifications[index];
        return _buildNotificationCard(context, notification, index);
      },
    );
  }

  Widget _buildNotificationCard(
      BuildContext context, NotificationItem notification, int index) {
    final Color backgroundColor =
        notification.isRead ? Colors.white : const Color(0xFFEBEFF3);

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      color: backgroundColor,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(
          notification.title,
          style: TextStyle(
            fontWeight:
                notification.isRead ? FontWeight.normal : FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        subtitle: Text(
          notification.body,
          style: TextStyle(
            color: notification.isRead ? Colors.grey : Colors.black54,
          ),
        ),
        trailing: Text(
          '${notification.timestamp.hour}:${notification.timestamp.minute.toString().padLeft(2, '0')}',
          style: TextStyle(
            fontSize: 12,
            color: notification.isRead ? Colors.grey : Colors.black54,
          ),
        ),
        onTap: () => _markAsRead(index),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'Henüz Bildirim Yok',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              'Yeni bildirimler geldiğinde burada göreceksiniz.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// ---------------------- IndexboxMessageScreen (Ana Gelen Kutusu) ----------------------
class IndexboxMessageScreen extends StatefulWidget {
  const IndexboxMessageScreen({super.key});

  @override
  State<IndexboxMessageScreen> createState() => _IndexboxMessageScreenState();
}

class _IndexboxMessageScreenState extends State<IndexboxMessageScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isEditing = false;

  // BildirimlerEkrani state'ine erişmek için key
  final GlobalKey<_BildirimlerEkraniState> _notificationsKey =
      GlobalKey<_BildirimlerEkraniState>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabChange);
  }

  void _handleTabChange() {
    if (_isEditing && _tabController.indexIsChanging) {
      setState(() {
        _isEditing = false;
      });
    }
    if (_tabController.indexIsChanging) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  void _toggleEditMode() {
    if (_tabController.index == 0) {
      setState(() {
        _isEditing = !_isEditing;
      });
    }
  }

  void _markAllNotificationsRead() {
    if (_tabController.index == 1) {
      _notificationsKey.currentState?._markAllAsRead();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Tüm Bildirimler Okundu Olarak İşaretlendi')),
      );
    }
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
                            children: [
                              TaleplerEkrani(
                                isEditing: _isEditing,
                                onToggleEditMode: _toggleEditMode,
                              ),
                              BildirimlerEkrani(key: _notificationsKey),
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
            isEditing: _isEditing,
            onToggleEditMode: _toggleEditMode,
            onNotificationMarkAllRead: _markAllNotificationsRead,
            onPressed: null,
          ),
        ],
      ),
    );
  }
}

/// ---------------------- TabBar widget ----------------------
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
            Tab(text: 'Mesajlarım'),
            Tab(text: 'Bildirimler'),
          ],
        ),
      ),
    );
  }
}

/// ---------------------- TaleplerEkrani (Mesajlarım) ----------------------
class TaleplerEkrani extends StatefulWidget {
  final bool isEditing;
  final VoidCallback onToggleEditMode;

  const TaleplerEkrani({
    super.key,
    required this.isEditing,
    required this.onToggleEditMode,
  });

  @override
  State<TaleplerEkrani> createState() => _TaleplerEkraniState();
}

class _TaleplerEkraniState extends State<TaleplerEkrani> {
  List<_ChatPreview> _chats = [
    _ChatPreview(
      contactName: 'Emir Öztürk',
      contactUsername: 'Emir_Ozturk',
      avatar: 'assets/images/caregiver1.png',
      phoneNumber: '+905306403286',
      lastMessagePreview:
          'Merhaba İrem Su! Ben Emir, Trakya Üniversitesi Bilgisayar Mühendisliği bölümünde Doçent Dr. olarak görev yapıyorum...',
      messages: [
        ChatMessage(
          text:
              'Merhaba İrem Su!\n\nBenim adım Emir Öztürk. Trakya Üniversitesi Bilgisayar Mühendisliği bölümünde Doçent Dr. olarak görev yapıyorum...',
          timestamp: DateTime(2024, 11, 18, 14, 1),
        ),
      ],
    ),
    _ChatPreview(
      contactName: 'Ayşe Kaya',
      contactUsername: 'Ayse_Kaya',
      avatar: 'assets/images/caregiver1.png',
      phoneNumber: '+905321234567',
      lastMessagePreview:
          'Merhaba, ilanınızı gördüm. Kediniz için harika bir pansiyonum var...',
      messages: [
        ChatMessage(
          text:
              'Merhaba, ilanınızı gördüm. Kediniz için harika bir pansiyonum var...',
          timestamp: DateTime(2024, 11, 19, 10, 30),
        ),
      ],
    ),
  ];

  Future<void> _markChatAsDeleted(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('chat_deleted_$username', true);
    await prefs.remove('chat_history_$username');
  }

  void _deleteChat(BuildContext context, _ChatPreview chat) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Mesajı Sil'),
        content: Text(
            '${chat.contactName} ile olan mesajı silmek istediğinizden emin misiniz?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Hayır'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Evet', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _markChatAsDeleted(chat.contactUsername);
      setState(() {
        _chats.removeWhere((c) => c.contactUsername == chat.contactUsername);
      });
      if (_chats.isEmpty) {
        widget.onToggleEditMode();
      }
    }
  }

  void _showIlanYayiniModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const IlanYayiniIcerigi(),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_chats.isEmpty) {
      return _buildEmptyState(context);
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 12),
          child: Text(
            'Son Mesajlar',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        ..._chats
            .map((chat) => _buildChatTile(context, chat, widget.isEditing)),
      ],
    );
  }

  Widget _buildChatTile(
      BuildContext context, _ChatPreview chat, bool isEditing) {
    final avatar = _resolveAvatar(chat.avatar);

    return FutureBuilder<_StoredChatData>(
      future: _loadStoredChat(chat),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Card(
            elevation: 0,
            margin: const EdgeInsets.only(bottom: 12),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: const SizedBox(
              height: 88,
              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
            ),
          );
        }

        final data = snapshot.data ??
            _StoredChatData(messages: chat.messages, isDeleted: false);

        if (data.isDeleted && data.messages.isEmpty) {
          return const SizedBox.shrink();
        }

        final messages = data.messages;
        final previewText =
            messages.isNotEmpty ? messages.last.text.replaceAll('\n', ' ') : '';

        return Card(
          elevation: 0,
          margin: const EdgeInsets.only(bottom: 12),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Stack(
            children: [
              ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: CircleAvatar(
                  radius: 26,
                  backgroundImage: avatar,
                  child: avatar == null
                      ? Text(chat.contactName.characters.first,
                          style: const TextStyle(color: Colors.white))
                      : null,
                ),
                title: Text(chat.contactName,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(previewText,
                      maxLines: 2, overflow: TextOverflow.ellipsis),
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                ),
                onTap: isEditing
                    ? null
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChatConversationScreen(
                              contactName: chat.contactName,
                              contactUsername: chat.contactUsername,
                              contactAvatar: chat.avatar,
                              phoneNumber: chat.phoneNumber,
                              messages: messages,
                            ),
                          ),
                        ).then((_) {
                          if (mounted) setState(() {});
                        });
                      },
              ),
              if (isEditing)
                Positioned(
                  right: 8,
                  bottom: 8,
                  child: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red, size: 28),
                    onPressed: () => _deleteChat(context, chat),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
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
                  color: Colors.black87),
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
              onPressed: () => _showIlanYayiniModal(context),
              style: OutlinedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                side: const BorderSide(color: Color(0xFFB39DDB), width: 1.5),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
              child: const Text('TALEP OLUŞTUR',
                  style: TextStyle(
                      color: Color(0xFFB39DDB),
                      fontWeight: FontWeight.bold,
                      fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  Future<_StoredChatData> _loadStoredChat(_ChatPreview chat) async {
    final prefs = await SharedPreferences.getInstance();
    final historyKey = 'chat_history_${chat.contactUsername}';
    final deletedKey = 'chat_deleted_${chat.contactUsername}';
    final rawHistory = prefs.getString(historyKey);
    final isDeleted = prefs.getBool(deletedKey) ?? false;

    if (rawHistory != null) {
      try {
        final List<dynamic> decoded = jsonDecode(rawHistory) as List<dynamic>;
        final messages = decoded
            .map((e) => ChatMessage.fromJson(
                Map<String, dynamic>.from(e as Map<dynamic, dynamic>)))
            .toList();
        return _StoredChatData(messages: messages, isDeleted: isDeleted);
      } catch (_) {
        // fallback to provided messages
      }
    }

    if (isDeleted) {
      return const _StoredChatData(messages: [], isDeleted: true);
    }

    return _StoredChatData(messages: chat.messages, isDeleted: false);
  }

  static ImageProvider? _resolveAvatar(String avatar) {
    if (avatar.startsWith('http')) return NetworkImage(avatar);
    if (avatar.startsWith('assets/')) return AssetImage(avatar);
    if (avatar.isNotEmpty) {
      try {
        return MemoryImage(base64Decode(avatar));
      } catch (_) {}
    }
    return null;
  }
}

/// ---------------------- Yardımcı sınıflar ----------------------
class _ChatPreview {
  final String contactName;
  final String contactUsername;
  final String avatar;
  final String phoneNumber;

  final String lastMessagePreview;
  final List<ChatMessage> messages;

  const _ChatPreview({
    required this.contactName,
    required this.contactUsername,
    required this.avatar,
    required this.phoneNumber,
    required this.lastMessagePreview,
    required this.messages,
  });
}

class _StoredChatData {
  final List<ChatMessage> messages;
  final bool isDeleted;

  const _StoredChatData({
    required this.messages,
    required this.isDeleted,
  });
}

/// ---------------------- IlanYayiniIcerigi (Modal) ----------------------
class IlanYayiniIcerigi extends StatelessWidget {
  const IlanYayiniIcerigi({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
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
            const Text("İlan Yayını",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87)),
            const SizedBox(height: 8),
            const Text(
              "Yakınınızdaki destekçilere evcil hayvanlarınızla ilgili yardıma ihtiyacınız olduğunu bildirmek için ilan yayınlayın.",
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                _buildServiceCard(Icons.house_outlined, "Pansiyon"),
                _buildServiceCard(Icons.wb_sunny_outlined, "Gündüz Bakımı"),
                _buildServiceCard(Icons.chair_outlined, "Evde Bakım"),
                _buildServiceCard(Icons.directions_walk, "Gezdirme"),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                _buildServiceCard(Icons.local_taxi_outlined, "Taksi"),
                _buildServiceCard(Icons.cut_outlined, "Bakım"),
                _buildServiceCard(Icons.school_outlined, "Eğitim"),
                const Expanded(child: SizedBox.shrink()),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  static Widget _buildServiceCard(IconData icon, String title) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Column(
          children: [
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                color: const Color(0xFFF3E5F5),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2)),
                ],
              ),
              child: Icon(icon, size: 30, color: const Color(0xFF673AB7)),
            ),
            const SizedBox(height: 8),
            Text(title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}
