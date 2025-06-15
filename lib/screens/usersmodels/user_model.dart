// models/user_model.dart

class UserModel {
  final String? uid;
  final String name;
  final String email;
  final String? phoneNumber;
  final String? profileImageUrl;
  final bool? isEmailVerified;

  UserModel({
    this.uid,
    required this.name,
    required this.email,
    this.phoneNumber,
    this.profileImageUrl,
    this.isEmailVerified,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String documentId) {
    return UserModel(
      uid: documentId,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phoneNumber: map['phoneNumber'],
      profileImageUrl: map['profileImageUrl'],
      isEmailVerified: map['isEmailVerified'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'profileImageUrl': profileImageUrl,
      'isEmailVerified': isEmailVerified,
    };
  }
}
