// import 'package:flutter/material.dart';

// import '../../Domain/entities/tour.dart';

// class BusLineDropdown extends StatelessWidget {
//   final LineEntity? selectedLine;
//   final List<LineEntity> lines;
//   final ValueChanged<LineEntity?> onChanged;

//   const BusLineDropdown({
//     super.key,
//     required this.selectedLine,
//     required this.lines,
//     required this.onChanged,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
//       child: DropdownButtonHideUnderline(
//         child: DropdownButtonFormField<LineEntity>(
//           decoration: InputDecoration(
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(10),
//               borderSide: BorderSide(color: Colors.black),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(10),
//               borderSide: BorderSide(color: Colors.black),
//             ),
//             filled: false,
//           ),

//           isExpanded: true,
//           value: selectedLine,
//           hint: const Text('اختر الخط الخاص بك'),
//           items: lines.map((line) {
//             return DropdownMenuItem<LineEntity>(
//               value: line,
//               child: Text(line.name!),
//             );
//           }).toList(),
//           onChanged: onChanged,
//           icon: const Icon(Icons.keyboard_arrow_down),
//         ),
//       ),
//     );
//   }
// }
