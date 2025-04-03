import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:game_arcade/controllers/profile_controller.dart';
import 'package:game_arcade/screens/edit_profile_screen.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  late Future<Map<String, dynamic>?> _userProfileFuture;
  late Future<List<Map<String, dynamic>>> _gameStatsFuture;

  @override
  void initState() {
    super.initState();
    _refreshProfileData();
  }

  void _refreshProfileData() {
    final profileController = Provider.of<ProfileController>(context, listen: false);
    _userProfileFuture = profileController.getUserProfile();
    _gameStatsFuture = profileController.getUserGameStats();
  }

  @override
  Widget build(BuildContext context) {
    final profileController = Provider.of<ProfileController>(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _refreshProfileData();
          });
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                
                // My Account title
                const Text(
                  'My Account',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.normal,
                    color: Colors.orange,
                  ),
                ),
                
                const SizedBox(height: 30),
                
                // Profile picture with orange border
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.orange,
                      width: 4.0,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 70,
                    backgroundColor: Colors.black,
                    backgroundImage: const AssetImage('assets/images/profile.png'),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Username
                FutureBuilder<Map<String, dynamic>?>(
                  future: _userProfileFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator(color: Colors.orange);
                    } else if (snapshot.hasError) {
                      return Text(
                        'Error: ${snapshot.error}',
                        style: const TextStyle(color: Colors.red),
                      );
                    } else if (!snapshot.hasData || snapshot.data == null) {
                      return const Text(
                        'No profile data found',
                        style: TextStyle(color: Colors.orange),
                      );
                    }
                    
                    final userData = snapshot.data!;
                    final username = userData['name'] ?? 'User';
                    
                    return Column(
                      children: [
                        Text(
                          username,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.normal,
                            color: Colors.orange,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          userData['email'] ?? 'No email',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    );
                  },
                ),
                
                const SizedBox(height: 24),
                
                // Edit Account Button
                ElevatedButton(
                  onPressed: () async {
                    // Navigate to edit profile screen
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EditProfileScreen(),
                      ),
                    );
                    
                    // Refresh data if profile was updated
                    if (result == true) {
                      setState(() {
                        _refreshProfileData();
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Edit Account',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // My Game Stats
                Align(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'My Game Stats',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                      color: Colors.orange,
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Game stats cards
                FutureBuilder<List<Map<String, dynamic>>>(
                  future: _gameStatsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator(color: Colors.orange));
                    } else if (snapshot.hasError) {
                      return Text(
                        'Error: ${snapshot.error}',
                        style: const TextStyle(color: Colors.red),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Card(
                        color: Color(0xFF1D1D1D),
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(
                            child: Text(
                              'No game stats available yet.\nPlay some games to see your stats!',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.orange),
                            ),
                          ),
                        ),
                      );
                    }
                    
                    final gameStats = snapshot.data!;
                    
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: gameStats.length,
                      itemBuilder: (context, index) {
                        final game = gameStats[index];
                        return Card(
                          color: const Color(0xFF1D1D1D),
                          margin: const EdgeInsets.only(bottom: 12),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                // Game icon placeholder (could be replaced with actual game icon)
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.orange,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.gamepad,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                // Game name and high score
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        game['gameName'] ?? 'Unknown Game',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'High Score: ${game['highScore']}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.orange,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
                
                const SizedBox(height: 32),
                
                // Logout button
                ElevatedButton(
                  onPressed: () {
                    // Show confirmation dialog
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: const Color(0xFF1D1D1D),
                        title: const Text(
                          'Logout',
                          style: TextStyle(color: Colors.orange),
                        ),
                        content: const Text(
                          'Are you sure you want to logout?',
                          style: TextStyle(color: Colors.orange),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              // Close dialog
                              Navigator.pop(context);
                              
                              // Logout and redirect to login screen
                              await profileController.signOut();
                              Navigator.pushReplacementNamed(context, '/login');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.black, // Changed text color from white to black
                            ),
                            child: const Text(
                              'Logout',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.black,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Logout',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}