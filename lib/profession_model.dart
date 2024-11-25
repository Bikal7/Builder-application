import 'package:cloud_firestore/cloud_firestore.dart';

class ProfeesionModel {
  final String id;
  final String imageUrl;
  final String wName, profession;
  final int phone,exp;
  String?distance;
  String? latitude,longitude,address;

  ProfeesionModel({
    required this.id,
    required this.imageUrl,
    required this.exp,
    required this.phone,
    required this.profession,
    required this.wName,
    this.latitude,
    this.longitude,
    this.address,
    this.distance,
  });

  factory ProfeesionModel.fromSnapshot(DocumentSnapshot snapshot) {
  final data = snapshot.data() as Map<String, dynamic>;
  return ProfeesionModel(
    id: snapshot.id,
    wName: data['wName'] ?? '',
    exp: data['Exp'] ?? '',
    profession: data['Profession'] ?? '',
    phone: data['Phone'] ?? '',
    imageUrl: data['ImageURL'] ?? '',
    address: data['Address']??'',
    latitude: data['Latitude']??'',
    longitude: data['Longitude']??''
  );
  }
}
