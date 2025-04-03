class SignupModel {
  final String name;
  final String email;
  final String password;
  final bool isAdmin;

  SignupModel({
    required this.name,
    required this.email,
    required this.password,
    this.isAdmin = false, // Default to false for regular users
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'isAdmin': isAdmin,
    };
  }
}