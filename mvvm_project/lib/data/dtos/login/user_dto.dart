class UserDto {
  final String id;
  final String userName;
  final String role;

  const UserDto({
    required this.id,
    required this.userName,
    required this.role,
});

  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      id: (json['id'] ?? '').toString(),
      userName: (json['userName'] ?? '').toString(),
      role: (json['role'] ?? 'user').toString(),
    );
  }

  factory UserDto.fromMap(Map<String, dynamic> map) {
    return UserDto(
      id: (map['id'] ?? '').toString(),
      userName: (map['userName'] ?? map['username'] ?? map['user_name'] ?? '').toString(),
      role: (map['role'] ?? 'user').toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'userName': userName,
    'role': role,
  };
}
