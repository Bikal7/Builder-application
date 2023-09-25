// material_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class MaterialModel {
  final String id;
  final String bName;
  final String sHead;
  String? materials;
  int phone;
  late final String address;
  final String imageUrl;
  String?distance;
  String? latitude,longitude;

  MaterialModel({
    required this.id,
    required this.bName,
    required this.sHead,
    this.materials,
    required this.phone,
    required this.address,
    this.distance,
    required this.imageUrl,
    this.latitude,
    this.longitude,
  });

  // Factory method to convert Firestore snapshot to MaterialModel
  factory MaterialModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return MaterialModel(
      id: snapshot.id,
      bName: data['bName'] ?? '',
      sHead: data['sHead'] ?? '',
      materials: data['Material'] ?? '',
      imageUrl: data['ImageURL'] ?? '',
      phone: data['Phone'] ?? '',
      address: data['Address']??'',
      latitude: data['Latitude']??'',
      longitude: data['Longitude']??''
    );
  }
}
