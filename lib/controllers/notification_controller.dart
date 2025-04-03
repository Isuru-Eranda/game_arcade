import 'package:flutter/material.dart';
import '../models/notification_model.dart';

class NotificationController {
  // Singleton pattern
  static final NotificationController _instance =
      NotificationController._internal();

  factory NotificationController() => _instance;

  NotificationController._internal();

  // Sample notification data - in a real app this would be fetched from a database or API
  final List<NotificationItem> notifications = [];

  void clearAllNotifications() {
    notifications.clear();
  }

  void markAsRead(int index) {
    if (index >= 0 && index < notifications.length) {
      notifications[index].isRead = true;
    }
  }

  void addNotification(NotificationItem notification) {
    notifications.insert(0, notification);
  }
}
