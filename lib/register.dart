
import 'package:builder/cutomForm.dart';
import 'package:builder/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:builder/customButton.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/loginbloc.dart';
import 'bloc/loginevent.dart';
import 'bloc/loginstate.dart';



class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  bool isVisible = false;
  bool isVisible2=false;
  String? password, cpassword, fullname,address,email;
  int? phone;
  List<String> genderList = ['Male', 'Female', 'Others'];
  String? selectedGender;
  final _formKey = GlobalKey<FormState>();

  Future<void> _submitData() async {
    try {
      BlocProvider.of<LoginBloc>(context).add(SignupEvent(
        fullName: fullname,
        gender: selectedGender,
        password: password,
        phone: phone,
        rePassword: cpassword,
        address: address,
      ));
    } catch (e) {
      print("Error submitting data: $e");
    }
  }

  void _resetForm() {
    setState(() {
      _formKey.currentState!.reset();
      fullname=null;
      selectedGender=null;
      password=null;
      phone=null;
      address=null;
      cpassword=null;
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:SafeArea(
        child: Form(
         key: _formKey,
          child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 100),
                      child: Center(
                        child: Image.asset(
                          "assets/images/architect.png",
                          width: 80,
                          height: 62,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const Center(
                        child: Text(
                      "Create an account",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w400,
                      ),
                    )),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomForm(
                        onChanged: (value) {
                          setState(() {
                            fullname = value;
                          });
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter your full name";
                          } else if (!RegExp("(?=.*[A-Z])").hasMatch(value)) {
                            return "Fullname must contain at least one uppercase letter\n";
                          }
                          return null;
                        },
                        hintText: 'Enter your full name',
                        prefixIcon: const Icon(
                          Icons.person_outline_outlined,
                          color: Colors.grey,
                        )),
                        const SizedBox(
                      height: 10,
                    ),
                    CustomForm(
                        onChanged: (value) {
                          setState(() {
                            address = value;
                          });
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter your address";
                          } else if (!RegExp("(?=.*[A-Z])").hasMatch(value)) {
                            return "Address contain at least one uppercase letter\n";
                          }
                          return null;
                        },
                        hintText: 'Enter your address',
                        prefixIcon: const Icon(
                          Icons.location_city_outlined,
                          color: Colors.grey,
                        )),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                      child: Container(
                        decoration: const BoxDecoration(boxShadow: [
                          BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.1),
                              blurRadius: 2,
                              offset: Offset(0, 0.05),
                              spreadRadius: 1),
                        ]),
                        child: DropdownButtonFormField(
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.people_alt,
                              color: Colors.grey,
                            ),
                            hintText: "Gender",
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0)),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 20.0, horizontal: 10.0),
                          ),
                          value: selectedGender,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please select your gender";
                            }
                            return null;
                          },
                          onChanged: (newValue) {
                            setState(() {
                              selectedGender = newValue;
                            });
                          },
                          items: genderList.map((gender) {
                            return DropdownMenuItem(
                              child: Text(gender),
                              value: gender,
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomForm(
                      inputFormatters: [LengthLimitingTextInputFormatter(10)],
                      validator: ((value) {
                        if (value!.isEmpty) {
                          return "field are required to be filled";
                        } else if (value.length < 10) {
                          return "Phone number must have 10 digits";
                        }
                        
                        return null;
                      }),
                      hintText: 'Enter your phone number',
                      keyboardType: TextInputType.number,
                      prefixIcon: const Icon(
                        Icons.phone,
                        color: Colors.grey,
                      ),
                      onChanged: (value) {
                        phone = int.parse(value);
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomForm(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter your password";
                        } else if (!RegExp(r'^.{8,}$').hasMatch(value)) {
                          return "Password must be at least 8 characters long";
                        }
                        return null;
                      },
                      hintText: 'Enter your password',
                      obscureText: isVisible2 ? false : true,
                      suffixIcon: isVisible2
                        ? IconButton(
                            onPressed: () {
                              setState(() {
                                isVisible2 = false;
                              });
                            },
                            icon: const Icon(Icons.visibility))
                        : IconButton(
                            onPressed: () {
                              setState(() {
                                isVisible2 = true;
                              });
                            },
                            icon: const Icon(Icons.visibility_off)),
                      onChanged: (value) {
                        setState(() {
                          password = value;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomForm(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Retype your password";
                        } else if (password != value) {
                          return "password doesn't match";
                        }
                        return null;
                      },
                      hintText: 'Retype your password',
                      obscureText: isVisible ? false : true,
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
                      onChanged: (value) {
                        cpassword = value;
                      },
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    CusButton(
                      primary: const Color.fromARGB(255, 36, 85, 123),
                      fontsize: 16,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _submitData();
                          _resetForm();
                        }
                      },
                      text: "Register",
                      color: Colors.white,
                    ),
                      BlocListener<LoginBloc, LoginState>(
                        listener: (context, state) {
                        if (state is LoadedState) {
                          if (state.isSuccessful) {
                            _showSnackBar("Data sent successfully");
                            // Navigate to the login page after registration
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Login(), // Redirect to Login screen
                          ),
                        );
                          } else {
                            _showSnackBar("Data not sent");
                          }
                        }
                      },
                      child:Container()
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Already have an account",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>const Login() ));
                              },
                              child: const Text(
                                "Sign In",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ))
                        ],
                      ),
                    )
                  ],
                ),
              ),
        ),
      ),);
  }
}