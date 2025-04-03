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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(110), // Maintaining the increased height
        child: SafeArea(
          child: AppBar(
            centerTitle: false,
            title: const Padding(
              padding: EdgeInsets.only(top: 20.0), // Reduced padding
              child: Text(
                'Notifications',
                style: TextStyle(color: Colors.orange, fontSize: 28, fontWeight: FontWeight.normal),
              ),
            ),
            iconTheme: const IconThemeData(color: Colors.orange),
            actions: [
              Padding(
                padding: const EdgeInsets.only(top: 20.0, right: 10.0), // Adjusted padding with right padding added
                child: IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.orange, size: 28), // Increased icon size for better visibility
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
              ),
            ],
          ),
        ),
      ),
      body: _controller.notifications.isEmpty
          ? const Center(
              child: Text(
                'No notifications',
                style: TextStyle(fontSize: 16, color: Colors.grey),
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
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              notification.time,
              style: TextStyle(
                fontSize: 16,
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
