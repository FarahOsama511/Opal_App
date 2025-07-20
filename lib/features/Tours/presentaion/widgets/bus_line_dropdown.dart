import 'package:flutter/material.dart';

class BusLineDropdown extends StatelessWidget {
  final String? selectedLine;
  final ValueChanged<String?> onChanged;

  const BusLineDropdown({
    super.key,
    required this.selectedLine,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            isExpanded: true,
            value: selectedLine,
            hint: const Text('اختر الخط الخاص بك'),
            items: const [
              DropdownMenuItem(value: '1', child: Text('خط رقم 1')),
              DropdownMenuItem(value: '2', child: Text('خط رقم 2')),
              DropdownMenuItem(value: '3', child: Text('خط رقم 3')),
              DropdownMenuItem(value: '4', child: Text('خط رقم 4')),
            ],
            onChanged: onChanged,
            icon: const Icon(Icons.keyboard_arrow_down),
          ),
        ),
      ),
    );
  }
}
