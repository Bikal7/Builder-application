import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import '../bloc/apiservices/apiImpl.dart';
import '../bloc/apiservices/apiService.dart';
import '../bloc/loginbloc.dart';
import '../bloc/loginstate.dart';
import '../customButton.dart';
import '../cutomForm.dart';
import '../material_model.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class EditMaterial extends StatefulWidget {
  final MaterialModel? material;

  const EditMaterial({Key? key, this.material}) : super(key: key);

  @override
  State<EditMaterial> createState() => _EditMaterialState();
}

class _EditMaterialState extends State<EditMaterial> {
  List<String> materialList = ['Brick', 'Cement', 'Glass', 'Sand', 'Metal', 'Lumber', 'Electronics'];
  List<String> selectedItems = [];
  String? bName, sHead;
  int? phone;
  File? _selectedImage;
  final _formKey = GlobalKey<FormState>();

  final Api apiService = ApiImpl();

  @override
  void initState() {
    super.initState();
    if (widget.material != null) {
      bName = widget.material!.bName;
      sHead = widget.material!.sHead;
      phone = widget.material!.phone;
      selectedItems = widget.material!.materials?.split(', ') ?? [];
      _downloadImage();
      _fetchMaterialData();
      // TODO: Load the image from the provided ImageURL if needed
    }
  }
  
bool _imageLoaded=false;
bool _isLoading=false;
Future<void> _downloadImage() async {
  setState(() {
    _isLoading = true;
  });

  try {
    final response = await http.get(Uri.parse(widget.material!.imageUrl));
    final bytes = response.bodyBytes;

    final appDir = await getApplicationDocumentsDirectory();
    final imageFile = File('${appDir.path}/image.png');
    await imageFile.writeAsBytes(bytes);

    setState(() {
      _selectedImage = imageFile;
      _isLoading = false;
      _imageLoaded = true; // Set image loaded flag
    });
  } catch (error) {
    print("Error downloading image: $error");
    setState(() {
      _isLoading = false;
      _imageLoaded = false; // Set image loaded flag to false on error
    });
  }
}

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  void _resetForm() {
    setState(() {
      _formKey.currentState!.reset();
      bName = null;
      sHead = null;
      phone=null;
      selectedItems = [];
      _selectedImage = null;
    });
  }

  void _submitData() async {
    if (_formKey.currentState!.validate()) {
      if (widget.material != null) {
        bool isUpdated = await apiService.updateMaterial(
          id: widget.material!.id,
          bName: bName,
          sHead: sHead,
          materials: selectedItems.join(', '),
          phone: phone,
          image: _selectedImage,
        );
        if (isUpdated) {
          _showSnackBar("Data updated successfully!");
          Navigator.pop(context);
        } else {
          _showSnackBar("Failed to update data.");
        }
      } else {
      }
    }
  }

Future<void> _fetchMaterialData() async {
  if (widget.material != null) {
    String materialId = widget.material!.id;
    try {
      MaterialModel? material = await apiService.getMaterialById(materialId);
      setState(() {
        if (material != null) {
          bName = material.bName;
          sHead = material.sHead;
          phone = material.phone;
          selectedItems = material.materials?.split(', ') ?? [];
          _selectedImage = File(material.imageUrl); 
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
    return SafeArea(
      child: Form(
        key: _formKey,
        child: Scaffold(
          body: SingleChildScrollView(
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
                    const Text('Update Material Records', style: TextStyle(fontSize: 20)),
                  ],
                ),
                const SizedBox(height: 5,),
                CustomForm(
                  onChanged: (value) {
                    setState(() {
                      bName = value;
                    });
                  },
                  initialValue: bName ?? '',
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
                  initialValue: sHead ?? '',
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter the sub-heading";
                    } else if (!RegExp("(?=.*[A-Z])").hasMatch(value)) {
                      return "Sub-heading name must contain at least one uppercase letter\n";
                    }
                    return null;
                  },
                  hintText: 'Enter the Sub-heading',
                  prefixIcon: const Icon(
                    Icons.info,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                CustomForm(
                  readOnly: true,
                  prefixIcon: const Icon(
                    Icons.phone,
                    color: Colors.grey,
                  ),
                  initialValue: phone != null ? phone.toString() : '',
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
                  child: Center(
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
             _selectedImage != null && _imageLoaded
              ? Image.file(_selectedImage!, height: 150, width: 150)
              : _isLoading
              ? CircularProgressIndicator()
              : widget.material!.imageUrl.isNotEmpty
              ? Image.network(widget.material!.imageUrl, height: 150, width: 150)
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
                  text: "Update",
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
