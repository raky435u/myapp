import 'package:flutter/material.dart';
import 'dart:developer';


class FarmersList extends StatelessWidget {
  const FarmersList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
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
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8.0),
              // Placeholder for listing crops
              Text('No crops added yet.'),
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
      // Process saving the crop data
      log('Saving crop:', name: 'AddCropForm');
      log('  Name: ${_cropNameController.text}', name: 'AddCropForm');
      log('  Quantity: ${_quantityController.text}', name: 'AddCropForm');
      log('  Price: ${_priceController.text}', name: 'AddCropForm');

      // After saving, you might want to close the form or navigate back
      Navigator.pop(context);
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
}
