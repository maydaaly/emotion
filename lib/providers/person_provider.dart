import 'package:flutter/material.dart';
import '../models/person.dart';
import '../services/api_service.dart';

class PersonProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Person> _people = [];
  int _page = 1;
  bool _isLoading = false;

  List<Person> get people => _people;
  bool get isLoading => _isLoading;

  Future<void> fetchPopularPeople() async {
    _isLoading = true;
    notifyListeners();
    try {
      final newPeople = await _apiService.fetchPopularPeople(_page);
      _people.addAll(newPeople);
      _page++;
    } catch (error) {
      print(error);
    }
    _isLoading = false;
    notifyListeners();
  }
}
