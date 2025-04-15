class UserModel {
  final String id;
  final String username;
  final String email;
  final String ageGroup; // 'Minor' or 'Adult'
  final DateTime createdAt;
  final List<String> reviewIds;

  const UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.ageGroup,
    required this.createdAt,
    this.reviewIds = const [],
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      ageGroup: json['ageGroup'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      reviewIds: (json['reviewIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'ageGroup': ageGroup,
      'createdAt': createdAt.toIso8601String(),
      'reviewIds': reviewIds,
    };
  }

  UserModel copyWith({
    String? id,
    String? username,
    String? email,
    String? ageGroup,
    DateTime? createdAt,
    List<String>? reviewIds,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      ageGroup: ageGroup ?? this.ageGroup,
      createdAt: createdAt ?? this.createdAt,
      reviewIds: reviewIds ?? this.reviewIds,
    );
  }
}

// Mock data for users
final List<UserModel> mockUsers = [
  UserModel(
    id: 'user1',
    username: 'JohnDoe',
    email: 'john.doe@example.com',
    ageGroup: 'Adult',
    createdAt: DateTime.now().subtract(const Duration(days: 30)),
    reviewIds: ['1'],
  ),
  UserModel(
    id: 'user2',
    username: 'JaneSmith',
    email: 'jane.smith@example.com',
    ageGroup: 'Adult',
    createdAt: DateTime.now().subtract(const Duration(days: 25)),
    reviewIds: ['2'],
  ),
  UserModel(
    id: 'user3',
    username: 'TeenRider',
    email: 'teen.rider@example.com',
    ageGroup: 'Minor',
    createdAt: DateTime.now().subtract(const Duration(days: 15)),
    reviewIds: ['3'],
  ),
  UserModel(
    id: 'user4',
    username: 'CommutePro',
    email: 'commute.pro@example.com',
    ageGroup: 'Adult',
    createdAt: DateTime.now().subtract(const Duration(days: 20)),
    reviewIds: ['4'],
  ),
  UserModel(
    id: 'user5',
    username: 'WeekendTraveler',
    email: 'weekend.traveler@example.com',
    ageGroup: 'Adult',
    createdAt: DateTime.now().subtract(const Duration(days: 10)),
    reviewIds: ['5'],
  ),
];

// Helper functions
UserModel? getUserById(String id) {
  try {
    return mockUsers.firstWhere((user) => user.id == id);
  } catch (e) {
    return null;
  }
}

UserModel? getUserByEmail(String email) {
  try {
    return mockUsers.firstWhere((user) => user.email == email);
  } catch (e) {
    return null;
  }
}

UserModel? getUserByUsername(String username) {
  try {
    return mockUsers.firstWhere((user) => user.username == username);
  } catch (e) {
    return null;
  }
}
