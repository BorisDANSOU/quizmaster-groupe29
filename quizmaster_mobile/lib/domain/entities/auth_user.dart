class AuthUser {
  const AuthUser({
    required this.uid,
    this.email,
    this.displayName,
    this.photoUrl,
    this.isAnonymous = false,
  });

  final String uid;
  final String? email;
  final String? displayName;
  final String? photoUrl;
  final bool isAnonymous;

  factory AuthUser.fromMap(Map<String, dynamic> map) {
    return AuthUser(
      uid: (map['uid'] ?? '').toString(),
      email: map['email']?.toString(),
      displayName: map['displayName']?.toString(),
      photoUrl: map['photoUrl']?.toString(),
      isAnonymous: map['isAnonymous'] == true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'isAnonymous': isAnonymous,
    };
  }
}