import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fire_authentication/constants.dart';
import 'package:flutter_fire_authentication/screens/home_screen.dart';
import 'package:flutter_fire_authentication/screens/sign_up_screen.dart';
import 'package:flutter_fire_authentication/widgets/already_account.dart';
import 'package:flutter_fire_authentication/widgets/custom_button.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../widgets/custom_textField.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({ Key? key }) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isHidden = true;
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final _auth = FirebaseAuth.instance;
  
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

  void tooglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
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
            child: const Center(child: Text("Login",
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
                            const SizedBox(height: 20,),
                            CustomButton(
                              text: 'Login ',
                              onpress: () {
                                login(emailController.text, passwordController.text);
                              }
                            ),
                            const SizedBox(height: 20,),
                            AlreadyAccount(
                              press: () {
                                // Navigator.push(context, 
                                //   MaterialPageRoute(builder: (context) => const SignUpScreen() )
                                // );
                                Navigator.pushNamed(context, '/signUp');
                              },
                            )
                  
                          ],
                        )
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

  void login(String email, String password) async {
    if(_formKey.currentState!.validate()) {
      await _auth.signInWithEmailAndPassword(email: email, password: password)
      .then((value) => {
        Fluttertoast.showToast(msg: "Login Successful"),
        // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => 
        //   const HomeScreen())
        // )
        Navigator.pushNamed(context, '/home')
      }).catchError((e) {
        Fluttertoast.showToast(msg: e!.message);
      });
    }
  }
}