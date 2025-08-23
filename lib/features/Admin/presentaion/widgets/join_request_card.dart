import 'package:flutter/material.dart';
import 'package:opal_app/core/resources/color_manager.dart';

import '../../../../core/resources/text_styles.dart';

class JoinRequestCard extends StatelessWidget {
  final String name;
  final String phone;
  final String university;
  final String? downTown;
  final bool isExpanded;
  final VoidCallback onToggle;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  JoinRequestCard({
    super.key,
    required this.name,
    required this.phone,
    required this.university,
    this.downTown,
    required this.isExpanded,
    required this.onToggle,
    required this.onAccept,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          ListTile(
            title: Text(
              name,
              textAlign: TextAlign.right,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            trailing: IconButton(
              icon: Icon(
                isExpanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
              ),
              onPressed: onToggle,
            ),
          ),
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildInfoRow('رقم الهاتف', phone),
                  _buildInfoRow('الجامعة', university),
                  _buildInfoRow('المدينة', downTown!),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: onReject,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorManager.primaryColor,
                          ),
                          child: Text(
                            'رفض الطلب',
                            style: TextStyles.white12Bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: onAccept,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          child: Text(
                            'قبول الطلب',
                            style: TextStyles.white12Bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(value, style: TextStyles.black14Bold),
          Text(label, style: TextStyles.black14Bold),
        ],
      ),
    );
  }
}
