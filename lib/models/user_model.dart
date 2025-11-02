class UserModel {
  final String email;
  final String firstName;
  final String lastName;
  final String photoUrl;

  UserModel({required this.email, required this.firstName, required this.lastName, required this.photoUrl});

  factory UserModel.fromMap(Map m) => UserModel(
    email: m['email'] ?? '',
    firstName: m['first_name'] ?? '',
    lastName: m['last_name'] ?? '',
    photoUrl: m['photo_url'] ?? '',
  );

  Map toMap() => {
    'email': email,
    'first_name': firstName,
    'last_name': lastName,
    'photo_url': photoUrl,
  };
}
