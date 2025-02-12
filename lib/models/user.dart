class UserModel {
  String? name;
  String? bio;
  String? userId;
  String? profilePic;
  String? createdAt;
  bool? isAdmin;
  List<String>? plantsId;

  UserModel(
      {this.bio,
      this.name,
      this.userId,
      this.plantsId,
      this.createdAt,
      this.profilePic,
      this.isAdmin = false});

  UserModel.fromJson(Map<dynamic, dynamic>? map) {
    if (map == null) {
      return;
    }
    name = map['name'];
    bio = map['bio'];
    userId = map['userId'];
    createdAt = map['createdAt'];
    profilePic = map['profilePic'];
    isAdmin = map['isAdmin'];
    if (map['plantsId'] != null) {
      plantsId = <String>[];
      map['plantsId'].forEach(
        (String value) {
          plantsId!.add(value);
        },
      );
    }
  }
  toJson() {
    return <String, Object?>{
      'bio': bio,
      'name': name,
      'createdAt': createdAt,
      'userId': userId,
      'plantsId': plantsId,
      'profilePic': profilePic,
      'isAdmin': isAdmin,
    };
  }

  UserModel copyWith({
    String? name,
    String? bio,
    String? userId,
    String? createdAt,
    String? profilePic,
    bool? isAdmin,
    List<String>? plantsId,
  }) {
    return UserModel(
      bio: bio ?? this.bio,
      name: name ?? this.name,
      userId: userId ?? this.userId,
      plantsId: plantsId ?? this.plantsId,
      createdAt: createdAt ?? this.createdAt,
      profilePic: profilePic ?? this.profilePic,
      isAdmin: isAdmin ?? this.isAdmin,
    );
  }
}
