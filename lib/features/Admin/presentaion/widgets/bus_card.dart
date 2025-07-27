import 'package:flutter/material.dart';

class BusCard extends StatelessWidget {
  final bool isExpanded;
  final VoidCallback onTap;
  final VoidCallback onCancel;
  final VoidCallback onNext;
  final String line;
  final String supervisorName;
  final String departureTime;
  final String date;
  const BusCard({
    super.key,
    required this.isExpanded,
    required this.onTap,
    required this.onCancel,
    required this.onNext,
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
                  if (isExpanded) ...[
                    const Divider(height: 20),
                    const Text(
                      'اختر ميعاد العودة:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      items: const [
                        DropdownMenuItem(value: '1', child: Text('1:00 مساءً')),
                        DropdownMenuItem(value: '2', child: Text('2:00 مساءً')),
                        DropdownMenuItem(value: '3', child: Text('3:00 مساءً')),
                      ],
                      onChanged: (val) {},
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: onCancel,
                            child: const Text('إلغاء'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: onNext,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFE71A45),
                            ),
                            child: const Text('التالي'),
                          ),
                        ),
                      ],
                    ),
                  ],
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
