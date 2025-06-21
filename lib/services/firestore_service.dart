import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/crop.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Add a new crop document to the 'crops' collection
  Future<void> addCrop(Crop crop) async {
    await _db.collection('crops').add(crop.toMap());
  }

  // Fetch all crop documents from the 'crops' collection
  Future<List<Crop>> getCrops() async {
    QuerySnapshot snapshot = await _db.collection('crops').get();
    return snapshot.docs.map((doc) => Crop.fromDocument(doc)).toList();
  }

  // Provide a real-time stream of crop documents from the 'crops' collection
  Stream<List<Crop>> streamCrops() {
    return _db.collection('crops').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Crop.fromDocument(doc)).toList());
  }

  // Delete a crop document from the 'crops' collection by its ID
  Future<void> deleteCrop(String cropId) async {
    await _db.collection('crops').doc(cropId).delete();
  }

  // Update an existing crop document in the 'crops' collection by its ID
  Future<void> updateCrop(String cropId, Crop updatedCrop) async {
    await _db.collection('crops').doc(cropId).update(updatedCrop.toMap());
  }
}