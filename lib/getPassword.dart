import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/loginbloc.dart';
import 'bloc/loginstate.dart';
import 'customButton.dart';
import 'cutomForm.dart';
import 'login.dart';

class GetPassword extends StatefulWidget {
  const GetPassword({super.key});

  @override
  State<GetPassword> createState() => _GetPasswordState();
}

class _GetPasswordState extends State<GetPassword> {
  final _formKey = GlobalKey<FormState>();
  bool isNPasswordVisible = false;
  bool isConPasswordVisible = false;
  String? newPassword, confirmPassword;

    Future<void> _submitData() async {
    try {
      bool success = await BlocProvider.of<LoginBloc>(context).apiService.changeOtpPw(
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );

      if (success) {  
        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (BuildContext context) => const Login()),
            (route) => false,
          );
        }
      }
    } catch (e) {
      print("Error submitting data: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          if (state is LoadedState) {
            if (state.isSuccessful) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Login()),
              );
            } else {
              
            }
          }
          return Padding(
            padding: const EdgeInsets.only(top: 50),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: SafeArea(
                  child: Column(
                    children: [
                      const Text("Insert new password",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,),
                      const SizedBox(height: 10,),
                  CustomForm(
                    hintText: "New Password",
                    obscureText: !isNPasswordVisible,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          isNPasswordVisible = !isNPasswordVisible;
                        });
                      },
                      icon: Icon(isNPasswordVisible
                          ? Icons.visibility_outlined
                          : Icons.visibility_off),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "password field must be filled up";
                      } else if (!RegExp((r'\d')).hasMatch(value)) {
                        return "Password must contain at least one digit\n";
                      } else if (!RegExp((r'\W')).hasMatch(value)) {
                        return "Password must contain at least one symbol\n";
                      } else {
                        return null;
                      }
                    },
                    onChanged: (value) {
                      setState(() {
                        newPassword = value;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  CustomForm(
                    hintText: "ReType Password",
                    obscureText: !isConPasswordVisible,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          isConPasswordVisible = !isConPasswordVisible;
                        });
                      },
                      icon: Icon(isConPasswordVisible
                          ? Icons.visibility_outlined
                          : Icons.visibility_off),
                    ),
                    validator: ((value) {
                      if (value!.isEmpty) {
                        return "password field must be filled up";
                      } else if (newPassword != value) {
                        return "password does not match";
                      }
                      return null;
                    }),
                    onChanged: (value) {
                      setState(() {
                        confirmPassword = value;
                      });
                    },
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  CusButton(
                    primary: const Color(0xFF1777AB),
                    text: "Change",
                    onPressed: () {
                      setState(() {});
                      if (_formKey.currentState!.validate()) {
                        _submitData();
                      }
                    },
                  ),
                            ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}