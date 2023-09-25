import 'dart:io';

import 'package:builder/material_model.dart';
import 'package:builder/profession_model.dart';
import 'package:builder/profile_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'apiService.dart';

class ApiImpl extends Api {
  bool success = false;
  bool notRegistered = false;
  bool alreadyRegistered = false;

  @override
  saveDatatoFirestore({
    String? fullName,
    String?address,
    String? gender,
    String? password,
    String? rePassword,
    int? phone,
  }) async {
    var response = {
      "fullname": fullName,
      "Gender": gender,
      "Password": password,
      "Repassword": rePassword,
      "Address":address,
      "Phone": phone,
    };

try {
    var querySnapshot = await FirebaseFirestore.instance
      .collection("Signup")
          .where("Phone", isEqualTo: phone)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        Fluttertoast.showToast(
          msg: "Phone number already exists",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        await FirebaseFirestore.instance.collection("Signup").add(response);
        success = true;
      }
    } catch (e) {
      success = false;
      print(e);
    }
    return success; 
  }

  

  @override
  checkCredentialForRegister({int? phone}) async {
    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection("Signup")
          .where("Phone", isEqualTo: phone)
          .get();

      if (querySnapshot.docs.isEmpty) {
        alreadyRegistered = false;
      } else {
        alreadyRegistered = true;
      }
    } catch (e) {
      alreadyRegistered = true;
    }
    return alreadyRegistered;
  }
  
  @override
  checkCredientialforLogin({int? phone, String? password})async {
    try {
      await FirebaseFirestore.instance
          .collection("Signup")
          .where("Phone", isEqualTo: phone)
          .where("Password", isEqualTo: password)
          .get()
          .then((value) {
        if (value.docs.isEmpty) {
          notRegistered = true;
        } else {
          notRegistered = false;
        }
      });
    } catch (e) {
      notRegistered = false;
    }
    return notRegistered;
  }

  @override
  addMaterials({
    String? bName,
    String? sHead, 
    String? materials,
    int?phone, 
    File? image,
    String?address,
    String?longitude,
    String?latitude})async {

      String? imageUrl;
      if (image != null) {
        imageUrl = await uploadImageToFirebaseStorage(image);
      }
      var data = {
        "bName": bName,
        "sHead": sHead,
        "Phone":phone,
        "Material": materials,
        "ImageURL": imageUrl,
        "Address":address,
        "Latitude":latitude,
        "Longitude":longitude, 
      };
      
    await FirebaseFirestore.instance.collection("Materials").where("Phone", isEqualTo: phone).get().then((value)async{
      if (value.docs.isNotEmpty){
        Fluttertoast.showToast(
          msg: "Phone number already exists",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
        );
      }else{
        try {
        await FirebaseFirestore.instance
              .collection("Materials")
              .add(data)
              .then((value) {
            success = true;
          });
        } catch (e) {
          success = false;
          print(e);
        }
      }
      });
  }
  
  @override
  addProfessions({String? wName, int? Exp, int? Phone, String? Profession, File? image}) async{  
      String? imageUrl;
      if (image != null) {
        imageUrl = await uploadImageToFirebaseStorage(image);
      }
      var data = {
        "wName":wName,
        "Exp":Exp,
        "Phone":Phone,
        "Profession":Profession,
        "ImageURL": imageUrl,
      };

    await FirebaseFirestore.instance.collection("Professions").where("Phone", isEqualTo: Phone).get().then((value)async{
      if (value.docs.isNotEmpty){
        Fluttertoast.showToast(
          msg: "Phone number already exists",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
        );
      }else{
        try {
        await FirebaseFirestore.instance
              .collection("Professions")
              .add(data)
              .then((value) {
            success = true;
          });
        } catch (e) {
          success = false;
          print(e);
        }
      }
    }); 
  }

  Future<String?> uploadImageToFirebaseStorage(File imageFile) async {
    try {
      var storageRef = FirebaseStorage.instance.ref().child("images/${DateTime.now().toString()}");
      UploadTask uploadTask = storageRef.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask.whenComplete(() {});
      String imageUrl = await snapshot.ref.getDownloadURL();
      
      return imageUrl;
    } catch (e) {
      return null;
    }
  }

@override
Future<List<MaterialModel>> getMaterials(String material) async {
  try {
    var querySnapshot = await FirebaseFirestore.instance.collection('Materials').get();
    return querySnapshot.docs
    
        .map((doc) => MaterialModel.fromSnapshot(doc))
        .where((materialModel) => materialModel.materials?.toUpperCase().contains(material.toUpperCase()) ?? false)
        .toList();
  } catch (e) {
    print("Error fetching Materials data: $e");
    return [];
  }
}

@override
Future<List<ProfeesionModel>> getProfessions(String profession) async{
  try {
    var querySnapshot = await FirebaseFirestore.instance.collection('Professions').where("Profession", isEqualTo: profession).get();
    return querySnapshot.docs.map((doc) => ProfeesionModel.fromSnapshot(doc))
    .where((professionModel) => professionModel.profession.toUpperCase().contains(profession.toUpperCase()))
    .toList();
  } catch (e) {
    print("Error fetching Professions data: $e");
    return [];
  }
}



@override
  Future<bool> deleteMaterial(int phone) async {
  try {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("Materials")
        .where("Phone", isEqualTo: phone)
        .get();

    for (DocumentSnapshot doc in querySnapshot.docs) {
      await doc.reference.delete();
     success=true;
    }
  } catch (e) {
   print(e);
   success=false;
  }
  return success;
}
  

 @override
  Future<bool> updateMaterial({
    required String id,
    String? bName,
    String? sHead,
    String? materials,
    int? phone,
    File? image,
  }) async {
    try {
      String? imageUrl;
      if (image != null) {
        imageUrl = await uploadImageToFirebaseStorage(image);
      }
      var data = {
        "bName": bName,
        "sHead": sHead,
        "Phone": phone,
        "Material": materials,
        "ImageURL": imageUrl,
      };

      await FirebaseFirestore.instance
          .collection("Materials")
          .doc(id) // Use the document ID to update the specific material
          .update(data);

      if (imageUrl != null) {
      await FirebaseFirestore.instance
      .collection('Signup')
      .doc(id)
      .update({"ImageURL": imageUrl});
    }
      
      return true;
    } catch (e) {
      print("Error updating material data: $e");
      return false;
    }
  }

    @override
  Future<MaterialModel?> getMaterialById(String materialId) async {
    try {
      var docSnapshot = await FirebaseFirestore.instance
          .collection('Materials')
          .doc(materialId)
          .get();

      if (docSnapshot.exists) {
        // Convert the Firestore document snapshot to a MaterialModel object
        MaterialModel material = MaterialModel.fromSnapshot(docSnapshot);
        return material;
      } else {
        // Return null if the material with the provided ID does not exist
        return null;
      }
    } catch (e) {
      print('Error fetching material data by ID: $e');
      return null;
    }
  }
  
  @override
  Future<bool> deleteProfession(int phone) async{
    try {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("Professions")
        .where("Phone", isEqualTo: phone)
        .get();

    for (DocumentSnapshot doc in querySnapshot.docs) {
      await doc.reference.delete();
     success=true;
    }
  } catch (e) {
   print(e);
   success=false;
  }
  return success;
    
  }
  
  @override
  Future<ProfeesionModel?> getProfessionById(String professionId)async {
    try {
      var docSnapshot = await FirebaseFirestore.instance
          .collection('Professions')
          .doc(professionId)
          .get();

      if (docSnapshot.exists) {
        ProfeesionModel profession = ProfeesionModel.fromSnapshot(docSnapshot);
        return profession;
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching material data by ID: $e');
      return null;
    }
  }
  
  @override
  Future<bool> updateProfession({
    required String id,
    String? wName, 
    String? profession, 
    int? phone, 
    int? exp, 
    File? image}) async{
      try{
        String? imageUrl;
        if (image != null) {
        imageUrl = await uploadImageToFirebaseStorage(image);
      }
      var data = {
        "wName":wName,
        "Exp":exp,
        "Phone":phone,
        "Profession":profession,
        "ImageURL": imageUrl,
      };
      await FirebaseFirestore.instance
          .collection("Materials")
          .doc(id) // Use the document ID to update the specific material
          .update(data);

      if (imageUrl != null) {
      await FirebaseFirestore.instance
      .collection('Signup')
      .doc(id)
      .update({"ImageURL": imageUrl});
    }
      
      return true;
    }catch (e) {
      print("Error updating material data: $e");
      return false;
    }
  }
  
@override
  Future<bool> updateProfile({
    String? gender,
    String? fullname,
    String? address,
    int? phone,
    File? image,
  }) async {
     var userId=await getIdForUpdate();
    try {
      String? imageUrl;
      if (image != null) {
        imageUrl = await uploadImageToFirebaseStorage(image);
      }

      var data = {
        "fullname": fullname,
        "Address": address,
        "Gender": gender,
        "Phone": phone,
        "ImageURL": imageUrl,
      };

      // Update the profile document using the provided ID
      await FirebaseFirestore.instance
          .collection('Signup')
          .doc(userId)
          .update(data).then((value){
            success=true;
          }); 
          
      if (imageUrl != null) {
      await FirebaseFirestore.instance
          .collection('Signup')
          .doc(userId)
          .update({"ImageURL": imageUrl});
    }
    } catch (e) {
      success=false;
    }
    return success;
  }

  @override
  Future<ProfileModel?> getProfileById(String profileId) async {
    try {
      var docSnapshot = await FirebaseFirestore.instance
          .collection('Signup')
          .doc(profileId)
          .get();

      if (docSnapshot.exists) {
        // Convert the Firestore document snapshot to a ProfileModel object
        ProfileModel profile = ProfileModel.fromSnapshot(docSnapshot);
        return profile;
      } else {
        return null; // Return null if the profile with the provided ID does not exist
      }
    } catch (e) {
      print('Error fetching profile data by ID: $e');
      return null;
    }
  }

  getPhoneFormSP()async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int? phone=prefs.getInt("Phone")??0;
    return phone;
  }
  
  getIdForUpdate()async{
    var phone=await getPhoneFormSP();
    var user;
    if(phone!=0){
      var response=await FirebaseFirestore.instance.collection('Signup')
      .where("Phone",isEqualTo: phone).get();
      user=response.docs.first;
    }
    return user.id;
  }
  
  @override
  Future<bool> changePassword({
    String? currentPassword,
    String? newPassword,
    String? confirmPassword,
  }) async {
    bool success = false;
    try {
      var userId = await getIdForUpdate();
      var phone = await getPhoneFormSP();
      var response = {
        "Password": newPassword,
        "Repassword": confirmPassword,
      };
      var querySnapshot = await FirebaseFirestore.instance
          .collection("Signup")
          .where("Phone", isEqualTo: phone)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        var user = querySnapshot.docs.first;
        if (user.data()["Password"] == currentPassword) {
          await FirebaseFirestore.instance
              .collection('Signup')
              .doc(userId)
              .update(response);
          success = true;
        } else {
          Fluttertoast.showToast(
            msg: "Please enter the current password correctly",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
      }
    } catch (e) {
      print("Error changing password: $e");
      success = false;
    }

    return success;
  }
  
 @override
Future<bool> changeOtpPw({String? newPassword, String? confirmPassword}) async {
  bool success = false;
  try {
    var userId = await getIdForForgotPw();
    var phone = await getPhoneFormSPForOtp();
    var response = {
      "Password": newPassword,
      "Repassword": confirmPassword,
    };
    var querySnapshot = await FirebaseFirestore.instance
        .collection("Signup")
        .where("Phone", isEqualTo: phone)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      // ignore: unused_local_variable
      var user = querySnapshot.docs.first;
      await FirebaseFirestore.instance.collection('Signup').doc(userId).update(response);
      success = true;
    } else {
      Fluttertoast.showToast(
        msg: "User doesn't exist for the given number",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  } catch (e) {
    print("Error changing password: $e");
    success = false;
  }

  return success;
}

getPhoneFormSPForOtp() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? phone = prefs.getString("PhoneOtp") ?? "";
  return phone;
}

getIdForForgotPw() async {
  var phone = await getPhoneFormSPForOtp();
  var user;
  if (phone != null && phone.isNotEmpty) {
    var response = await FirebaseFirestore.instance.collection('Signup').where("Phone", isEqualTo: phone).get();
    if (response.docs.isNotEmpty) {
      user = response.docs.first;
    }
  }
  return user?.id ?? "";
}

}


