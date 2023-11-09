class LiveStream {
  final String title;
  final String uid;
  final String image;
  final String username;
  final startedAt;
  final int viewers;
  final String chanalId;

  LiveStream({
    required this.title,
    required this.uid,
    required this.image,
    required this.username,
    required this.chanalId,
    required this.startedAt,
    required this.viewers,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'image': image,
      'uid': uid,
      'username': username,
      'chanalId': chanalId,
      'startedAt': startedAt,
      'viewers': viewers,
    };
  }

  factory LiveStream.fromMap(Map<String, dynamic> map) {
    return LiveStream(
      title: map['title'] ?? '',
      uid: map['uid'] ?? '',
      image: map['image'] ?? '',
      username: map['username'] ?? '',
      chanalId: map['chanalId'] ?? '',
      startedAt: map['startedAt'] ?? '',
      viewers: map['viewers'] ?? '',
    );
  }
}
