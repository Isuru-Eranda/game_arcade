import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:game_arcade/controllers/profile_controller.dart';
import 'package:game_arcade/widget/text_field.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  
  bool _isLoading = false;
  bool _isPasswordVisible = false;
  Map<String, dynamic>? _userData;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
    });
    
    final profileController = Provider.of<ProfileController>(context, listen: false);
    final userData = await profileController.getUserProfile();
    
    if (userData != null) {
      setState(() {
        _userData = userData;
        _nameController.text = userData['name'] ?? '';
        _emailController.text = userData['email'] ?? '';
      });
    }
    
    setState(() {
      _isLoading = false;
    });
  }

  void _updateProfile() async {
    // Validate inputs
    if (_nameController.text.trim().isEmpty || _emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Username and email are required')),
      );
      return;
    }
    
    final profileController = Provider.of<ProfileController>(context, listen: false);
    
    setState(() {
      _isLoading = true;
    });
    
    // Update profile info
    final result = await profileController.updateProfile(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
    );
    
    if (result == "success") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
      Navigator.pop(context, true); // Return true to indicate profile was updated
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating profile: $result')),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _updatePassword() async {
    // Validate inputs
    if (_currentPasswordController.text.trim().isEmpty || 
        _newPasswordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Both current and new password are required')),
      );
      return;
    }
    
    if (_newPasswordController.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('New password must be at least 6 characters')),
      );
      return;
    }
    
    final profileController = Provider.of<ProfileController>(context, listen: false);
    
    setState(() {
      _isLoading = true;
    });
    
    // Update password
    final result = await profileController.updatePassword(
      currentPassword: _currentPasswordController.text.trim(),
      newPassword: _newPasswordController.text.trim(),
    );
    
    setState(() {
      _isLoading = false;
    });
    
    if (result == "success") {
      // Clear password fields
      _currentPasswordController.clear();
      _newPasswordController.clear();
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password updated successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating password: $result')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            color: Colors.orange,
            fontSize: 24, // Increased font size from default
            fontWeight: FontWeight.normal, // Changed from bold to normal
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.orange),
          onPressed: () => Navigator.pop(context),
        ),
        toolbarHeight: 120, // Increased from default (56) to add more space
      ),
      body: _isLoading && _userData == null
          ? const Center(child: CircularProgressIndicator(color: Colors.orange))
          : SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0), // Added top padding (30.0)
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Information Section
                  const Text(
                    'Profile Information',
                    style: TextStyle(
                      fontSize: 22, // Increased font size
                      fontWeight: FontWeight.normal, // Changed from bold to normal
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFieldInput(
                    icon: Icons.person,
                    textEditingController: _nameController,
                    hintText: 'Username',
                    textInputType: TextInputType.text,
                  ),
                  TextFieldInput(
                    icon: Icons.email,
                    textEditingController: _emailController,
                    hintText: 'Email',
                    textInputType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _updateProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 3,
                              ),
                            )
                          : const Text('Save Changes', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Change Password Section
                  const Text(
                    'Change Password',
                    style: TextStyle(
                      fontSize: 22, // Increased font size
                      fontWeight: FontWeight.normal, // Changed from bold to normal
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFieldInput(
                    icon: Icons.lock,
                    textEditingController: _currentPasswordController,
                    hintText: 'Current Password',
                    textInputType: TextInputType.text,
                    isPass: !_isPasswordVisible,
                  ),
                  TextFieldInput(
                    icon: Icons.lock_outline,
                    textEditingController: _newPasswordController,
                    hintText: 'New Password',
                    textInputType: TextInputType.text,
                    isPass: !_isPasswordVisible,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Row(
                      children: [
                        Checkbox(
                          value: _isPasswordVisible,
                          onChanged: (value) {
                            setState(() {
                              _isPasswordVisible = value ?? false;
                            });
                          },
                          fillColor: MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.selected)) {
                                return Colors.orange;
                              }
                              return Colors.grey;
                            },
                          ),
                        ),
                        const Text(
                          'Show password',
                          style: TextStyle(color: Colors.orange),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _updatePassword,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 3,
                              ),
                            )
                          : const Text('Update Password', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}