class Person {
  final int id;
  final String name;
  final String profilePath;
  final double popularity;
  final List<KnownFor> knownFor;

  Person({
    required this.id,
    required this.name,
    required this.profilePath,
    required this.popularity,
    required this.knownFor,
  });

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      id: json['id'],
      name: json['name'],
      profilePath: json['profile_path'] ?? '',
      popularity: json['popularity']?.toDouble() ?? 0.0,
      knownFor: (json['known_for'] as List)
          .map((item) => KnownFor.fromJson(item))
          .toList(),
    );
  }
}

class KnownFor {
  final String title;
  final String overview;
  final String posterPath;

  KnownFor({
    required this.title,
    required this.overview,
    required this.posterPath,
  });

  factory KnownFor.fromJson(Map<String, dynamic> json) {
    return KnownFor(
      title: json['title'] ?? '',
      overview: json['overview'] ?? '',
      posterPath: json['poster_path'] ?? '',
    );
  }
}
