
class User {
  final String uid;
  final String username;
  final String email;

  User({required this.uid, required this.email, required this.username});

  Map<String, dynamic> toMap() {
    return {'uid': uid, 'username': username, 'email': email};
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      username: map['username'] ?? '',
    );
  }
}