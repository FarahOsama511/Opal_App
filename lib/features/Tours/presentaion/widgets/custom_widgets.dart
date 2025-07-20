import 'package:flutter/material.dart';

/// دائرة اللوجو الحمراء
class LogoCircle extends StatelessWidget {
  final Size size;
  const LogoCircle({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xFFE71A45),
        ),
        child: Image.asset(
          'assets/logo.png',
          width: size.width * 0.22,
        ),
      ),
    );
  }
}
/// زر أساسى
class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFE71A45),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }
}

/// Dropdown الخطوط
class LineDropdown extends StatelessWidget {
  final String? selectedLine;
  final void Function(String?) onChanged;

  const LineDropdown({
    super.key,
    required this.selectedLine,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
            hint: const Text('الخط'),
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
class CustomDropdown extends StatelessWidget {
  final String label;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const CustomDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButtonFormField<String>(
            isExpanded: true,
            value: value,
            hint: Text(label),
            items: items.map((item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              );
            }).toList(),
            onChanged: onChanged,
            validator: (val) => val == null ? 'يرجى اختيار $label' : null,
          ),
        ),
      ),
    );
  }
}
