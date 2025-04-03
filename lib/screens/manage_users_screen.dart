import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:game_arcade/controllers/user_service.dart';

class ManageUsersScreen extends StatelessWidget {
  final UserService _userService = UserService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Users'),
        backgroundColor: Colors.orange,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _userService.fetchUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No users available.'));
          }

          final users = snapshot.data!.docs;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              final data = user.data() as Map<String, dynamic>;

              // Provide default values for missing fields
              final isAdmin = data['isAdmin'] ?? false; // Default to false
              final status = data['status'] ?? 'active'; // Default to 'active'

              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  title: Text(data['name'] ?? 'Unknown User'),
                  subtitle: Text(data['email'] ?? 'No Email'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Block/Unblock User
                      IconButton(
                        icon: Icon(
                          status == 'active' ? Icons.check_circle : Icons.block,
                          color: status == 'active' ? const Color.fromARGB(255, 7, 157, 7) : const Color.fromARGB(255, 203, 25, 9),
                        ),
                        onPressed: () async {
                          final newStatus = status == 'active' ? 'blocked' : 'active';
                          try {
                            await _userService.updateUserStatus(user.id, newStatus);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'User ${newStatus == 'active' ? 'unblocked' : 'blocked'} successfully!'),
                              ),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error: $e')),
                            );
                          }
                        },
                      ),
                      // Promote/Demote Admin
                      IconButton(
                        icon: Icon(
                          isAdmin ? Icons.person : Icons.person_outline,
                          color: isAdmin ? Colors.blue : Colors.grey,
                        ),
                        onPressed: () async {
                          final newRole = !isAdmin;
                          try {
                            await _userService.updateUserRole(user.id, newRole);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'User role updated to ${newRole ? 'Admin' : 'User'} successfully!'),
                              ),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error: $e')),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}