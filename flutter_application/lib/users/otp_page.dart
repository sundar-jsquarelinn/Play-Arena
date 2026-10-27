import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OtpPage extends StatefulWidget {
  final String phoneNumber;
  final String verificationId;
  const OtpPage({super.key,required this.phoneNumber,required this.verificationId});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final _otpController = TextEditingController();
  final _formKey= GlobalKey<FormState>();
  String? _otpServerError;

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Verify OTP"),
      ),
      body: Padding(
        padding:EdgeInsets.all(20.0) ,
      child: Form(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Enter a 6 digit code send to ${widget.phoneNumber}',
            textAlign:TextAlign.center
            ),
            SizedBox(height: 20,),
            TextFormField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24,letterSpacing: 8),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(6)
              ],
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                errorText: _otpServerError
              ),
              validator: (value) 
              {
                if(value ==  null || value.isEmpty)
                {
                  return "Enter OTP";
                }
                if(value.length<6) return "OTP Must be 6 digits";
                return null;
              },
            ),
            SizedBox(height: 20,),
            ElevatedButton(onPressed:_verifyAndConfirmOtp, child: 
            Text("Confirm & Verify")
            )
          ],
      )),
      ),
    );
  }

  void _verifyAndConfirmOtp() async {
  setState(() {
    _otpServerError = null;
  });

  // 1. ADD LOGS TO CHECK IF VALIDATION PASSES
  print("Button Clicked. Form Valid: ${_formKey.currentState?.validate()}");

  if (_formKey.currentState!.validate()) {
    try {
      print("Starting Firebase verification...");
      print("Verification ID: ${widget.verificationId}");
      print("SMS Code: ${_otpController.text.trim()}");

      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId, 
        smsCode: _otpController.text.trim(),
      );
      print("Credential object generated successfully.");
      
      // 2. TIMEOUT PROTECTION FOR NETWORK HANGS
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential)
          .timeout(const Duration(seconds: 15), onTimeout: () {
            throw FirebaseAuthException(
              code: 'timeout',
              message: 'Connection timed out. Please check your internet connection.',
            );
          });
          
      print("Firebase Auth Success! User ID: ${userCredential.user?.uid}");

      if (!mounted) return;
      
      // 3. FORCE CLOSE SNACKBARS AND POP WITH TRUE
      ScaffoldMessenger.of(context).clearSnackBars();
      Navigator.of(context).pop(true); 
      print("Navigation Pop executed.");
      
    } on FirebaseAuthException catch (e) {
      print("Firebase Error Code: ${e.code}");
      print("Firebase Error Message: ${e.message}");
      setState(() {
        if (e.code == 'invalid-verification-code') {
          _otpServerError = "The OTP code entered is incorrect";
        } else if (e.code == "session-expired") {
          _otpServerError = "OTP code expired. Please request a new one";
        } else {
          _otpServerError = e.message ?? "Verification failed";
        }
      });
      
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_otpServerError ?? "Invalid OTP. Please Try Again!"),
          backgroundColor: Colors.redAccent,
        ),
      );
    } catch (e, stackTrace) {
      print("CRITICAL NON-FIREBASE ERROR: $e");
      print("STACK TRACE: $stackTrace");
    }
  }
}
}