import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import '../services/api_service.dart';
import '../models/person.dart';
import '../sqflite/database_helper.dart';

class PersonProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<Person> _people = [];
  int _page = 1;
  bool _isLoading = false;

  List<Person> get people => _people;
  bool get isLoading => _isLoading;

  Future<void> fetchPopularPeople() async {
    _isLoading = true;
    notifyListeners();

    // Check for network connectivity
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      // No internet, load data from local database
      _people = await _databaseHelper.getAllPeople();
    } else {
      try {
        // Fetch data from API
        final newPeople = await _apiService.fetchPopularPeople(_page);

        if (_page == 1) {
          // Clear old local data before saving new data
          await _databaseHelper.deleteAllPeople();
        }

        _people.addAll(newPeople);

        // Save to local database
        for (var person in newPeople) {
          await _databaseHelper.insertPerson(person);
        }

        _page++;
      } catch (error) {
        print(error);
      }
    }

    _isLoading = false;
    notifyListeners();
  }
}
