import 'package:builder/bloc/loginevent.dart';
import 'package:builder/cutomForm.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../bloc/loginbloc.dart';
import '../bloc/loginstate.dart';
import '../customButton.dart';

class ProfessionForm extends StatefulWidget {
  const ProfessionForm({super.key});

  @override
  State<ProfessionForm> createState() => _ProfessionFormState();
}

class _ProfessionFormState extends State<ProfessionForm> {
  List<String> professionList = ['Civil Engineer', 'Mason', 'Electrician', 'Carpenter', 'Glazier', 'Plumber', 'Painter'];
  String? selectedItems;
  String?wName,Profession;
  int?Phone,Exp;
  File? _selectedImage;
  final _formKey = GlobalKey<FormState>();

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  Future<void> _submitData() async {
    try {
      BlocProvider.of<LoginBloc>(context).add(AddProfessionsEvent(
        wName: wName,
        Exp: Exp,
        Phone: Phone,
        Profession: selectedItems,
        image: _selectedImage,
      ));
    } catch (e) {
      print("Error submitting data: $e");
    }
  }

  void _resetForm() {
    setState(() {
      _formKey.currentState!.reset();
      wName=null;
      Exp=null;
      Phone=null;
      selectedItems = null;
      _selectedImage = null;
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Form(
        key: _formKey,
        child: Scaffold(
          body: Column(
            children: [
              Row(
                  children: [
                    IconButton(onPressed: (){
                      Navigator.pop(context);
                    }, icon: const Icon(Icons.arrow_back_ios)),
                    const SizedBox(width: 1),
                    const Text('Profession Details', style: TextStyle(fontSize: 24)),
                  ],
                ),
                const SizedBox(height: 5,),
              CustomForm(
                onChanged: (value) {
                  setState(() {
                    wName=value;
                  });
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter the Worker name";
                  } else if (!RegExp("(?=.*[A-Z])").hasMatch(value)) {
                    return "Worker name must contain at least one uppercase letter\n";
                  }
                  return null;
                },
                hintText: 'Entern the Worker name',
                prefixIcon: const Icon(
                  Icons.people,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              CustomForm(
                prefixIcon: const Icon(
                  Icons.calendar_month,
                  color: Colors.grey,
                ),
                hintText: "Experience",
                keyboardType: TextInputType.phone,
                inputFormatters: [LengthLimitingTextInputFormatter(2),],
                validator: ((value) {
                if (value!.isEmpty) {
                    return "Field are required to be filled";
                  }
                return null;
                }),
                onChanged: (value) {      
                  setState(() {
                    int? intValue = int.tryParse(value);
                    if (intValue != null && value.length <= 2) {
                      setState(() {
                      Exp = intValue;
                    });
                  } 
                  });
                },
              ),
              const SizedBox(
                height: 5,
              ),
              CustomForm(
                prefixIcon: const Icon(
                  Icons.phone,
                  color: Colors.grey,
                ),
                hintText: "Phone",
                keyboardType: TextInputType.phone,
                inputFormatters: [LengthLimitingTextInputFormatter(10),],
                validator: ((value) {
                if (value!.isEmpty) {
                    return "Field are required to be filled";
                  }else if (value.length < 10) {
                    return "Phone number must have 10 digits";
                  }
                return null;
                }),
                onChanged: (value) {      
                  setState(() {
                    int? intValue = int.tryParse(value);
                    if (intValue != null) {
                    setState(() {
                      Phone = intValue;
                    });
                  } 
                  });
                },
              ),
              const SizedBox(
                height: 5,
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
                        Icons.work,
                        color: Colors.grey,
                      ),
                      hintText: "Professions",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0)),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 10.0),
                    ),
                    value: selectedItems,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please select the materials";
                      }
                      return null;
                    },
                    onChanged: (newValue) {
                      setState(() {
                        selectedItems = newValue;
                      });
                    },
                    items: professionList.map((profession) {
                      return DropdownMenuItem(
                        child: Text(profession),
                        value: profession,
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: _pickImage,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.add_a_photo,color: Colors.grey,),
                    SizedBox(width: 10),
                    Text('Upload Image',style: TextStyle(color: Colors.grey),),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _selectedImage != null
                  ? Image.file(_selectedImage!, height: 150, width: 150)
                  : Container(),
            const SizedBox(height: 10,),
            CusButton(
              primary: const Color.fromARGB(255, 36, 85, 123),
                        fontsize: 16,
              onPressed: () {
                _submitData();
                _resetForm();
              },
              text: "Upload",
              color: Colors.white,
            ),
            BlocListener<LoginBloc, LoginState>(
                listener: (context, state) {
                  if (state is LoadedState) {
                    if (state.isSuccessful) {
                      _showSnackBar("Data sent successfully");
                    } else {
                      _showSnackBar("Data not sent");
                    }
                  }
                },
                child: Container(), // Add this container as a child if needed
              ),
            ],
          ),
        ),
      ),
    );
  }
}