class TeamMember {
  final String id;
  final DateTime createdAt;
  final String name;
  final String? city;
  final String? phoneNumber;

  TeamMember({
    required this.id,
    required this.createdAt,
    required this.name,
    this.city,
    this.phoneNumber,
  });

  factory TeamMember.fromJson(Map<String, dynamic> json) {
    return TeamMember(
      id: json['id'],
      createdAt: DateTime.parse(json['created_at']),
      name: json['name'],
      city: json['city'],
      phoneNumber: json['phone_number'],
    );
  }
}
