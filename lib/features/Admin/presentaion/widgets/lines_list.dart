import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/resources/color_manager.dart';
import '../../../../core/resources/text_styles.dart';
import '../widgets/more_options_button.dart';
import '../widgets/edit_handler.dart';
import '../../../Admin/Domain/entities/line_entity.dart';
import '../bloc/get_lines/get_all_lines_cubit.dart';
import '../bloc/get_lines/get_all_lines_state.dart';
import 'SettingsExpandableCard.dart';

class LinesListWidget extends StatelessWidget {
  final List<LineEntity> lines;
  final List<LineEntity> filteredLines;
  final List<bool> isExpandedLines;
  final Function(int) onToggle;
  final Function(dynamic) showDeleteDialog;
  final VoidCallback updateFiltered;

  const LinesListWidget({
    super.key,
    required this.lines,
    required this.filteredLines,
    required this.isExpandedLines,
    required this.onToggle,
    required this.showDeleteDialog,
    required this.updateFiltered,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LinesCubit, GetAllLinesState>(
      listener: (context, state) {
        if (state is LinesError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message, style: TextStyle(fontSize: 14.sp)),
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is LinesLoaded) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            updateFiltered();
          });

          if (filteredLines.isEmpty) {
            return Center(
              child: Text(
                "لا يوجد خطوط",
                style: TextStyles.white20Bold.copyWith(fontSize: 20.sp),
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(16.w),
            itemCount: filteredLines.length,
            itemBuilder: (context, index) {
              final line = filteredLines[index];
              return SettingsExpandableCard(
                name: line.name ?? 'لا يوجد اسم',
                isSupervisor: true,
                isExpanded: isExpandedLines[index],
                notes: line.notes ?? 'غير متوفر',
                onToggle: () => onToggle(index),
                deleteIcon: MoreOptionsButton(
                  entity: line,
                  onEdit: (e) => EditHandler.openEditPage(context, e),
                  onDelete: showDeleteDialog,
                ),
              );
            },
          );
        } else if (state is LinesLoading) {
          return Center(
            child: CircularProgressIndicator(color: ColorManager.secondColor),
          );
        } else {
          return Center(
            child: Text(
              state is LinesError ? state.message : "حدث خطأ أثناء التحميل",
              style: TextStyles.white20Bold.copyWith(fontSize: 18.sp),
            ),
          );
        }
      },
    );
  }
}
