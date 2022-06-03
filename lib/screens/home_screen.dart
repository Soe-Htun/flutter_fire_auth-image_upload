import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fire_authentication/constants.dart';
import 'package:flutter_fire_authentication/imageupload/image_upload.dart';
import 'package:flutter_fire_authentication/imageupload/show_images.dart';
import 'package:flutter_fire_authentication/model/user_model.dart';
import 'package:flutter_fire_authentication/screens/login_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({ Key? key }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  @override
  void initState() {
    
    FirebaseFirestore.instance
      .collection("users")
      .doc(user!.uid)
      .get()
      .then((value) {
        setState(() {
          loggedInUser = UserModel.fromMap(value.data());
        });
        print("Logged ${loggedInUser}");
      });
      super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Welcome", style: TextStyle(color: kTextColor),),
        centerTitle: true,
        actions: [
          ElevatedButton(
            
            onPressed: () {
              logout(context);
            }, 
            child: Row(
              children: const [
                Text("Logout"),
                Icon(Icons.logout)
              ],
            ),
            style: ElevatedButton.styleFrom(
              primary: Colors.redAccent,
            ),
          )
        ],
      ),

      body:  Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Welcome back",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 19
                ),
              ),
              const SizedBox(height: 10),
              Text("${loggedInUser.firstName} ${loggedInUser.lastName}", 
                style: const TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.w500
                ),
              ),
              const SizedBox(height: 10),
              Text('${loggedInUser.email}', 
                style: const TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.w500
                ),
              ),
              const SizedBox(height: 15),
              // ActionChip(
              //   label: const Text('Logout'), 
              //   onPressed: (){
              //     logout(context);
              //   }
              // )
              ElevatedButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ImageUpload(userId: loggedInUser.uid,)));
                  // Navigator.pushNamed(context, '/imageUpload', );
                }, 
                child: const Text("Upload Image")
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: (){
                  // Navigator.pushNamed(context, '/showImage');
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ShowImages(userId: loggedInUser.uid,)));
                }, 
                child: const Text("Show Images")
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> logout(BuildContext  context) async {
    await FirebaseAuth.instance.signOut();
    // Navigator.of(context).pushReplacement(
    //   MaterialPageRoute(builder: (context) => const LoginScreen())
    // );
    Navigator.pushNamed(context, '/');
  }

}