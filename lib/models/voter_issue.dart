class VoterIssue {
  final String id;
  final DateTime createdAt;
  final String createdBy;
  final String title;
  final String category;
  final String description;
  final String location;
  final String desireSolution;
  final List<String> attachedPhotos; // Changed to List<String>
  final List<String> attachedVideos; // Changed to List<String>
  final List<String> attachedDocs; // Changed to List<String>
  final String status;
  final String? solver;

  VoterIssue({
    required this.id,
    required this.createdAt,
    required this.createdBy,
    required this.title,
    required this.category,
    required this.description,
    required this.location,
    required this.desireSolution,
    this.attachedPhotos = const [], // Initialize with empty list
    this.attachedVideos = const [], // Initialize with empty list
    this.attachedDocs = const [], // Initialize with empty list
    required this.status,
    this.solver,
  });

  factory VoterIssue.fromJson(Map<String, dynamic> json) {
    return VoterIssue(
      id: json['id'],
      createdAt: DateTime.parse(json['created_at']),
      createdBy: json['created_by'],
      title: json['title'],
      category: json['category'],
      description: json['description'],
      location: json['location'],
      desireSolution: json['desire_solution'],
      attachedPhotos: (json['attached_photos'] as List<dynamic>?)
              ?.cast<String>()
              .toList() ??
          [], // Handle null and cast
      attachedVideos: (json['attached_videos'] as List<dynamic>?)
              ?.cast<String>()
              .toList() ??
          [], // Handle null and cast
      attachedDocs:
          (json['attached_docs'] as List<dynamic>?)?.cast<String>().toList() ??
              [], // Handle null and cast
      status: json['status'],
      solver: json['solver'],
    );
  }
}
