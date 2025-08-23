import 'package:flutter/material.dart';
import '../../../../core/constants/constants.dart' as university;
import '../../../../core/resources/text_styles.dart';
import 'delete_dialog.dart';

class SettingsExpandableCard extends StatelessWidget {
  final String name;
  final bool isSupervisor;
  final bool isExpanded;
  final VoidCallback onToggle;
  final String? location;
  final int? usersCount;
  final String? notes;
  final Widget? deleteIcon;

  const SettingsExpandableCard({
    required this.deleteIcon,
    super.key,
    required this.name,
    required this.isSupervisor,
    required this.isExpanded,
    required this.onToggle,
    this.location,
    this.usersCount,
    this.notes,
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
          InkWell(
            onTap: onToggle,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    name,
                    textAlign: TextAlign.right,
                    style: TextStyles.black14Bold,
                  ),
                ),
                if (isExpanded && deleteIcon != null) deleteIcon!,
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
          ),
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (!isSupervisor) ...[
                    _buildInfoRow(location ?? 'غير متوفر', 'الموقع:'),
                    _buildInfoRow((usersCount).toString(), 'عدد الطلبة:'),
                  ] else ...[
                    _buildInfoRow(notes ?? 'غير متوفر', 'الملاحظات:'),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String value, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyles.black14Bold),
          Text(value, style: TextStyles.black14Bold),
        ],
      ),
    );
  }
}
