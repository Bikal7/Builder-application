import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

import '../bloc/loginbloc.dart';
import '../bloc/loginevent.dart';
import '../bloc/loginstate.dart';
import '../customButton.dart';
import '../cutomForm.dart';

class MaterialForm extends StatefulWidget {
  const MaterialForm({Key? key}) : super(key: key);

  @override
  State<MaterialForm> createState() => _MaterialFormState();
}

class _MaterialFormState extends State<MaterialForm> {
  List<String> materialList = ['Brick', 'Cement', 'Glass', 'Sand', 'Metal', 'Lumber', 'Electronics'];
  List<String> selectedItems = [];
  String? bName, sHead,address,longitude,latitude;
  int?phone;
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

  void _submitData() async {
    if (selectedItems.isNotEmpty) {
      try {
        String materialsString = selectedItems.join(', ');
        BlocProvider.of<LoginBloc>(context).add(AddMaterialsEvent(
          bName: bName,
          sHead: sHead,
          materials: materialsString,
          phone: phone,
          image: _selectedImage,
          address: address,
          longitude: longitude,
          latitude: latitude,
        ));
      } catch (e) {
        print("Error submitting data: $e");
      }
    } else {
      print("Please select at least one material before submitting.");
    }
  }
  

  void _resetForm() {
    setState(() {
      _formKey.currentState!.reset();
      bName = null;
      sHead = null;
      selectedItems = [];
      _selectedImage = null;
      address=null;
      longitude=null;
      latitude=null;
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
          body: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back_ios),
                    ),
                    const SizedBox(width: 1),
                    const Text('Materials Details', style: TextStyle(fontSize: 24)),
                  ],
                ),
                const SizedBox(height: 5,),
                CustomForm(
                  onChanged: (value) {
                    setState(() {
                      bName = value;
                    });
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter the Business name";
                    } else if (!RegExp("(?=.*[A-Z])").hasMatch(value)) {
                      return "Business name must contain at least one uppercase letter\n";
                    }
                    return null;
                  },
                  hintText: 'Enter the Business name',
                  prefixIcon: const Icon(
                    Icons.business,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                CustomForm(
                  onChanged: (value) {
                    setState(() {
                      sHead = value;
                    });
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter the sub-heading";
                    } else if (!RegExp("(?=.*[A-Z])").hasMatch(value)) {
                      return "Sub-heading name must contain at least one uppercase letter\n";
                    }
                    return null;
                  },
                  hintText: 'Supplier Name',
                  prefixIcon: const Icon(
                    Icons.person,
                    color: Colors.grey,
                  ),
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
                        phone = intValue;
                      });
                    } 
                    });
                  },
                ),
                const SizedBox(
                  height: 5,
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
                  height: 5,
                ),
                CustomForm(
                  prefixIcon: const Icon(
                    Icons.location_on,
                    color: Colors.grey,
                  ),
                  hintText: "Longitude",
                  validator: ((value) {
                  if (value!.isEmpty) {
                      return "Field are required to be filled";
                    }
                  return null;
                  }),
                  onChanged:(value) {
                          setState(() {
                            longitude = value;
                          });
                        },
                ),
                const SizedBox(
                  height: 5,
                ),
                CustomForm(
                  prefixIcon: const Icon(
                    Icons.location_on,
                    color: Colors.grey,
                  ),
                  hintText: "Latitude",
                  validator: ((value) {
                  if (value!.isEmpty) {
                      return "Field are required to be filled";
                    }
                  return null;
                  }),
                  onChanged: (value) {
                          setState(() {
                            latitude = value;
                          });
                        },
                ),
                const SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                  child: Container(
                    decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.1),
                      blurRadius: 2,
                      offset: Offset(0, 0.05),
                      spreadRadius: 1,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(12.0),
                  color: Colors.white,
                  ),
                  child: MultiSelectDialogField(
                      items: materialList
                      .map((material) => MultiSelectItem<String>(material, material))
                      .toList(),
                    listType: MultiSelectListType.CHIP,
                    buttonIcon:const Icon(Icons.arrow_drop_down,color: Colors.grey,size: 35,),
                    onConfirm: (List<String> values) {
                      setState(() {
                        selectedItems = values;
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                    return "Please select the materials";
                      }
                      return null;
                    },
                    initialValue: selectedItems,
                    title: const Text("Materials"),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      color: Colors.white,
                    ),
                  ),
                  ),
                ),
                
                const SizedBox(height: 10),
                TextButton(
                  onPressed: _pickImage,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.add_a_photo, color: Colors.grey,),
                      SizedBox(width: 10),
                      Text('Upload Image', style: TextStyle(color: Colors.grey),),
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
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _submitData();
                      _resetForm();
                    }
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
      ),
    );
  }
}


