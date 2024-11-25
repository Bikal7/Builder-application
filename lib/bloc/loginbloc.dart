import 'package:flutter_bloc/flutter_bloc.dart';
import 'apiservices/apiImpl.dart';
import 'apiservices/apiService.dart';
import 'loginevent.dart';
import 'loginstate.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  Api apiService = ApiImpl();

  LoginBloc() : super(InitialState()) {
    on<SignupEvent>((event, emit) async {
      var response = await apiService.saveDatatoFirestore(
          fullName: event.fullName,
          gender: event.gender,
          password: event.password,
          rePassword: event.rePassword,
          phone: event.phone);
      if (response != null) {
        emit(LoadedState(isSuccessful: response));
      }
    });

//   on<ChangePasswordEvent>((event, emit) async {
//   try {
//     final currentState = state;
//     if (currentState is LoadedState) {
//       var response = await apiService.changePassword(
//         currentPassword: event.currentPassword,
//         newPassword: event.newPassword,
//         confirmPassword: event.confirmPassword,
//       );

//       if (response) {
//         emit(LoadedState(isSuccessful: true));
//       } else {
//         emit(LoadedState(isSuccessful: false));
//       }
//     }
//   } catch (e) {
//     print("Error changing password: $e");
//   }
// });


    on<AddMaterialsEvent>((event, emit) async{
      var response=await apiService.addMaterials(
        bName: event.bName,
        sHead: event.sHead,
        materials: event.materials,
        image: event.image,
        phone: event.phone,
        address: event.address,
        latitude: event.latitude,
        longitude: event.longitude
      );
      if(response!=null){
        emit(LoadedState(isSuccessful: response));
      }
    },);

    on<AddProfessionsEvent>((event, emit) async{
      var response=await apiService.addProfessions(
        wName: event.wName,
        Exp: event.Exp,
        Phone: event.Phone,
        Profession: event.Profession,
        image: event.image,
        address: event.address,
        latitude: event.latitude,
        longitude: event.longitude
      );
      if(response!=null){
        emit(LoadedState(isSuccessful: response));
      }
    },);

    // ignore: void_checks
  on<LoginEvents>((event, emit) async {
  var response = await apiService.checkCredientialforLogin(
    phone: event.phone, password: event.password
  );
  if (response != null) {
    emit(LoadedState(isSuccessful: !response));
  }
});

    on<RegisterEvent>((event, emit) async {
      var response = await apiService.checkCredentialForRegister(
        phone: event.phone,
      );
      if (response != null) {
        emit(LoadedState(isSuccessful: response));
      }
    });
  }
}

