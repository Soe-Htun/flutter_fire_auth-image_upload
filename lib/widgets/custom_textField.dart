import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {

  final String text;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final IconData icon;
  final String? Function(String?)? validator;
  final void Function(String?)? onSave;

  const CustomTextField({ Key? key,
    required this.text,
    required this.keyboardType,
    required this.controller,
    required this.icon,
    required this.validator,
    required this.onSave
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: TextFormField(
            textAlign: TextAlign.left,
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              hintText: text,
              prefixIcon: Icon(
                icon
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

            validator: validator,

            onSaved: onSave,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.black54
            ),
          ),
        ),
        const SizedBox(height: 20,)
      ],
    );
  }
}