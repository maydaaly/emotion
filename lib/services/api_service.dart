import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/person.dart';

class ApiService {
  final String apiKey = '30107d1d7b6e5d235bcd29cc97674d6c';
  final String baseUrl = 'https://api.themoviedb.org/3';

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
}
