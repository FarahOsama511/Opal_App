import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/resources/text_styles.dart';
import '../../../supervisor/bloc/get_university_by_id/get_university_by_id_cubit.dart';

class ExpandableCard extends StatefulWidget {
  final String name;
  final String phone;
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
    required this.phone,
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
    BlocProvider.of<GetUniversityByIdCubit>(
      context,
    ).getUniversityById(widget.universityId ?? "");
  }

  @override
  Widget build(BuildContext context) {
    final universityName = widget.universityId != null
        ? context.read<GetUniversityByIdCubit>().nameOfUniversity ?? ""
        : "";

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
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.name,
                    textAlign: TextAlign.right,
                    style: TextStyles.black14Bold,
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
                  ),
                  onPressed: widget.onToggle,
                ),
              ],
            ),
          ),
          if (widget.isExpanded)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildInfoRow(widget.phone, 'رقم الهاتف:'),
                  if (!widget.isSupervisor) ...[
                    _buildInfoRow(universityName, 'الجامعة:'),
                  ] else ...[
                    _buildInfoRow(widget.line, 'الخط:'),
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
          Text(label, style: TextStyles.black14Bold),
          Text(title, style: TextStyles.black14Bold),
        ],
      ),
    );
  }
}
