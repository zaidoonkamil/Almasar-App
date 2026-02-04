import 'package:delivery_app/core/styles/themes.dart';
import 'package:flutter/material.dart';

class CustomSearchField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onClear;
  final ValueChanged<String>? onChanged;
  final String hintText;

  const CustomSearchField({
    super.key,
    required this.controller,
    required this.onClear,
    this.onChanged,
    this.hintText = "بحث...",
  });

  @override
  Widget build(BuildContext context) {
    bool isActive = controller.text.isNotEmpty;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: isActive ? Colors.blue : Colors.grey.shade300,
            width: 1.2,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.search,
              color:  Colors.grey,
            ),
            const SizedBox(width: 12),

            Expanded(
              child: TextFormField(
                controller: controller,
                onChanged: onChanged,
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 14,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
            AnimatedOpacity(
              opacity: isActive ? 1 : 0.4,
              duration: const Duration(milliseconds: 250),
              child: GestureDetector(
                onTap: isActive ? onClear : null,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: isActive
                        ? Colors.deepOrange.withOpacity(0.15)
                        : Colors.grey.shade500.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isActive ? Colors.deepOrange : Colors.grey.shade500,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    "حذف",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isActive ? Colors.deepOrange : Colors.grey.shade500,
                    ),
                  ),
                ),
              ),
            ),


          ],
        ),
      ),
    );
  }
}
