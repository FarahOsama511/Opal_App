import 'package:flutter/material.dart';

class SupervisorStep extends StatelessWidget {
  final String? selectedSupervisor;
  final ValueChanged<String?> onSupervisorChanged;

  const SupervisorStep({
    super.key,
    required this.selectedSupervisor,
    required this.onSupervisorChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Text('اختيار المشرف', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        const SizedBox(height: 10),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey.shade200,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          hint: const Text('اختر المشرف'),
          value: selectedSupervisor,
          onChanged: onSupervisorChanged,
          items: const [
            DropdownMenuItem(value: 'أحمد محمد', child: Text('أحمد محمد')),
            DropdownMenuItem(value: 'سارة علي', child: Text('سارة علي')),
          ],
        ),
      ],
    );
  }
}
