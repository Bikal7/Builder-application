import 'package:builder/customButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'otp.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  String? phone;
  final _formkey = GlobalKey<FormState>();

  // Function to save the phone number to SharedPreferences
  savePhoneToSP(String phone) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("PhoneOtp", phone);
  }


  void _showSuccessDialog(int phone) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success'),
          content: Text('OTP sent to +977$phone.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void sendOtp() async {
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+977$phone',
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance.signInWithCredential(credential);
          _showSuccessDialog(int.parse(phone!));
        },
        verificationFailed: (FirebaseAuthException e) {
          _showErrorDialog('Verification failed. Please try again later.');
        },
        codeSent: (String verificationId, int? resendToken) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OtpVerificationScreen(
                verificationId: verificationId,
                phone: int.parse(phone!),
              ),
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      _showErrorDialog('An error occurred. Please try again later.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Forgot Password',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 50,right: 10,left: 10),
        child: Form(
          key: _formkey,
          child: Column(
            children: [
              Image.asset("assets/images/immigration.png", width: 100, height: 100,),
              const SizedBox(height: 20,),
              TextFormField(
                decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
              borderSide: BorderSide(
                width: 1,
                color: Color.fromARGB(255, 207, 198, 198),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 1,
                color: Color.fromARGB(255, 207, 198, 198),
              ),
            ),
                  prefixIcon: Icon(
                    Icons.phone,
                    color: Colors.grey,
                  ),
                  hintText: "Phone",
                ),
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(10),
                ],
                validator: ((value) {
                  if (value!.isEmpty) {
                    return "Fields are required to be filled";
                  } else if (value.length < 10) {
                    return "Phone number must have 10 digits";
                  }
                  return null;
                }),
                onChanged: (value) {
                  setState(() {
                    phone = value;
                  });
                  savePhoneToSP(value);
                },
              ),
              const SizedBox(height: 10),
              CusButton(
                text: "Send Otp",
                onPressed: (){
                  if (_formkey.currentState!.validate()){
                    sendOtp();
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
