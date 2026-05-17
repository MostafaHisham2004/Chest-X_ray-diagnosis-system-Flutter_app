class AppUser {
  final int id;
  final String name;
  final String email;
  final bool isAdmin;
  final String role;

  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.isAdmin,
    required this.role,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      isAdmin: json['isAdmin'] == true,
      role: json['role'] as String? ?? 'patient',
    );
  }

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) {
      return email.isNotEmpty ? email[0].toUpperCase() : '?';
    }
    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }
}
