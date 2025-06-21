import 'package:flutter/material.dart';
import '../models/crop.dart';
import '../services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Timestamp

class EditCropForm extends StatefulWidget {
  final Crop crop;

  const EditCropForm({Key? key, required this.crop}) : super(key: key);

  @override
  _EditCropFormState createState() => _EditCropFormState();
}

class _EditCropFormState extends State<EditCropForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _cropNameController;
  late TextEditingController _quantityController;
  late TextEditingController _priceController;
  late TextEditingController _unitController;
  late TextEditingController _categoryController;
  late TextEditingController _consumerDescriptionController;

  @override
  void initState() {
    super.initState();
    _cropNameController = TextEditingController(text: widget.crop.name);
    _quantityController =
        TextEditingController(text: widget.crop.availableQuantity.toString());
    _priceController =
        TextEditingController(text: widget.crop.pricePerUnit.toString());
    _unitController = TextEditingController(text: widget.crop.unit);
    _categoryController = TextEditingController(text: widget.crop.category);
    _consumerDescriptionController =
        TextEditingController(text: widget.crop.consumerDescription);
  }

  @override
  void dispose() {
    _cropNameController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    _unitController.dispose();
    _categoryController.dispose();
    _consumerDescriptionController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      // Create an updated Crop object from the form data
      final updatedCrop = Crop(
        id: widget.crop.id, // Use the original ID
        name: _cropNameController.text,
        pricePerUnit: double.tryParse(_priceController.text) ?? 0.0,
        unit: _unitController.text,
        availableQuantity: int.tryParse(_quantityController.text) ?? 0,
        category: _categoryController.text,
        consumerDescription: _consumerDescriptionController.text,
        farmerId: widget.crop.farmerId, // Use the original farmerId
        timestamp: widget.crop.timestamp, // Use the original timestamp
      );

      // Save the updated crop to Firestore
      FirestoreService().updateCrop(widget.crop.id, updatedCrop).then((_) {
        // Show a success message (optional)
 if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Crop listing updated!')),
        );
        // Check if the widget is still mounted before navigating
 if (!mounted) return;
        // Navigate back after successful saving
        Navigator.pop(context);
      }).catchError((error) {
        // Handle errors
        // Show an error message (optional)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update crop: $error')),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Crop Listing'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
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
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _unitController,
                decoration: const InputDecoration(labelText: 'Unit'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter unit';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(labelText: 'Category'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter category';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _consumerDescriptionController,
                decoration: const InputDecoration(labelText: 'Consumer Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveChanges,
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}