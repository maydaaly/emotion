class Person {
  final int id;
  final String name;
  final String profilePath;
  final double popularity;

  Person({
    required this.id,
    required this.name,
    required this.profilePath,
    required this.popularity,
  });

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      id: json['id'],
      name: json['name'],
      profilePath: json['profile_path'] ?? '',
      popularity: json['popularity']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'profilePath': profilePath,
      'popularity': popularity,
    };
  }
}
