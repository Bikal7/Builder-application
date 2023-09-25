
import 'package:builder/bloc/loginstate.dart';
import 'package:builder/bottomNav.dart';
import 'package:builder/forgot_pw_page.dart';
import 'package:builder/register.dart';
import 'package:flutter/material.dart';
import 'package:builder/cutomForm.dart';
import 'package:builder/customButton.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bloc/loginbloc.dart';
import 'bloc/loginevent.dart';



class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

void showInvalidCredentialsSnackbar(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.white,
      elevation: 8.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      behavior: SnackBarBehavior.floating,
      content: const Text(
        "Invalid Credentials",
        style: TextStyle(
          color: Colors.red,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
      duration: const Duration(seconds: 2),
    ),
  );
}


class _LoginState extends State<Login> {
  bool isVisible = false;
  int? phone;
  String? password;
  final _formkey = GlobalKey<FormState>();

  saveValueToSharedPreference() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLogin', true);
    await prefs.setInt("Phone", phone!);
    }

  void _resetLoginForm() {
    setState(() {
      _formkey.currentState!.reset();
      password = null;
    });
  }

  Future<void> _navigateAfterDelay(BuildContext context) async {
    await Future.delayed(const Duration(milliseconds: 10));
    // ignore: use_build_context_synchronously
    Navigator.push(context, MaterialPageRoute(builder: (context) => const bottomNav()));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc,LoginState>(
      listener: (context, state) {
    if (state is LoadedState) {
      if (state.isSuccessful) {
        saveValueToSharedPreference();
        _resetLoginForm();
        _navigateAfterDelay(context);
      } else {
        showInvalidCredentialsSnackbar(context);
      }
    }
  },
      child: Scaffold(
        body:SafeArea(
          child: SingleChildScrollView(
            child: Form(
              key: _formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 120, bottom: 15),
                      child: Image.asset(
                        "assets/images/architect.png",
                        width: 80,
                        height: 62,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "Login to your account",
                          style: TextStyle(
                            fontSize: 24,
                            color: Color(
                              0xff000000,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  CustomForm(
                    prefixIcon: const Icon(
                      Icons.phone,
                      color: Colors.grey,
                    ),
                    hintText: "Phone",
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                LengthLimitingTextInputFormatter(10),
              ],
                    validator: ((value) {
                      if (value!.isEmpty) {
                        return "field are required to be filled";
                      } else if (value.length < 10) {
                        return "Phone number must have 10 digits";
                      }
                
                      return null;
                    }),
                    onChanged: (value) {
                      setState(() {
                        phone = int.parse(value);
                      });
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomForm(
                    prefixIcon: const Icon(
                      Icons.lock,
                      color: Colors.grey,
                    ),
                    obscureText: isVisible ? false : true,
                    hintText: "Password",
                    suffixIcon: isVisible
                        ? IconButton(
                            onPressed: () {
                              setState(() {
                                isVisible = false;
                              });
                            },
                            icon: const Icon(Icons.visibility))
                        : IconButton(
                            onPressed: () {
                              setState(() {
                                isVisible = true;
                              });
                            },
                            icon: const Icon(Icons.visibility_off)),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter your password";
                      } else if (!RegExp(r'^.{8,}$').hasMatch(value)) {
                        return "Password must be at least 8 characters long";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        password = value;
                      });
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8, top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>const ForgotPassword()));
                          },
                          child: const Text(
                            "Forget password?",
                            style: TextStyle(
                              color: Color(0xff1777AB,),
                              fontSize: 18,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  CusButton(
                    primary: const Color(
                      0xff1777AB,
                    ),
                    text: "Login",
                    fontsize: 18,
                    color: const Color(
                      0xffFFFFFF,
                    ),
                    onPressed: () {
                      if (_formkey.currentState!.validate()) {
                      BlocProvider.of<LoginBloc>(context)
                      .add(LoginEvents(phone: phone, password: password));
                    } 
                    },
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account?",
                          style: TextStyle(
                              color: Color(0xff000000), fontSize: 18),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: ((context) =>
                                        const RegisterForm())));
                          },
                          child: const Text(
                            "Sign up",
                            style: TextStyle(
                                color: Color(0xff1777AB,),
                                fontSize: 18),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}