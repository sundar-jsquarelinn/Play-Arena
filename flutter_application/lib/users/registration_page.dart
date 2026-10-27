import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application/users/otp_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  bool _isphoneVerified = false;
  final List<String> _gender = ['Male', 'Female', 'Other'];
  String? _selectedGender;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: Image.asset('assets/Badge.png', height: 40),
        title: const Text(
          "Register",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 50.0),
                  SizedBox(
                    width: 300.0,
                    height: 80.0,
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        hintText: "Full Name",
                        prefixIcon: Icon(Icons.person),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 300.0,
                    height: 80.0,
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        hintText: "Email Address",
                        prefixIcon: Icon(Icons.email),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 300.0,
                    height: 80.0,
                    child: TextFormField(
                      controller: _phoneController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: TextInputType.phone,
                      readOnly: _isphoneVerified,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        hintText: "Phone Number",
                        prefixIcon: Icon(Icons.phone_android),
                        suffixIcon: _isphoneVerified
                            ? Icon(Icons.check_circle, color: Colors.green)
                            : null,
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Please Enter Your Phone Number";
                        }
                        if (value.trim().length < 10) {
                          return "Phone Number must be 10 digits long";
                        }
                        return null;
                      },
                    ),
                  ),
                  if (!_isphoneVerified)
                    ElevatedButton(
                      onPressed:() async{
                      if(_formKey.currentState!.validate())
                      {
                        String completedPhoneNumber= "+91${_phoneController.text.trim()}";
                        await FirebaseAuth.instance.verifyPhoneNumber(
                          phoneNumber: completedPhoneNumber,
                          verificationCompleted: (PhoneAuthCredential credential)async{
                            await FirebaseAuth.instance.signInWithCredential(credential);
                            setState(()
                            {
                              _isphoneVerified=true;
                            });
                          },
                          verificationFailed: (FirebaseAuthException e){
                            if(mounted)
                            {
                            ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Failed to send SMS : ${e.message}"),
                            backgroundColor: Colors.redAccent,
                            ),
                          );
                            }
                          },
                          codeSent: (String? verificationId,int? resendToken) async{
                            if(!mounted)return;
                            final bool? verificationResult= await Navigator.push(context,
                             MaterialPageRoute(builder: (context)=>
                             OtpPage(
                              phoneNumber: _phoneController.text,
                              verificationId:verificationId.toString()),
                             ),
                             );
                             if(verificationResult==true)
                             {
                              setState(() {
                                _isphoneVerified=true;
                              });
                             }
                          },
                          codeAutoRetrievalTimeout: (String verificationId) {},
                          );
                        
                      }
                    }, 
                    child: Text("Send OTP")),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 300.0,
                    height: 80.0,
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        hintText: "Date of Birth",
                        prefixIcon: Icon(Icons.date_range),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 300.0,
                    height: 80.0,
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        hintText: "Location",
                        prefixIcon: Icon(Icons.location_city),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 300.0,
                    height: 60.0,
                    child: DropdownButton<String>(
                      value: _selectedGender,
                      hint: Text("Select a Gender"),
                      isExpanded: true,
                      items: _gender.map((String gender) {
                        return DropdownMenuItem<String>(
                          value: gender,
                          child: Text(gender),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedGender = newValue;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 10.0),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/home');
                    },
                    child: Text("Register"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigoAccent,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have an account?"),
                      SizedBox(width: 10),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/login');
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.blueAccent,
                          padding: EdgeInsets.zero,
                          minimumSize: Size(50, 30),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
