import 'package:flutter/material.dart';

class BusCard extends StatelessWidget {
  final bool isExpanded;
  final VoidCallback? onTap;
  final VoidCallback? onCancel;
  final VoidCallback? onNext;
  final String line;
  final String supervisorName;
  final String departureTime;
  final String date;
  const BusCard({
    super.key,
    required this.isExpanded,
    this.onTap,
    this.onCancel,
    this.onNext,
    required this.line,
    required this.supervisorName,
    required this.departureTime,
    required this.date,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              bottom: -5,
              left: -5,
              child: Opacity(
                opacity: 0.4,
                child: Image.asset('assets/logo.png', width: 60),
              ),
            ),
            Directionality(
              textDirection: TextDirection.rtl,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _RowInfo(label: 'الخط', value: line),
                  _RowInfo(label: 'اسم المشرف', value: supervisorName),
                  _RowInfo(label: 'ميعاد الذهاب', value: departureTime),
                  _RowInfo(label: 'تاريخ اليوم', value: date),

                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RowInfo extends StatelessWidget {
  final String label;
  final String value;
  const _RowInfo({required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.right,
            ),
          ),
          Flexible(
            child: Text(
              label,
              style: const TextStyle(color: Colors.grey),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }
}
