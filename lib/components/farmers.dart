import 'package:flutter/material.dart';
import 'dart:developer';
import '../models/crop.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Timestamp
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth to get current user ID
import 'edit_crop_form.dart'; // Import the EditCropForm

class FarmersList extends StatelessWidget {
  const FarmersList({super.key});

  @override
  Widget build(BuildContext context) {
    final User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      // Handle the case where the user is not signed in
      return const Center(child: Text('Please sign in to view your crops.'));
    }

    final String currentFarmerId = currentUser.uid; // Get the current farmer's ID

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'My Dashboard',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
        ),
        // My Crops Section
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'My Crops',
              ),
              const SizedBox(height: 8.0),
              // StreamBuilder for listing crops from Firestore for the current farmer
              Expanded(
                child: StreamBuilder<List<Crop>>(
                  stream: FirebaseFirestore.instance.collection('crops').snapshots().map((snapshot) => snapshot.docs.map((doc) => Crop.fromDocument(doc)).toList()),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active || snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      log('Error fetching crops: ${snapshot.error}', name: 'FarmersList');
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No crops added yet.'));
                    }

                    final crops = snapshot.data!;

                    // Filter crops by the current farmer's ID
                    final farmerCrops = crops.where((crop) => crop.farmerId == currentFarmerId).toList();

                    return ListView.builder(
                      itemCount: farmerCrops.length,
                      itemBuilder: (context, index) {
                        final crop = crops[index];
                        return ListTile(
                          title: Text(crop.name),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Category: ${crop.category}'),
                              Text('Price: ${crop.pricePerUnit} per ${crop.unit}'),
                              Text('Quantity: ${crop.availableQuantity} ${crop.unit}'),
                              Text('Description: ${crop.consumerDescription}'),
                              // Display other relevant farmer-specific details
                            ],
                          ),
                          // You can add edit/delete icons or onTap handlers here
                        );
                         trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                // TODO: Implement edit functionality
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                // TODO: Implement delete functionality
                              },
                            ),
                          ],

                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 8.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddCropForm()),
                  );
                },
                child: const Text('Add Crop'),
              ),
            ],
          ),
        ),
        // Weather Forecast Section
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Weather Forecast',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8.0),
              // Placeholder for weather information
              Text('Fetching weather information...'),
            ],
          ),
        ),
        // Market Prices Section
        // TODO: Add Market Prices Section with placeholder
      ],
      ),
    );
  }
}

// New StatefulWidget for adding a crop
class AddCropForm extends StatefulWidget {
  const AddCropForm({super.key});

  @override
  AddCropFormState createState() => AddCropFormState();
}

class AddCropFormState extends State<AddCropForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _cropNameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  @override
  void dispose() {
    _cropNameController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _saveCrop() {
    if (_formKey.currentState!.validate()) {
      // Create a Crop object from the form data
      final newCrop = Crop(
        // Placeholder values - you'll need to replace these with actual data
        id: '', // Firestore will generate the ID
        name: _cropNameController.text,
        pricePerUnit: double.tryParse(_priceController.text) ?? 0.0,
        unit: 'kg', // Example unit - you might want a dropdown for this
        availableQuantity: int.tryParse(_quantityController.text) ?? 0,
        category: 'Other', // Example category - you might want a dropdown
        consumerDescription: 'Freshly listed crop', // Example description
 farmerId: FirebaseAuth.instance.currentUser!.uid, // Get the current farmer's ID
        timestamp: Timestamp.fromDate(DateTime.now()), // Use current time for timestamp and convert to Timestamp
      );

      // Save the crop to Firestore
      FirestoreService().addCrop(newCrop).then((_) {
        // Show a success message (optional)
        ScaffoldMessenger.of(context).showSnackBar(
 if (!mounted) return;
          const SnackBar(content: Text('Crop listing saved!')),
        );
        // Check if the widget is still mounted before navigating
        if (!mounted) return;
        // Navigate back after successful saving
        Navigator.pop(context);
      }).catchError((error) {
        // Handle errors
        log('Error saving crop: $error', name: 'AddCropForm');
        // Show an error message (optional)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save crop: $error')),
        );
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Crop Listing')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _cropNameController,
                decoration: const InputDecoration(labelText: 'Crop Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter crop name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter quantity';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter price';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveCrop,
                child: const Text('Save Listing'),
              ),
            ],
          ),
        ),
      ),
    );
  }
