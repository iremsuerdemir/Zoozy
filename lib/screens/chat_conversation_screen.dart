import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatMessage {
  final String text;
  final bool isMe;
  final DateTime timestamp;
  final String? imagePath;
  final Uint8List? imageBytes;

  const ChatMessage({
    required this.text,
    required this.timestamp,
    this.isMe = false,
    this.imagePath,
    this.imageBytes,
  });

  bool get hasImage => imagePath != null || imageBytes != null;

  Map<String, dynamic> toJson() => {
        'text': text,
        'isMe': isMe,
        'timestamp': timestamp.toIso8601String(),
        'imagePath': imagePath,
        'imageBytes': imageBytes != null ? base64Encode(imageBytes!) : null,
      };

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    Uint8List? bytes;
    final imageBytesString = json['imageBytes'] as String?;
    if (imageBytesString != null && imageBytesString.isNotEmpty) {
      try {
        bytes = base64Decode(imageBytesString);
      } catch (_) {
        bytes = null;
      }
    }
    return ChatMessage(
      text: json['text'] as String? ?? '',
      isMe: json['isMe'] as bool? ?? false,
      timestamp: DateTime.tryParse(json['timestamp'] as String? ?? '') ??
          DateTime.now(),
      imagePath: json['imagePath'] as String?,
      imageBytes: bytes,
    );
  }
}

class ChatConversationScreen extends StatefulWidget {
  final String contactName;
  final String contactUsername;
  final String contactAvatar;
  final String phoneNumber;
  final String quoteAmount;
  final String statusMessage;
  final List<ChatMessage> messages;

  const ChatConversationScreen({
    super.key,
    required this.contactName,
    required this.contactUsername,
    required this.contactAvatar,
    required this.phoneNumber,
    this.quoteAmount = '',
    this.statusMessage = '',
    this.messages = const [],
  });

  @override
  State<ChatConversationScreen> createState() => _ChatConversationScreenState();
}

class _ChatConversationScreenState extends State<ChatConversationScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _listController = ScrollController();
  final ImagePicker _picker = ImagePicker();

  String _currentUserName = '';
  ImageProvider? _currentUserAvatar;
  List<ChatMessage> _messages = [];
  SharedPreferences? _prefs;

  String get _historyKey => 'chat_history_${widget.contactUsername}';
  String get _deletedKey => 'chat_deleted_${widget.contactUsername}';

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  Future<void> _initializeChat() async {
    _prefs = await SharedPreferences.getInstance();
    await _loadCurrentUser(_prefs!);
    final loaded = await _loadMessagesFromStorage();
    if (mounted) {
      setState(() {
        _messages = loaded;
      });
    }
  }

  Future<void> _loadCurrentUser(SharedPreferences prefs) async {
    final username = prefs.getString('username') ?? 'Kullanıcı';
    final imageString = prefs.getString('profileImagePath');
    ImageProvider? avatar;

    if (imageString != null && imageString.isNotEmpty) {
      try {
        avatar = MemoryImage(base64Decode(imageString));
      } catch (_) {
        avatar = null;
      }
    }

    if (mounted) {
      setState(() {
        _currentUserName = username;
        _currentUserAvatar = avatar;
      });
    }
  }

  ImageProvider? _buildContactAvatar() {
    final avatar = widget.contactAvatar;
    if (avatar.startsWith('http')) {
      return NetworkImage(avatar);
    }
    if (avatar.startsWith('assets/')) {
      return AssetImage(avatar);
    }
    if (avatar.isNotEmpty) {
      try {
        return MemoryImage(base64Decode(avatar));
      } catch (_) {}
    }
    return null;
  }

  Future<List<ChatMessage>> _loadMessagesFromStorage() async {
    final prefs = _prefs ??= await SharedPreferences.getInstance();
    final rawHistory = prefs.getString(_historyKey);
    final isDeleted = prefs.getBool(_deletedKey) ?? false;

    if (rawHistory != null) {
      try {
        final List<dynamic> decoded = jsonDecode(rawHistory) as List<dynamic>;
        return decoded
            .map((e) => ChatMessage.fromJson(
                  Map<String, dynamic>.from(
                    e as Map<dynamic, dynamic>,
                  ),
                ))
            .toList();
      } catch (_) {
        return List.of(widget.messages);
      }
    }

    if (isDeleted) {
      return [];
    }

    final initialMessages = List.of(widget.messages);
    await _saveMessages(initialMessages, markAsActive: true);
    return initialMessages;
  }

  Future<void> _saveMessages(List<ChatMessage> messages,
      {bool markAsActive = true}) async {
    final prefs = _prefs ??= await SharedPreferences.getInstance();
    final encoded =
        jsonEncode(messages.map((message) => message.toJson()).toList());
    await prefs.setString(_historyKey, encoded);
    if (markAsActive) {
      await prefs.setBool(_deletedKey, false);
    }
  }

  Future<void> _openWhatsApp({bool isVideo = false}) async {
    final sanitized = widget.phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
    if (sanitized.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Kayıtlı bir telefon numarası bulunamadı.')),
        );
      }
      return;
    }

    final encodedMessage = Uri.encodeComponent(
      isVideo
          ? 'Merhaba ${widget.contactName}, WhatsApp üzerinden görüntülü görüşme başlatıyorum.'
          : 'Merhaba ${widget.contactName}, Zoozy üzerinden yazıyorum.',
    );
    final uri = Uri.parse('https://wa.me/$sanitized?text=$encodedMessage');

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('WhatsApp açılamadı.')),
        );
      }
    }
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    _messageController.clear();
    _addMessage(
      ChatMessage(
        text: text,
        isMe: true,
        timestamp: DateTime.now(),
      ),
    );
  }

  void _addMessage(ChatMessage message) {
    setState(() {
      _messages = [..._messages, message];
    });
    _saveMessages(_messages);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_listController.hasClients) return;
      _listController.animateTo(
        _listController.position.maxScrollExtent + 80,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _listController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(),
          SafeArea(
            child: Column(
              children: [
                _buildPageHeader(),
                const SizedBox(height: 16),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _buildConversationCard(),
                  ),
                ),
                const SizedBox(height: 16),
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
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFB39DDB),
            Color(0xFFF48FB1),
          ],
        ),
      ),
    );
  }

  Widget _buildPageHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
          ),
          const Text(
            'Sohbet',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildConversationCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildContactInfoSection(),
          const Divider(height: 1),
          Expanded(child: _buildMessagesSection()),
          _buildInputBar(),
        ],
      ),
    );
  }

  Widget _buildContactInfoSection() {
    final avatar = _buildContactAvatar();
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundImage: avatar,
                child: avatar == null
                    ? Text(
                        widget.contactName.characters.first,
                        style: const TextStyle(color: Colors.white),
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.contactUsername,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.contactName,
                      style:
                          const TextStyle(color: Colors.black54, fontSize: 13),
                    ),
                    if (widget.statusMessage.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        widget.statusMessage,
                        style: const TextStyle(
                          color: Colors.deepPurple,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (widget.quoteAmount.isNotEmpty)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: const Color(0xFFF5F5F5),
                  ),
                  child: Column(
                    children: [
                      Text(
                        widget.quoteAmount,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const Text(
                        'Teklif',
                        style: TextStyle(fontSize: 12, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildActionButton(
                icon: Icons.phone,
                label: 'Ara',
                onTap: () => _openWhatsApp(isVideo: false),
              ),
              const SizedBox(width: 8),
              _buildActionButton(
                icon: Icons.videocam,
                label: 'Görüntülü',
                onTap: () => _openWhatsApp(isVideo: true),
              ),
              const SizedBox(width: 8),
              PopupMenuButton<_ChatMenuAction>(
                icon: const Icon(Icons.more_vert, color: Colors.deepPurple),
                onSelected: _handleMenuSelection,
                itemBuilder: (context) => const [
                  PopupMenuItem(
                    value: _ChatMenuAction.clearMessages,
                    child: Text('Mesajları Temizle'),
                  ),
                  PopupMenuItem(
                    value: _ChatMenuAction.deleteConversation,
                    child: Text('Sohbeti Sil'),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 18),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFEDE7F6),
          foregroundColor: Colors.deepPurple,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
      ),
    );
  }

  Widget _buildMessagesSection() {
    if (_messages.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      controller: _listController,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      itemCount: _messages.length,
      itemBuilder: (context, index) => _buildMessageBubble(_messages[index]),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.chat_bubble_outline, size: 48, color: Colors.grey),
          SizedBox(height: 12),
          Text(
            'Henüz mesaj yok.',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'İlk mesajı siz göndererek iletişimi başlatabilirsiniz.',
            style: TextStyle(color: Colors.black45),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final isMe = message.isMe;
    final avatar = isMe ? _currentUserAvatar : _buildContactAvatar();

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMe)
            CircleAvatar(
              radius: 18,
              backgroundImage: avatar,
              child: avatar == null
                  ? Text(
                      widget.contactName.characters.first,
                      style: const TextStyle(color: Colors.white),
                    )
                  : null,
            ),
          if (!isMe) const SizedBox(width: 10),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isMe ? const Color(0xFFEDE7F6) : const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(isMe ? 18 : 4),
                  bottomRight: Radius.circular(isMe ? 4 : 18),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isMe)
                    Text(
                      widget.contactName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  if (!isMe) const SizedBox(height: 6),
                  if (message.hasImage)
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: message.text.isNotEmpty ? 8 : 0,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: _buildMessageImage(message),
                      ),
                    ),
                  if (message.text.isNotEmpty)
                    Text(
                      message.text,
                      style: const TextStyle(
                        fontSize: 15,
                        height: 1.4,
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (isMe) const SizedBox(width: 10),
          if (isMe)
            CircleAvatar(
              radius: 18,
              backgroundImage: _currentUserAvatar,
              child: _currentUserAvatar == null
                  ? Text(
                      _currentUserName.isNotEmpty
                          ? _currentUserName.characters.first
                          : 'S',
                      style: const TextStyle(color: Colors.white),
                    )
                  : null,
            ),
        ],
      ),
    );
  }

  Future<void> _showAttachmentSheet() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Kamera'),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Galeri'),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
            ],
          ),
        );
      },
    );

    if (source != null) {
      await _pickImage(source);
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picked = await _picker.pickImage(
        source: source,
        imageQuality: 75,
        maxWidth: 1080,
      );
      if (picked == null) return;

      if (kIsWeb) {
        final bytes = await picked.readAsBytes();
        _addMessage(
          ChatMessage(
            text: '',
            isMe: true,
            timestamp: DateTime.now(),
            imageBytes: bytes,
          ),
        );
      } else {
        _addMessage(
          ChatMessage(
            text: '',
            isMe: true,
            timestamp: DateTime.now(),
            imagePath: picked.path,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Görsel gönderilemedi: $e')),
      );
    }
  }

  void _handleMenuSelection(_ChatMenuAction action) {
    switch (action) {
      case _ChatMenuAction.clearMessages:
        if (_messages.isEmpty) return;
        setState(() => _messages = []);
        _saveMessages([], markAsActive: true);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Mesajlar temizlendi.')),
        );
        break;
      case _ChatMenuAction.deleteConversation:
        _confirmAndDeleteConversation();
        break;
    }
  }

  Future<void> _confirmAndDeleteConversation() async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 10.0),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.delete_forever, color: Color(0xFF9C27B0), size: 50),
            SizedBox(height: 12),
            Text(
              'Sohbeti silmek istediğine emin misin?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              'Bu işlem geri alınamaz.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                // İPTAL BUTONU
                GestureDetector(
                  onTap: () => Navigator.pop(context, false),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text(
                        'İptal',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // SİL BUTONU (GRADIENT)
                GestureDetector(
                  onTap: () => Navigator.pop(context, true),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF9C27B0), Color(0xFF7B1FA2)],
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text(
                        'Sil',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    if (shouldDelete == true) {
      setState(() => _messages = []);
      final prefs = _prefs ??= await SharedPreferences.getInstance();
      await prefs.remove(_historyKey);
      await prefs.setBool(_deletedKey, true);
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  Widget _buildMessageImage(ChatMessage message) {
    if (message.imageBytes != null) {
      return Image.memory(
        message.imageBytes!,
        width: 220,
        fit: BoxFit.cover,
      );
    }

    if (message.imagePath != null && message.imagePath!.isNotEmpty) {
      return Image.file(
        File(message.imagePath!),
        width: 220,
        fit: BoxFit.cover,
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildInputBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: _messageController,
                minLines: 1,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'Mesajınızı yazın...',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          IconButton(
            onPressed: _showAttachmentSheet,
            icon: const Icon(Icons.photo_camera, color: Colors.purple),
          ),
          ElevatedButton(
            onPressed: _sendMessage,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(14),
            ),
            child: const Icon(Icons.send, color: Colors.white, size: 20),
          ),
        ],
      ),
    );
  }
}

enum _ChatMenuAction { clearMessages, deleteConversation }
