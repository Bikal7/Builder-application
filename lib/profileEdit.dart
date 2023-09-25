import 'dart:io';

import 'package:builder/profile_model.dart';
import 'package:builder/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import 'bloc/apiservices/apiImpl.dart';
import 'bloc/apiservices/apiService.dart';
import 'customButton.dart';
import 'cutomForm.dart';

class EditProfile extends StatefulWidget {
  final ProfileModel profile;
  const EditProfile({required this.profile});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  List<String> genderList = ['Male', 'Female', 'Others'];
  String? selectedGender;
  File? _selectedImage;
  String?fullname,address;
  int?phone;
  final Api apiService = ApiImpl();
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

  void _submitData() async {
    if (_formKey.currentState!.validate()) {
      var isUpdated= await apiService.updateProfile(
        fullname: fullname,
        address: address,
        gender: selectedGender,
        phone: phone,
        image: _selectedImage,
      );
      if (isUpdated==true) {
        _showSnackBar("Data updated successfully!");
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Settings()),
      );
      } else {
        _showSnackBar("Failed to update data.");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fullname = widget.profile.fullname;
    address = widget.profile.address;
    selectedGender = widget.profile.gender;
    phone = widget.profile.phone;
    // _selectedImage=widget.profile.imageUrl as File?;
    _fetchProfileData();
  }

  void _resetForm() {
    setState(() {
      _formKey.currentState!.reset();
      fullname = null;
      address = null;
      phone = null;
      selectedGender = null;
      _selectedImage = null;
    });
  }

  
Future<void> _fetchProfileData() async {
  // ignore: unnecessary_null_comparison
  if (widget.profile != null) {
    String profileId = widget.profile.id;
    try {
      ProfileModel? profile = await apiService.getProfileById(profileId);
      setState(() {
        if (profile != null) {
          fullname=profile.fullname;
          phone = profile.phone;
          address=profile.address;
          selectedGender=profile.gender;
          _selectedImage = File(profile.imageUrl);
        }
      });
    } catch (e) {
      print('Error fetching material data: $e');
    }
  }
}

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15, bottom: 10),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back_ios),
                    ),
                    const SizedBox(width: 5),
                    const Text(
                      'Edit Profile',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomForm(
                      initialValue: fullname,
                      onChanged: (value) {
                        setState(() {
                          fullname = value;
                        });
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter your full name";
                        }
                        return null;
                      },
                      prefixIcon: const Icon(
                        Icons.person,
                        color: Color.fromARGB(255, 176, 173, 173),
                      ),
                      hintText: "Full name",
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomForm(
                      initialValue: address,
                      onChanged: (value) {
                        setState(() {
                          address = value;
                        });
                      },
                      validator: ((value) {
                        if (value!.isEmpty) {
                          return "Please enter your address";
                        }
                        return null;
                      }),
                      prefixIcon: const Icon(
                        Icons.location_city,
                        color: Color.fromARGB(255, 176, 173, 173),
                      ),
                      hintText: "Address",
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                      child: Container(
                        decoration: const BoxDecoration(),
                        child: DropdownButtonFormField(
                          value: selectedGender,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
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
                              value: gender,
                              child: Text(gender),
                            );
                          }).toList(),
                          decoration: InputDecoration(
                            enabledBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12.0)),
                              borderSide: BorderSide(
                                  width: 1,
                                  color: Color.fromARGB(
                                      255, 207, 198, 198)), //<-- SEE HERE
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 1, color: Color.fromARGB(255, 207, 198, 198)),
                            ),
                            prefixIcon: const Icon(
                              Icons.people_alt,
                              color: Color.fromARGB(255, 176, 173, 173),
                            ),
                            hintText: "Gender",
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0)),
                            //to increase the height of textform field use content padding
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 15.0, horizontal: 10.0),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomForm(
                      readOnly: true,
                      initialValue: phone != null ? phone.toString() : '',
                      onChanged: (value) {      
                      setState(() {
                        int? intValue = int.tryParse(value);
                        if (intValue != null) {
                          setState(() {
                            phone = intValue;
                          });
                        } 
                      });
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter your phone number";
                        } else if (value.length < 10) {
                          return "Phone number must be valid";
                        }
                        return null;
                      },
                      prefixIcon: const Icon(
                        Icons.phone,
                        color: Color.fromARGB(255, 176, 173, 173),
                      ),
                      hintText: "Phone",
                      inputFormatters: [LengthLimitingTextInputFormatter(10)],
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextButton(
                      onPressed: _pickImage,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.add_a_photo,
                            color: Colors.grey,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Upload Image',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    _selectedImage != null
                    ? Image.file(_selectedImage!, height: 150, width: 150)
                    : widget.profile.imageUrl.isNotEmpty
                    ? Image.network(widget.profile.imageUrl, height: 150, width: 150)
                    : Container(),
                    CusButton(
                      primary: const Color.fromARGB(255, 36, 85, 123),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _submitData();
                          _resetForm();
                        }
                      },
                      text: "Update",
                      fontsize: 16,
                      color: Colors.white,
                    ),
                    const SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
