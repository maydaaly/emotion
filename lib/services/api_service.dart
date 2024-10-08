import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/person.dart';
import '../models/person_details.dart';

class ApiService {
  final String apiKey = '30107d1d7b6e5d235bcd29cc97674d6c';
  final String baseUrl = 'https://api.themoviedb.org/3';

  // Fetch popular people
  Future<List<Person>> fetchPopularPeople(int page) async {
    final response = await http.get(
      Uri.parse('$baseUrl/person/popular?api_key=$apiKey&language=en-US&page=$page'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['results'] as List).map((json) => Person.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load popular people');
    }
  }

  // Fetch details of a specific person
  Future<PersonDetails> fetchPersonDetails(int personId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/person/$personId?api_key=$apiKey&language=en-US'),
    );

    if (response.statusCode == 200) {
      return PersonDetails.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load person details');
    }
  }

  // Fetch images
  Future<List<String>> fetchPersonImages(int personId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/person/$personId/images?api_key=$apiKey'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<String> images = [];

      for (var profile in data['profiles']) {
        images.add(profile['file_path']);
      }
      return images;
    } else {
      throw Exception('Failed to load person images');
    }
  }
}
