import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:developer';

class CropService {
  final String apiUrl = "https://savefarmer.vibhaitsolutions.in/api/crops";

  Future<List> getCrops() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        Iterable list = json.decode(response.body);
        return list.map((model) => Crop.fromJson(model)).toList();
      } else {
        // Handle non-200 status codes
        log('Failed to load crops: ${response.statusCode}', name: 'CropService');
        return []; // Return an empty list or throw an exception
      }
    } catch (e) {
      // Handle network errors or other exceptions
      log('Error fetching crops: $e', name: 'CropService');
      return []; // Return an empty list or throw an exception
    }
  }

  Future fetchCrops() async {}
}

class Crop {
  late String name;

  var category;

  var consumerDescription;

  static fromJson(model) {}
}

// TODO Implement this library.
