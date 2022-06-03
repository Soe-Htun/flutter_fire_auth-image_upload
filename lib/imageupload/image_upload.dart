import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// image picker for picking the image
// firebase storage for uploading the image to firebaseStorage
// and, cloud firestore for saving the url for uploaded image to our application
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';


class ImageUpload extends StatefulWidget {
  String? userId;
  ImageUpload({ Key? key, 
    this.userId
  }) : super(key: key);

  @override
  State<ImageUpload> createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> {
  // some initialize code
  
  File? _image = File("");
  Uint8List webImage = Uint8List(10);
  final imagePicker = ImagePicker();
  late final PickedFile pickedFile;
  String? downloadUrl;

  String _imageUrl = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Image Upload"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: SizedBox(
              height: 400,
              width: double.infinity,
              child: Column(
                children:  [
                  // const Text('Image Upload'),
                  const SizedBox(height: 10,),

                  Container(
                    height: 260,
                    width: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.redAccent)
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Image Upload'),
                        ),
                        Container(
                          height: 130,
                          width: 130,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.redAccent,
                              width: 1,
                              // style: BorderStyle.solid
                            
                            )
                          ),
                          child: (_image!.path == "") 
                          ? IconButton(
                            onPressed: (){
                              selectImage();
                            }, 
                            icon: const Icon(Icons.add_a_photo)
                          )
                          :
                          (kIsWeb)
                          ? Image.memory(webImage, width: 130, height: 130, fit: BoxFit.fill)
                          : 
                          Image.file(_image!, width: 130, height: 130, fit: BoxFit.fill) ,
                        ),

                        // ElevatedButton(
                        //   onPressed: (){},
                        //   child: const Text("Select")
                        // ),
                        ElevatedButton(
                          onPressed: (){
                            upload();
                          },
                          child: const Text("Upload")
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> selectImage() async {
    // picke
    pickedFile = (await imagePicker.getImage(source: ImageSource.gallery))!;
    if(kIsWeb) {
      if(pickedFile != null) {
        var f = await pickedFile.readAsBytes();
        setState(() {
          _image = File(pickedFile.path);
          webImage = f;
        });
      } else {
        // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("No file selected"), duration: Duration(milliseconds: 400),));
        const SnackBar(content: Text("No file selected"), duration: Duration(milliseconds: 400));
      }
    } else if(!kIsWeb) {
      if(pickedFile != null) {
        var selected = File(pickedFile.path);
        setState(() {
          _image = selected;
        });
      }
    }

    setState(() {
      _image = File(pickedFile.path);
    });
  }

  Future upload() async{
    // this is for web
    // if(kIsWeb) {
    //   String fileName = basename(_image!.path);
    //   Reference firebaseStorageRef = FirebaseStorage.instance.ref().child('images/$fileName');

    //   UploadTask uploadTask = firebaseStorageRef.putData(
    //     await pickedFile.readAsBytes(),
    //     SettableMetadata(contentType: 'image/jpeg')
    //   );
    //   TaskSnapshot taskSnapshot = await uploadTask;
    //   taskSnapshot.ref.getDownloadURL().then((value) {
    //     _imageUrl = value;
    //     debugPrint("URL--> $_imageUrl");
    //     const SnackBar(content: Text("Success Image upload"), duration: Duration(milliseconds: 400),);
    //   });
    // } else {
    //   // this is for mobile
    //   String fileName = basename(_image!.path);
    //   Reference firebaseStorageRef = FirebaseStorage.instance.ref().child('images/$fileName');
    //   UploadTask uploadTask = firebaseStorageRef.putFile(_image!);
    //   TaskSnapshot taskSnapshot = await uploadTask;
    //   taskSnapshot.ref.getDownloadURL().then((value) {
    //     _imageUrl = value;
    //     const SnackBar(content: Text("Success Image upload"), duration: Duration(milliseconds: 400),);
    //   });
    // }

    final postId = DateTime.now().millisecondsSinceEpoch.toString();
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    if(kIsWeb) {
      Reference ref= FirebaseStorage.instance
      .ref()
      .child("${widget.userId}/images")
      .child("post_ $postId");

      await ref.putData(
        await pickedFile.readAsBytes(),
        SettableMetadata(contentType: 'image/jpeg')
      );
      downloadUrl = await ref.getDownloadURL().then((value) {
        _imageUrl =value;
      });

      // uploading to cloud firestore
      await firebaseFirestore
        .collection("users")
        .doc(widget.userId)
        .collection("images")
        .add({'downloadURL' : _imageUrl}).whenComplete(() => 
          const SnackBar(content: Text("Image Upload Successfully :"), duration: Duration(seconds: 1),)
        );
    } else {
      Reference ref= FirebaseStorage.instance
      .ref()
      .child("${widget.userId}/images")
      .child("post_ $postId");

      await ref.putFile(_image!);
      downloadUrl = await ref.getDownloadURL().then((value) {
        _imageUrl =value;
      });

      await firebaseFirestore
        .collection("users")
        .doc(widget.userId)
        .collection("images")
        .add({'downloadURL' : _imageUrl}).whenComplete(() => 
          const SnackBar(content: Text("Image Upload Successfully :"), duration: Duration(seconds: 1),)
        );

    }
      
  }
}