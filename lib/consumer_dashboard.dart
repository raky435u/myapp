import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:myapp/main.dart';
// Assuming you have a Crop model
// Assuming you have a service to fetch crops
// Assuming you have this component
// Assuming you have this component
// Assuming a generic sign-in/up form component

class ConsumerDashboard extends StatefulWidget {
  const ConsumerDashboard({super.key});

  @override
  _ConsumerDashboardState createState() => _ConsumerDashboardState();
}

class _ConsumerDashboardState extends State<ConsumerDashboard> {
  bool _showSignInUp = true; // Flag to show sign-in/up initially
  String _selectedCategory = 'All';
  final List<String> _categories = ['All', 'Fruits', 'Vegetables', 'Grains']; // Example categories

  List<Crop> _crops = [];
  List<Crop> _filteredCrops = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCrops();
  }

  Future<void> _fetchCrops() async {
    try {
      final cropService = CropService(); // Assuming CropService has a default constructor
      final fetchedCrops = await cropService.fetchCrops(); // Assuming a fetchCrops method
      setState(() {
        _crops = fetchedCrops;
        _isLoading = false;
        _filterCrops(); // Filter initially based on 'All'
      });
    } catch (e) {
      // Handle errors
      if (kDebugMode) {
        print('Error fetching crops: $e');
      } // Consider using a proper logging mechanism
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _filterCrops() {
    if (_selectedCategory == 'All') {
      _filteredCrops = _crops;
    } else {
      _filteredCrops = _crops
          .where((crop) => crop.category == _selectedCategory) // Assuming Crop model has a 'category' field
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_showSignInUp) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Welcome'),
        ),
        body: Center(
          child: SignInUpForm( // Assuming SignInUpForm handles sign-in/up and has a callback
            onSignInUpSuccess: () {
              setState(() {
                _showSignInUp = false; // Hide form on successful sign-in/up
              });
            },
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Consumer Dashboard'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Category selection (example using a Row of Chips)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _categories.map((category) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: FilterChip(
                            label: Text(category),
                            selected: _selectedCategory == category,
                            onSelected: (selected) {
                              if (selected) {
                                setState(() {
                                  _selectedCategory = category;
                                  _filterCrops(); // Filter when category changes
                                });
                              }
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                // Crop List
                Expanded(
                  child: ListView.builder(
                    itemCount: _filteredCrops.length,
                    itemBuilder: (context, index) {
                      final crop = _filteredCrops[index];
                      return ListTile(
                        title: Text(crop.name), // Assuming Crop model has a 'name' field
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Category: ${crop.category}'), // Assuming Crop model has a 'category' field
                            Text('Description: ${crop.consumerDescription}'), // Display consumer description
                            // Add farmer information here if available in the Crop model
                            // Example:
                            // Text('Farmer: ${crop.farmerName}'),
                          ],
                        ),
                        // You can add a trailing widget or an onTap handler to navigate to a detailed view
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
  
  CropService() {}
  
  SignInUpForm({required Null Function() onSignInUpSuccess}) {}
}