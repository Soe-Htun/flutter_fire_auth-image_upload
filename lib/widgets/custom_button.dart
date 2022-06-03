import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Function()? onpress;

  const CustomButton({ Key? key,
    required this.text,
    required this.onpress
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 45,
      child: ElevatedButton(
        onPressed: onpress, 
        child: Text(text, 
          style: const TextStyle(fontSize: 18,),
        ),
        style: ElevatedButton.styleFrom(
          primary: Colors.redAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)
          ),
        ),
      ),
    );
  }
}