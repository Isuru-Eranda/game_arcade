import 'package:flutter/material.dart';

class NotificationItem {
  final String title;
  final String message;
  final String time;
  bool isRead;

  NotificationItem({
    required this.title,
    required this.message,
    required this.time,
    this.isRead = false,
  });
}
