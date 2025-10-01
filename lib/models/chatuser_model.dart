class ChatUserModel {
  final String uid;
  final String name;
  final String email;
  final String imageUrl;
  late DateTime lastActive;
  ChatUserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.imageUrl,
    required this.lastActive,
  });

  factory ChatUserModel.fromJSON(Map<String, dynamic> json) {
    return ChatUserModel(
      uid: json['uid'],
      name: json['name'],
      email: json['email'],
      imageUrl: json['image'],
      lastActive: json["last_active"].toDate(),
    );
  }
  Map<String, dynamic> toMap() {
    return {
      "email": email,
      "name": name,
      "last_active": lastActive,
      "image": imageUrl,
    };
  }

  String lastDayActive() {
    return "${lastActive.month}/${lastActive.day}/${lastActive.year}";
    //Si la différence est inférieure à 2 heures, la méthode renverra true
  }

  bool wasRecentlyActive() {
    return DateTime.now().difference(lastActive).inHours < 2;
  }
}
