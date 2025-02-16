class VoterUser {
  final String id;
  final DateTime createdAt;
  final String name;
  final String? profile;
  final String? number;

  VoterUser({
    required this.id,
    required this.createdAt,
    required this.name,
    this.profile,
    this.number,
  });

  factory VoterUser.fromJson(Map<String, dynamic> json) {
    return VoterUser(
      id: json['id'],
      createdAt: DateTime.parse(json['created_at']),
      name: json['name'],
      profile: json['profile'],
      number: json['number'],
    );
  }
}
