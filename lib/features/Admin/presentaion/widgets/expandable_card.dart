import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:opal_app/features/supervisor/bloc/get_university_by_id/get_university_by_id_state.dart';
import '../../../../core/resources/text_styles.dart';
import '../../../supervisor/bloc/get_university_by_id/get_university_by_id_cubit.dart';

class ExpandableCard extends StatefulWidget {
  final String name;
  final String? phone;
  final String university;
  final String? universityId;
  final String line;
  final bool isSupervisor;
  final bool isExpanded;
  final VoidCallback onToggle;
  final Function()? onLongPress;
  final Widget? deleteIcon;

  ExpandableCard({
    this.universityId,
    this.onLongPress,
    this.deleteIcon,
    super.key,
    required this.name,
    this.phone,
    this.university = '',
    this.line = '',
    required this.isSupervisor,
    required this.isExpanded,
    required this.onToggle,
  });

  @override
  State<ExpandableCard> createState() => _ExpandableCardState();
}

class _ExpandableCardState extends State<ExpandableCard> {
  @override
  void initState() {
    super.initState();
    if (widget.universityId != null && widget.universityId!.isNotEmpty) {
      BlocProvider.of<GetUniversityByIdCubit>(context)
          .getUniversityById(widget.universityId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final universityName = widget.universityId != null
        ? context.read<GetUniversityByIdCubit>().nameOfUniversity ?? ""
        : "";

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 2.h, bottom: 1.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 3.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // يخلي الكارد يلتزم بمحتواه فقط
        children: [
          InkWell(
            onLongPress: widget.onLongPress,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.name,
                    textAlign: TextAlign.right,
                    style: TextStyles.black14Bold.copyWith(fontSize: 14.sp),
                  ),
                ),
                if (widget.isExpanded && widget.deleteIcon != null)
                  widget.deleteIcon!,
                IconButton(
                  icon: Icon(
                    widget.isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down_rounded,
                    color: Colors.black,
                    size: 22.sp, // صغرنا الأيقونة شوية
                  ),
                  onPressed: widget.onToggle,
                ),
              ],
            ),
          ),
          if (widget.isExpanded)
            Padding(
              padding: EdgeInsets.only(top: 6.h), // أقل من قبل
              child: BlocBuilder<GetUniversityByIdCubit, GetUniversityByIdState>(
                builder: (context, state) {
                  String universityName = 'غير متوفر';
                  if (state is getUniversityByIdSuccess &&
                      state.university.id == widget.universityId) {
                    universityName = state.university.name ?? 'غير متوفر';
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildInfoRow(widget.phone ?? 'غير متوفر', 'رقم الهاتف:'),
                      if (!widget.isSupervisor)
                        _buildInfoRow(universityName, 'الجامعة:')
                      else
                        _buildInfoRow(
                          widget.line.isNotEmpty ? widget.line : 'غير متوفر',
                          'الخط:',
                        ),
                    ],
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String title, String label) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyles.black14Bold.copyWith(fontSize: 14.sp)),
          Text(title, style: TextStyles.black14Bold.copyWith(fontSize: 14.sp)),
        ],
      ),
    );
  }
}
