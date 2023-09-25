import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: must_be_immutable
class CustomForm extends StatelessWidget {
  String? hintText;
  double? fontSize;
  Function(String)? onChanged;
  TextInputType? keyboardType;
  void Function(String?)? onSaved;
  String? Function(String?)? validator;
  bool obscureText;
  Widget? prefixIcon;
  Widget? suffixIcon;
  List<TextInputFormatter>? inputFormatters;
  int? maxLength;
  String? initialValue;
  bool readOnly;
  Function(String)? onSearch;

  CustomForm({
    Key? key,
    this.onSaved,
    this.readOnly=false,
    this.onSearch,
    this.onChanged,
    this.hintText,
    this.validator,
    this.fontSize,
    this.keyboardType,
    this.inputFormatters,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLength,
    this.initialValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // controller ??= TextEditingController();
    return Padding(
      padding: const EdgeInsets.only(
        left: 10,
        right: 10,
        top: 5,
      ),
      child: TextFormField(
        readOnly: readOnly,
        initialValue: initialValue,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
            borderSide: BorderSide(
              width: 1,
              color: Color.fromARGB(255, 207, 198, 198),
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              width: 1,
              color: Color.fromARGB(255, 207, 198, 198),
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 18,
            horizontal: 10.0,
          ),
          prefixIcon: prefixIcon,
          hintText: hintText,
          suffixIcon: suffixIcon != null
            ? IconButton(
                icon: suffixIcon!,
                onPressed: () {
                  if (onSearch != null) {
                    onSearch!("");
                  }
                },
              )
            : null,
          fillColor: const Color(0xffFFFFFF),
          filled: true,
        ),
        style: TextStyle(
          fontSize: fontSize,
        ),
        validator: validator,
        onSaved: onSaved,
        obscureText: obscureText,
        onChanged: onChanged,
        keyboardType: keyboardType,
        maxLength: maxLength,
      ),
    );
  }
}