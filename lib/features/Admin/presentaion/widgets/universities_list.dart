import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/resources/color_manager.dart';
import '../../../../core/resources/text_styles.dart';
import '../../../user/presentaion/bloc/get_all_universities/get_all_universities_cubit.dart';
import '../../../user/presentaion/bloc/get_all_universities/get_all_universities_state.dart';
import '../widgets/more_options_button.dart';
import '../widgets/edit_handler.dart';
import '../../../user/Domain/entities/university_entity.dart';
import 'SettingsExpandableCard.dart';

class UniversitiesListWidget extends StatelessWidget {
  final List<UniversityEntity> universities;
  final List<UniversityEntity> filteredUniversities;
  final List<bool> isExpandedUniversity;
  final Function(int) onToggle;
  final Function(dynamic) showDeleteDialog;
  final VoidCallback updateFiltered;

  const UniversitiesListWidget({
    super.key,
    required this.universities,
    required this.filteredUniversities,
    required this.isExpandedUniversity,
    required this.onToggle,
    required this.showDeleteDialog,
    required this.updateFiltered,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GetAllUniversitiesCubit, GetAllUniversitiesState>(
      listener: (context, state) {
        if (state is GetAllUniversitiesError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message, style: TextStyle(fontSize: 14.sp)),
            ),
          );
        } else if (state is GetAllUniversitiesSuccess) {
          updateFiltered();
        }
      },
      builder: (context, state) {
        if (state is GetAllUniversitiesSuccess) {
          if (filteredUniversities.isEmpty) {
            return Center(
              child: Text(
                "لا يوجد جامعات",
                style: TextStyles.white20Bold.copyWith(fontSize: 20.sp),
              ),
            );
          }
          return ListView.builder(
            padding: EdgeInsets.all(16.w),
            itemCount: filteredUniversities.length,
            itemBuilder: (context, index) {
              final university = filteredUniversities[index];
              final activeUsers =
                  university.users?.where((user) => user.status == "active").toList() ?? [];

              return SettingsExpandableCard(
                name: university.name ?? 'لا يوجد اسم',
                isSupervisor: false,
                isExpanded: isExpandedUniversity[index],
                location: university.location ?? 'غير متوفر',
                usersCount: activeUsers.length,
                onToggle: () => onToggle(index),
                deleteIcon: MoreOptionsButton(
                  entity: university,
                  onEdit: (e) => EditHandler.openEditPage(context, e),
                  onDelete: showDeleteDialog,
                ),
              );
            },
          );
        } else if (state is GetAllUniversitiesLoading) {
          return Center(
            child: CircularProgressIndicator(color: ColorManager.secondColor),
          );
        } else {
          return Center(
            child: Text(
              state is GetAllUniversitiesError ? state.message : "حدث خطأ أثناء التحميل",
              style: TextStyles.white20Bold.copyWith(fontSize: 18.sp),
            ),
          );
        }
      },
    );
  }
}
