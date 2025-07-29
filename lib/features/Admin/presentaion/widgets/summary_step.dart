import 'package:flutter/material.dart';
import 'package:opal_app/features/Admin/Domain/entities/tour.dart';
import 'package:opal_app/features/user/Domain/entities/user_entity.dart';

class SummaryStep extends StatelessWidget {
  final LineEntity? selectedLine;
  final int hour;
  final int minute;
  final String period;
  final UserEntity? selectedSupervisor;
  final DateTime? selectedDate;

  const SummaryStep({
    super.key,
    required this.selectedLine,
    required this.hour,
    required this.minute,
    required this.period,
    required this.selectedSupervisor,
    required this.selectedDate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'بيانات الرحلة',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('الخط'),
                  Text('${selectedLine!.name ?? ''}'),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('ميعاد الذهاب'),
                  Text('$hour:${minute.toString().padLeft(2, '0')} $period'),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('اسم المشرف'),
                  Text(selectedSupervisor!.name ?? ''),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('تاريخ اليوم'),
                  Text(
                    selectedDate != null
                        ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                        : '',
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
