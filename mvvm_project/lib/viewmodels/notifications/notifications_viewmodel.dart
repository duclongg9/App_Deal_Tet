import 'package:flutter/foundation.dart';

enum NotificationType { gift, sale, budget, warning }

class AppNotification {
  final String id;
  final String title;
  final String body;
  final DateTime createdAt;
  final NotificationType type;
  bool isRead;

  AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    required this.type,
    this.isRead = false,
  });
}

class NotificationsViewModel extends ChangeNotifier {
  final List<AppNotification> _notifications = [
    AppNotification(
      id: 'n1',
      title: '🧧 Chào mừng bạn đến App Tết!',
      body: 'Bắt đầu lập ngân sách Tết và săn deal ngay nhé.',
      createdAt: DateTime.now().subtract(const Duration(minutes: 2)),
      type: NotificationType.gift,
    ),
  ];

  List<AppNotification> get notifications =>
      _notifications.reversed.toList();

  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  void addNotification({
    required String title,
    required String body,
    required NotificationType type,
  }) {
    _notifications.add(AppNotification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      body: body,
      createdAt: DateTime.now(),
      type: type,
    ));
    notifyListeners();
  }

  void markAsRead(String id) {
    final n = _notifications.firstWhere((n) => n.id == id, orElse: () => _notifications.first);
    n.isRead = true;
    notifyListeners();
  }

  void markAllAsRead() {
    for (final n in _notifications) {
      n.isRead = true;
    }
    notifyListeners();
  }

  void deleteNotification(String id) {
    _notifications.removeWhere((n) => n.id == id);
    notifyListeners();
  }

  void clearAll() {
    _notifications.clear();
    notifyListeners();
  }
}
