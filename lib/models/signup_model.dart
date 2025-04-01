class SignupModel {
  final String name;
  final String email;
  final String password;

  SignupModel({
    required this.name,
    required this.email,
    required this.password,
  });

  // Convert SignupModel to Map for easier handling (if needed)
  Map<String, String> toMap() {
    return {
      'name': name,
      'email': email,
      'password': password,
    };
  }

  // Factory method to create a SignupModel from a Map (if needed)
  factory SignupModel.fromMap(Map<String, String> map) {
    return SignupModel(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
    );
  }
}