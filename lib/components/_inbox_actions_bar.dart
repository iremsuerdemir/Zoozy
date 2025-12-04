import 'package:flutter/material.dart';

class InboxActionsBar extends StatelessWidget {
  final int tabIndex;
  // Düzenleme modunda olup olmadığını belirtir.
  final bool isEditing;
  // Butona basıldığında çağrılır.
  final VoidCallback? onPressed;
  // Bildirimler sekmesinde tik'e basıldığında çağrılır.
  final VoidCallback? onNotificationMarkAllRead;
  // Mesajlarım sekmesinde Düzenle'ye/Bitir'e basıldığında çağrılır.
  final VoidCallback? onToggleEditMode;

  const InboxActionsBar({
    super.key,
    required this.tabIndex,
    required this.isEditing, // Yeni: Düzenleme modunda mı?
    this.onPressed,
    this.onNotificationMarkAllRead,
    this.onToggleEditMode,
  });

  @override
  Widget build(BuildContext context) {
    // 0: Mesajlarım, 1: Bildirimler (Sizin TabBar yapınızdaki indexler)
    final bool isMessagesTab = tabIndex == 0;
    final bool isNotificationsTab = tabIndex == 1;

    if (isNotificationsTab) {
      // 🔵 BİLDİRİMLER → TİK İKONU
      return IconButton(
        onPressed: onNotificationMarkAllRead, // Tik'e basıldığında
        icon: const Icon(
          Icons.check,
          // Renk: Beyaz arka plan üzerinde koyu bir renk olsun
          color: Colors.white,
          size: 28,
        ),
      );
    } else if (isMessagesTab) {
      // 🔵 MESAJLARIM → "Düzenle" veya "Bitir" butonu
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF673AB7),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(
              color: Color(0xFF673AB7),
              width: 1.5,
            ),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          elevation: 0,
        ),
        onPressed: onToggleEditMode, // Düzenle/Bitir'e basıldığında
        child: Text(
          isEditing
              ? 'Bitir'
              : 'Düzenle', // Düzenleme moduna göre metin değişimi
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Color(0xFF673AB7),
          ),
        ),
      );
    }

    // Varsayılan boş bir widget dönsün.
    return const SizedBox.shrink();
  }
}
