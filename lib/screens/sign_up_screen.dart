import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fire_authentication/constants.dart';
import 'package:flutter_fire_authentication/model/user_model.dart';
import 'package:flutter_fire_authentication/screens/login_screen.dart';
import 'package:flutter_fire_authentication/widgets/already_account.dart';
import 'package:flutter_fire_authentication/widgets/custom_button.dart';
import 'package:flutter_fire_authentication/widgets/custom_textField.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'home_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({ Key? key }) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _isHidden = true;
  bool _isHiddenConfirm = true;
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  Widget password() {
    return SizedBox(
      width: double.infinity,
      child: TextFormField(
        obscureText: _isHidden,
        textAlign: TextAlign.left,
        controller: passwordController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          hintText: 'Password',
          prefixIcon: const Icon(
            Icons.lock
          ),
          suffixIcon: InkWell(
            child: Icon(
            _isHidden ? Icons.visibility : Icons.visibility_off
            ),
            onTap: tooglePasswordView,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12)
          ),
          contentPadding: const EdgeInsets.only(top: 5, bottom: 5, left: 20),
          hintStyle: const TextStyle(
            fontSize: 20,
            color: Colors.black54
          ),
        ),
        validator: (String? value) {
          RegExp regex = RegExp(r'^.{6,}$');
          if(value!.isEmpty) {
            return 'Password is required';
          }
          if(!regex.hasMatch(value)) {
            return 'Password must be at least 6 Character';
          }
          return null;
        },
        onSaved: (String? value) {
          passwordController.text = value!;
        },
        style: const TextStyle(
          fontSize: 20,
          color: Colors.black54
        ),
        // onChanged: onpress,
      ),
    );
  }

  Widget confirmPassword() {
    return SizedBox(
      width: double.infinity,
      child: TextFormField(
        obscureText: _isHiddenConfirm,
        textAlign: TextAlign.left,
        controller: confirmPasswordController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          hintText: 'Confirm Password',
          prefixIcon: const Icon(
            Icons.lock
          ),
          suffixIcon: InkWell(
            child: Icon(
            _isHiddenConfirm ? Icons.visibility : Icons.visibility_off
            ),
            onTap: toogleConfirmPassword,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12)
          ),
          contentPadding: const EdgeInsets.only(top: 5, bottom: 5, left: 20),
          hintStyle: const TextStyle(
            fontSize: 20,
            color: Colors.black54
          ),
        ),
        validator: (String? value) {
          if(value!.isEmpty) {
            return 'Password is required';
          }
          // if(!regex.hasMatch(value)) {
          //   return 'Password must be at least 6 Character';
          // }
          if( passwordController.text != confirmPasswordController.text) {
            return "Password don't match";
          }
          return null;
        },
        onSaved: (String? value) {
          confirmPasswordController.text = value!;
        },
        style: const TextStyle(
          fontSize: 20,
          color: Colors.black54
        ),
        // onChanged: onpress,
      ),
    );
  }

  void tooglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  void toogleConfirmPassword() {
    setState(() {
      _isHiddenConfirm = !_isHiddenConfirm;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.redAccent,
      body: Column(
        children: [
          Container(
            height: 200,
            child: const Center(child: Text("Sign Up",
              style: TextStyle(color: kTextColor, fontSize: 27, fontWeight: FontWeight.bold),
            )),
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: kTextColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40)
                )
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 30, right: 30),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            CustomTextField(
                              text: "First Name", 
                              keyboardType: TextInputType.text, 
                              controller: firstNameController, 
                              icon: CupertinoIcons.person_crop_circle_fill,
                              validator: (String? value) {
                                if(value!.isEmpty) {
                                  return "First Name is required";
                                }
                                return null;
                              },
                              onSave: (String? value) {
                                firstNameController.text = value!;
                              },
                            ),
                            CustomTextField(
                              text: "Last Name", 
                              keyboardType: TextInputType.text, 
                              controller: lastNameController, 
                              icon: CupertinoIcons.person_crop_circle_fill,
                              validator: (String? value) {
                                if(value!.isEmpty) {
                                  return "Last Name is required";
                                }
                                return null;
                              },
                              onSave: (String? value) {
                                lastNameController.text = value!;
                              },
                            ),

                            CustomTextField(
                              text: "Email", 
                              keyboardType: TextInputType.emailAddress, 
                              controller: emailController, 
                              icon: Icons.email,
                              validator: (String? value) {
                                if(value!.isEmpty) {
                                  return "Email is required";
                                }
                                if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
                                  return "Please enter valid email address";
                                }
                                return null;
                              },
                              onSave: (String? value) {
                                emailController.text = value!;
                              },
                            ),

                            password(),
                            const SizedBox(height: 20),

                            confirmPassword(),
                            const SizedBox(height: 20),

                            CustomButton(
                              text: 'Sign Up',
                              onpress: (){
                                singUp(emailController.text, passwordController.text);
                              }
                            ),
                            const SizedBox(height: 20,),
                            AlreadyAccount(
                              login: false,
                              press: () {
                                // Navigator.push(context, 
                                //   MaterialPageRoute(builder: (context) => const LoginScreen())
                                // );
                                Navigator.pushNamed(context, '/');
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  singUp(String email, String password) async{
    if(_formKey.currentState!.validate()) {
      await _auth.createUserWithEmailAndPassword(email: email, password: password)
      .then((value) => {

        postDetailsToFirestore(),
        Fluttertoast.showToast(msg: "Sign Up Successful"),
        // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => 
        //   HomeScreen())
        // )
        Navigator.pushNamed(context, '/home')
      }).catchError((e) {
        Fluttertoast.showToast(msg: e.message);
      });
    }
  }

  postDetailsToFirestore() async {
    // calling our firestore
    // calling our user model
    // sending these values

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;
    UserModel userModel = UserModel();

    // writing all these values
    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.firstName = firstNameController.text;
    userModel.lastName = lastNameController.text;

    await firebaseFirestore
      .collection("users")
      .doc(user.uid)
      .set(userModel.toMap());

    Fluttertoast.showToast(msg: "Account created successfully :");

    // Navigator.pushAndRemoveUntil(context,
    //  MaterialPageRoute(builder: (context) => const HomeScreen()),
    // (route) => false);
    Navigator.pushNamed(context, '/home');
  }
}