
import 'dart:io';

import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  @override
  List<Object> get props => [];
}

// ignore: must_be_immutable
class SignupEvent extends LoginEvent {
  String? fullName, gender, password, rePassword,address;
  int? phone;
  SignupEvent(
      {this.fullName,
      this.gender,
      this.password,
      this.rePassword,
      this.phone,
      this.address,});
}

// ignore: must_be_immutable
class ChangePasswordEvent extends LoginEvent {
  String? currentPassword;
  String? newPassword;
  String? confirmPassword;

  ChangePasswordEvent({
    required this.currentPassword,
    required this.newPassword,
    required this.confirmPassword,
  });
}

// ignore: must_be_immutable
class AddMaterialsEvent extends LoginEvent{
  String? bName,sHead,materials;
  int?phone;
  File? image;
  String? address,longitude,latitude;
  AddMaterialsEvent({this.bName,this.sHead,this.materials,this.image,this.phone
  ,this.address,
  this.latitude,
  this.longitude});
}

// ignore: must_be_immutable
class AddProfessionsEvent extends LoginEvent{
  String?wName,Profession;
  int?Exp,Phone;
  File?image;
  String? address,longitude,latitude;
  AddProfessionsEvent({this.wName,this.Exp,this.Phone,this.Profession,this.image,this.address,
  this.latitude,
  this.longitude});
}

// ignore: must_be_immutable
class LoginEvents extends LoginEvent {
  String? password;
  int? phone;
  LoginEvents({this.phone, this.password});
}
// ignore: must_be_immutable
class RegisterEvent extends LoginEvent{
  int? phone;
  RegisterEvent({this.phone});
}

