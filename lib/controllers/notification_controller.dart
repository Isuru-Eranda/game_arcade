import 'package:flutter/material.dart';
import '../models/notification_model.dart';

class NotificationController {
  // Singleton pattern
  static final NotificationController _instance =
      NotificationController._internal();

  factory NotificationController() => _instance;

  NotificationController._internal();

  // Sample notification data - in a real app this would be fetched from a database or API
  final List<NotificationItem> notifications = [
    NotificationItem(
      title: "New Game Added",
      message: "Check out the latest game in our collection!",
      time: "2 hours ago",
      isRead: false,
    ),
    NotificationItem(
      title: "Weekly Challenge",
      message: "New weekly challenge is available now",
      time: "1 day ago",
      isRead: true,
    ),
    NotificationItem(
      title: "Achievement Unlocked",
      message: "You've reached level 5 in Space Invaders!",
      time: "3 days ago",
      isRead: true,
    ),
  ];

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
