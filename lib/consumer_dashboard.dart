import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:myapp/models/crop.dart';
import 'package:myapp/services/firestore_service.dart';

class FarmersDashboard extends StatefulWidget {
  const FarmersDashboard({Key? key}) : super(key: key);

  @override
  FarmersDashboardState createState() => FarmersDashboardState();
}

class FarmersDashboardState extends State<FarmersDashboard> {
  String _selectedCategory = 'All';
  final List<String> _categories = ['All', 'Fruits', 'Vegetables', 'Grains']; // Example categories

  @override
 Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Farmers Dashboard')),
      body:
 Column(
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
                            // No _filterCrops here, filtering is done in StreamBuilder
 });
 }
                      },
                    ),
                  ),
                }).toList(),
              ),
            ),
          ),
          // Crop List using StreamBuilder
          Expanded(
            child: StreamBuilder<List<Crop>>(
              stream: FirestoreService().getCrops(), // Use FirestoreService stream
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No crops available.'));
                }

                final allCrops = snapshot.data!;
                final filteredCrops = _selectedCategory == 'All'
                    ? allCrops
                    : allCrops
                        .where((crop) => crop.category == _selectedCategory)
                        .toList();

                return ListView.builder(
                  itemCount: filteredCrops.length,
                  itemBuilder: (context, index) {
                    final crop = filteredCrops[index];
 return ListTile(
                      title: Text(crop.name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Add checks for null or missing fields if necessary
                          Text('Category: ${crop.category}'),
                          Text('Price: ${crop.price.toStringAsFixed(2)}'),
                          Text('Quantity: ${crop.quantity}'),
                          // You can add edit/delete buttons here later
                        ],
                      ),
 );
                  },
                );
              },
            ),
          ),
 ],
              ),
    );
  }
}
// TODO Implement this library.