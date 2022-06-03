import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fire_authentication/firebase_options.dart';
import 'package:flutter_fire_authentication/imageupload/image_upload.dart';
import 'package:flutter_fire_authentication/imageupload/show_images.dart';
import 'package:flutter_fire_authentication/screens/home_screen.dart';
import 'package:flutter_fire_authentication/screens/login_screen.dart';
import 'package:flutter_fire_authentication/screens/sign_up_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Palatte.kColor,
      ),
      initialRoute: '/',
      routes: {
        '/' : (context) => const LoginScreen(),
        //  '/' : (context) => const ImageUpload(),
        '/signUp' : (context) => const SignUpScreen(),
        '/home' : (context) => HomeScreen(),
        '/imageUpload' : (context) => ImageUpload(),
        '/showImage' : (context) => ShowImages()
      },
      // home: const LoginScreen(),
    );
  }
}

class Palatte {
  static const MaterialColor kColor = MaterialColor(
    0xffff5252,
    <int, Color> {
      50: Color(0xffff5252),
      100: Color(0xffff5252),
      200: Color(0xffff5252),
      300: Color(0xffff5252),
      400: Color(0xffff5252),
      500: Color(0xffff5252),
      600: Color(0xffff5252),
      700: Color(0xffff5252),
      800: Color(0xffff5252),
      900: Color(0xffff5252),
    }
  );
}