import 'package:flutter/material.dart';

class StepHeader extends StatelessWidget {
  final VoidCallback onClose;
  const StepHeader({super.key, required this.onClose});
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: IconButton(icon: const Icon(Icons.close), onPressed: onClose),
    );
  }
}

class StepButtons extends StatelessWidget {
  final int currentStep;
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  const StepButtons({
    super.key,
    required this.currentStep,
    required this.onNext,
    required this.onPrevious,
  });
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (currentStep > 0)
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                minimumSize: const Size.fromHeight(50),
              ),
              onPressed: onPrevious,
              child: const Text('السابق'),
            ),
          ),
        if (currentStep > 0) const SizedBox(width: 10),
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE71A45),
              minimumSize: const Size.fromHeight(50),
            ),
            onPressed: onNext,
            child: Text(currentStep < 3 ? 'التالي' : 'تأكيد'),
          ),
        ),
      ],
    );
  }
}
