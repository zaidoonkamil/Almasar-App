import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final IconData prefixIcon;
  final Widget? suffixIcon;
  final TextInputType keyboardType;
  final bool obscureText;
  final TextEditingController? controller;
  final String? Function(String?)? validate;

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.prefixIcon,
    this.controller,
    this.suffixIcon,
    this.validate,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,

  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // height:validationPassed==false? 46:88,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextFormField(
        textAlign:TextAlign.right,
        keyboardType: keyboardType,
        obscureText: obscureText,
        validator: validate,
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
          prefixIcon: suffixIcon ,
          suffixIcon: Icon(prefixIcon, color: Colors.grey),
        ),
      ),
    );
  }
}
