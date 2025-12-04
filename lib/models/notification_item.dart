class NotificationItem {
  final String title;
  final String body;
  bool isRead; // Değiştirilebilir olmalı
  final DateTime timestamp;

  NotificationItem({
    required this.title,
    required this.body,
    required this.isRead,
    required this.timestamp,
  });
}
