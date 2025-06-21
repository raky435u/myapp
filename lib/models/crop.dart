import 'package:cloud_firestore/cloud_firestore.dart';

class Crop {
  final String id; // Firestore document ID
  final String name;
  final double pricePerUnit;
  final String unit;
  final int availableQuantity;
  final String category;
  final String consumerDescription;
  final String farmerId;
  final Timestamp timestamp;

  Crop({
    required this.id,
    required this.name,
    required this.pricePerUnit,
    required this.unit,
    required this.availableQuantity,
    required this.category,
    required this.consumerDescription,
    required this.farmerId,
    required this.timestamp,
  });

  // Factory constructor to create a Crop from a Firestore DocumentSnapshot
  factory Crop.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Crop(
      id: doc.id,
      name: data['name'] ?? '',
      pricePerUnit: (data['pricePerUnit'] ?? 0.0).toDouble(),
      unit: data['unit'] ?? '',
      availableQuantity: (data['availableQuantity'] ?? 0).toInt(),
      category: data['category'] ?? '',
      consumerDescription: data['consumerDescription'] ?? '',
      farmerId: data['farmerId'] ?? '',
      timestamp: data['timestamp'] ?? Timestamp.now(),
    );
  }

  // Method to convert a Crop object to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'pricePerUnit': pricePerUnit,
      'unit': unit,
      'availableQuantity': availableQuantity,
      'category': category,
      'consumerDescription': consumerDescription,
      'farmerId': farmerId,
      'timestamp': timestamp,
    };
  }
}
// TODO Implement this library.
