
abstract class LoginState {}

class InitialState extends LoginState {
  
}

class LoadingState extends LoginState {

}

class LoadedState extends LoginState {
  bool isSuccessful; // Add this property
  LoadedState({required this.isSuccessful});
}

class LoggedInState extends LoginState{
  
}

class ErrorState extends LoginState {

}
