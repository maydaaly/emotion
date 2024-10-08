import 'package:flutter/material.dart';
import '../models/person_details.dart';
import '../services/api_service.dart';

class PersonDetailsProvider extends ChangeNotifier {
  PersonDetails? personDetails;
  List<String> personImages = [];
  bool isLoading = false;
  String? error;

  final ApiService _apiService = ApiService();

  Future<void> fetchPersonDetails(int personId) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      personDetails = await _apiService.fetchPersonDetails(personId);
      personImages = await _apiService.fetchPersonImages(personId);
    } catch (e) {
      error = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }
}
