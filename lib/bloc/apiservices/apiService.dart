import 'dart:io';

import 'package:builder/profession_model.dart';
import 'package:builder/profile_model.dart';

import '../../material_model.dart';

abstract class Api {
  saveDatatoFirestore(
      {String? fullName,
      String? gender,
      String?address,
      String? password,
      String? rePassword,
      int? phone});
  Future<bool> changePassword({
    String? currentPassword,
    String? newPassword,
    String? confirmPassword,
  });
  Future<bool>changeOtpPw({
    String? newPassword,
    String? confirmPassword,
  });
  checkCredientialforLogin({int? phone, String? password});
  checkCredentialForRegister({int? phone});
  addMaterials({String?bName,String?sHead,String?materials,File?image,int?phone,String?address,String?longitude,String?latitude});
  addProfessions({String?wName,int?Exp,int?Phone,String?Profession,File?image});
  Future<List<MaterialModel>> getMaterials(String material);
  Future<List<ProfeesionModel>> getProfessions(String profession);
  Future<bool> deleteMaterial(int phone);
  Future<bool> updateMaterial({
    required String id,
    String? bName,
    String? sHead,
    String? materials,
    int? phone,
    File? image,
  });
  Future<MaterialModel?> getMaterialById(String materialId);
  Future<bool>deleteProfession(int phone);
    Future<bool> updateProfession({
    required String id,
    String? wName,
    String? profession,
    int? phone,
    int?exp,
    File? image,
  });
  Future<ProfeesionModel?> getProfessionById(String professionId);
  Future<bool> updateProfile({
    String? fullname,
    String? address,
    String?gender,
    int? phone,
    File? image,
  });
  Future<ProfileModel?>getProfileById(String profileId);
}
