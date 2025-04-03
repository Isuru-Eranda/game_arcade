import 'package:flutter/material.dart';
import '../controllers/notification_controller.dart';
import '../models/notification_model.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final NotificationController _controller = NotificationController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(color: Colors.orange),
        ),
        iconTheme: const IconThemeData(color: Colors.orange),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.orange),
            onPressed: () {
              setState(() {
                _controller.clearAllNotifications();
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All notifications cleared')),
              );
            },
            tooltip: 'Clear all',
          ),
        ],
      ),
      body: _controller.notifications.isEmpty
          ? const Center(
              child: Text(
                'No notifications',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: _controller.notifications.length,
              itemBuilder: (context, index) {
                return NotificationTile(
                  notification: _controller.notifications[index],
                  onTap: () {
                    setState(() {
                      _controller.markAsRead(index);
                    });
                    // You could navigate to specific content based on notification
                  },
                );
              },
            ),
    );
  }
}

class NotificationTile extends StatelessWidget {
  final NotificationItem notification;
  final VoidCallback onTap;

  const NotificationTile(
      {Key? key, required this.notification, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: notification.isRead ? Colors.white : Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue.shade700,
          child: const Icon(Icons.notifications, color: Colors.white),
        ),
        title: Text(
          notification.title,
          style: TextStyle(
            fontSize: 25,
            fontWeight:
                notification.isRead ? FontWeight.normal : FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notification.message,
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              notification.time,
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        isThreeLine: true,
        onTap: onTap,
      ),
    );
  }
}
