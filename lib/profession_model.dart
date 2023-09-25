import 'package:cloud_firestore/cloud_firestore.dart';

class ProfeesionModel {
  final String id;
  final String imageUrl;
  final String wName, profession;
  final int phone,exp;

  ProfeesionModel({
    required this.id,
    required this.imageUrl,
    required this.exp,
    required this.phone,
    required this.profession,
    required this.wName
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
  );
  }
}
