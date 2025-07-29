import 'package:flutter/material.dart';

class ExpandableCard extends StatelessWidget {
  final String name;
  final String phone;
  final String university;

  final String line;
  final bool isSupervisor;
  final bool isExpanded;
  final VoidCallback onToggle;

  const ExpandableCard({
    super.key,
    required this.name,
    required this.phone,
    this.university = '',

    this.line = '',
    required this.isSupervisor,
    required this.isExpanded,
    required this.onToggle,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 3, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  name,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down_rounded,
                  color: Colors.black,
                ),
                onPressed: onToggle,
              ),
            ],
          ),
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildInfoRow(phone, 'رقم الهاتف:'),
                  if (!isSupervisor) ...[
                    _buildInfoRow(university, 'الجامعة:'),
                  ] else ...[
                    _buildInfoRow(line, 'الخط:'),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String title, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          Text(title, style: const TextStyle(color: Colors.black87)),
        ],
      ),
    );
  }
}
