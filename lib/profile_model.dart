import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileModel {
  final String id; // The document ID
  final String imageUrl;
  final int phone;
  final String address;
  final String fullname;
  final String gender;

  ProfileModel({
    required this.id,
    required this.address,
    required this.fullname,
    required this.gender,
    required this.imageUrl,
    required this.phone,
  });

  factory ProfileModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return ProfileModel(
      id: snapshot.id, // Accessing the document ID correctly
      fullname: data['fullname'] ?? '',
      gender: data['Gender'] ?? '',
      address: data['Address'] ?? '',
      phone: data['Phone'] ?? 0, // You should specify a default value here
      imageUrl: data['ImageURL'] ?? '',
    );
  }
}
