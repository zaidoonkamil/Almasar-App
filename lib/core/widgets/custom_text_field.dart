import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final IconData prefixIcon;
  final Widget? suffixIcon;
  final TextInputType keyboardType;
  final bool obscureText;
  final void Function()? onTap;
  final TextEditingController? controller;
  final String? Function(String?)? validate;
  final int maxLines;

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.prefixIcon,
    this.controller,
    this.onTap,
    this.suffixIcon,
    this.validate,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.maxLines = 1,
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
        onTap: onTap,
        obscureText: obscureText,
        validator: validate,
        controller: controller,
        maxLines: maxLines,
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
