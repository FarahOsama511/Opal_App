import 'package:flutter/material.dart';
import 'package:opal_app/features/Admin/Domain/entities/tour.dart';
import 'package:opal_app/features/user/Domain/entities/user_entity.dart';

import '../../../../core/resources/text_styles.dart';

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
        Text('بيانات الرحلة', style: TextStyles.black20Bold),
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
                  Text('الخط', style: TextStyles.black14Bold),
                  Text(
                    '${selectedLine!.name ?? ''}',
                    style: TextStyles.black14Bold,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('ميعاد الذهاب', style: TextStyles.black14Bold),
                  Text(
                    '$hour:${minute.toString().padLeft(2, '0')} $period',
                    style: TextStyles.black14Bold,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('اسم المشرف', style: TextStyles.black14Bold),
                  Text(
                    selectedSupervisor!.name ?? '',
                    style: TextStyles.black14Bold,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('تاريخ اليوم', style: TextStyles.black14Bold),
                  Text(
                    selectedDate != null
                        ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                        : '',
                    style: TextStyles.black14Bold,
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
