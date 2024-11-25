import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CusButton extends StatelessWidget {
  final Function()? onPressed;
  final Color? textcolor;
  final String? text;
  final Color? primary;
  final Color? color; // Changed this to a final property
  double? fontsize;
  FontWeight? fontWeight;

  CusButton({
    Key? key, // Added Key? key parameter
    this.onPressed,
    this.text,
    this.primary,
    this.textcolor,
    this.color,
    this.fontsize,
    this.fontWeight,
  }) : super(key: key); // Added super call with key parameter

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              // primary: primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              text!,
              style: TextStyle(
                color: textcolor, // Use 'textcolor' for text color
                fontSize: fontsize,
                fontWeight: fontWeight,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
