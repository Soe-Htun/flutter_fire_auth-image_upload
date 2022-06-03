import 'package:flutter/material.dart';

class AlreadyAccount extends StatelessWidget {
  final bool login;
  final Function()? press;
  const AlreadyAccount({ Key? key,
    this.login = true,
    this.press
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(login? "Don't have an account? " : "Already have an account? ",
          style: const TextStyle(fontSize: 17),
        ),
        GestureDetector(
          onTap: press,
          child: Text(
            login? " Sign Up" : "Login ",
            style: const TextStyle(
              fontSize: 18,
              color: Colors.redAccent,
              fontWeight: FontWeight.w700
            ),
          ),
        )
      ],
    );
  }
}