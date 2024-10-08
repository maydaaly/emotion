class PersonDetails {
  final String name;
  final String biography;
  final String? birthday;
  final String? placeOfBirth;
  final List<String> alsoKnownAs;
  final int gender;
  final String imdbId;
  final String knownForDepartment;
  final double popularity;
  final String? homepage;

  PersonDetails({
    required this.name,
    required this.biography,
    this.birthday,
    this.placeOfBirth,
    required this.alsoKnownAs,
    required this.gender,
    required this.imdbId,
    required this.knownForDepartment,
    required this.popularity,
    this.homepage,
  });

  factory PersonDetails.fromJson(Map<String, dynamic> json) {
    return PersonDetails(
      name: json['name'],
      biography: json['biography'],
      birthday: json['birthday'],
      placeOfBirth: json['place_of_birth'],
      alsoKnownAs: List<String>.from(json['also_known_as']),
      gender: json['gender'],
      imdbId: json['imdb_id'],
      knownForDepartment: json['known_for_department'],
      popularity: (json['popularity'] as num).toDouble(),
      homepage: json['homepage'],
    );
  }
}
