import 'package:flutter/material.dart';
class CustomPasswordField extends StatelessWidget {
  final String hint;
  final bool visible;
  final VoidCallback toggleVisibility;
  final TextEditingController controller;
  final String validatorMessage;
  final TextEditingController? matchController;
  final String? errorText;

  const CustomPasswordField({
    super.key,
    required this.hint,
    required this.visible,
    required this.toggleVisibility,
    required this.controller,
    required this.validatorMessage,
    this.matchController,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        obscureText: !visible,
        controller: controller,
        textAlign: TextAlign.right,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(fontSize: 14),
          suffixIcon: IconButton(
            icon: Icon(visible ? Icons.visibility : Icons.visibility_off),
            onPressed: toggleVisibility,
          ),
          filled: true,
          fillColor: Colors.grey.shade200,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          errorText: errorText,
          errorStyle: const TextStyle(color: Colors.red, fontSize: 12),
        ),
    validator: (value) {
      if (value == null || value.isEmpty) return validatorMessage;
      if (matchController != null && value != matchController!.text) {
        return 'كلمة السر غير متطابقة';
      }
      return null;
    }
      ),
    );
  }
}
