// import 'package:flutter/material.dart';

// class CustomPasswordField extends StatelessWidget {
//   final String hint;
//   final bool visible;
//   final VoidCallback toggleVisibility;
//   final TextEditingController controller;
//   final String validatorMessage;
//   final TextEditingController? matchController;
//   final String? errorText;

//   const CustomPasswordField({
//     super.key,
//     required this.hint,
//     required this.visible,
//     required this.toggleVisibility,
//     required this.controller,
//     required this.validatorMessage,
//     this.matchController,
//     this.errorText,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       decoration: InputDecoration(
//         suffixIcon: IconButton(
//           icon: Icon(visible ? Icons.visibility : Icons.visibility_off),
//           onPressed: toggleVisibility,
//         ),
//       ),
//     );
//   }
// }
