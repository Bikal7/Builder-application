import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:builder/customButton.dart';
import 'package:builder/cutomForm.dart';
import 'package:builder/login.dart';

import 'bloc/loginbloc.dart';
import 'bloc/loginstate.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _formKey = GlobalKey<FormState>();
  bool isPasswordVisible = false;
  bool isNPasswordVisible = false;
  bool isConPasswordVisible = false;
  String? currentPassword, newPassword, confirmPassword;

  Future<void> _submitData() async {
    try {
      bool success = await BlocProvider.of<LoginBloc>(context).apiService.changePassword(
        currentPassword: currentPassword,
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
          return SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back_ios_new_outlined),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.02,
                  ),
                  const Text(
                    "Change Password",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              const Padding(
                padding: EdgeInsets.only(right: 195),
                child: Text(
                  "Current Password",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              CustomForm(
                obscureText: !isPasswordVisible,
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      isPasswordVisible = !isPasswordVisible;
                    });
                  },
                  icon: Icon(isPasswordVisible
                      ? Icons.visibility_outlined
                      : Icons.visibility_off),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "password field must be filled up";
                  } else {
                    return null;
                  }
                },
                onChanged: (value) {
                  setState(() {
                    currentPassword = value;
                  });
                },
              ),
              const SizedBox(
                height: 4,
              ),
              const Padding(
                padding: EdgeInsets.only(right: 220),
                child: Text(
                  "New Password",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              CustomForm(
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
              const Padding(
                padding: EdgeInsets.only(right: 195),
                child: Text(
                  "Confirm Password",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              CustomForm(
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
          );
        },
      ),
    );
  }
}
