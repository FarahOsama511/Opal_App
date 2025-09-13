import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/resources/color_manager.dart';
import '../../../../core/resources/text_styles.dart';

class MoreOptionsButton extends StatelessWidget {
  final dynamic entity;
  final void Function(dynamic) onEdit;
  final void Function(dynamic) onDelete;
  const MoreOptionsButton({
    super.key,
    required this.entity,
    required this.onEdit,
    required this.onDelete,
  });
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(
        Icons.more_vert,
        color: ColorManager.primaryColor,
        size: 22.sp,
      ),
      onSelected: (value) {
        if (value == 'edit') {
          onEdit(entity);
        } else if (value == 'delete') {
          onDelete(entity);
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: 'edit',
          child: Text('تعديل', style: TextStyles.black14Bold),
        ),
        PopupMenuItem<String>(
          value: 'delete',
          child: Text('حذف', style: TextStyles.red10Bold),
        ),
      ],
    );
  }
}
