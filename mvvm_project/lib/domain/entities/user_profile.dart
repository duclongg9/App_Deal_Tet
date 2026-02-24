class UserProfile {
  final String id;
  final String fullName;
  final DateTime birthDate;
  final String address;

  const UserProfile({
    required this.id,
    required this.fullName,
    required this.birthDate,
    required this.address,
  });

  UserProfile copyWith({
    String? id,
    String? fullName,
    DateTime? birthDate,
    String? address,
  }) {
    return UserProfile(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      birthDate: birthDate ?? this.birthDate,
      address: address ?? this.address,
    );
  }

  String get initials {
    final parts = fullName.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '?';
    return parts.last[0].toUpperCase();
  }
}
