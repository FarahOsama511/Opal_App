import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/resources/color_manager.dart';
import '../../../../core/resources/text_styles.dart';
import '../widgets/more_options_button.dart';
import '../widgets/edit_handler.dart';
import '../../../user/presentaion/bloc/get_all_downtowns/get_all_down_town_cubit.dart';
import '../../../user/presentaion/bloc/get_all_downtowns/get_all_down_town_state.dart';
import '../../../Admin/Domain/entities/down_town_entity.dart';
import 'SettingsExpandableCard.dart';

class CitiesListWidget extends StatelessWidget {
  final List<DownTownEntity> cities;
  final List<DownTownEntity> filteredCities;
  final List<bool> isExpandedCities;
  final Function(int) onToggle;
  final Function(dynamic) showDeleteDialog;
  final Function updateFiltered;

  const CitiesListWidget({
    super.key,
    required this.cities,
    required this.filteredCities,
    required this.isExpandedCities,
    required this.onToggle,
    required this.showDeleteDialog,
    required this.updateFiltered,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GetAllDownTownCubit, GetAllDownTownState>(
      listener: (context, state) {
        if (state is GetAllDownTownsError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message, style: TextStyle(fontSize: 14.sp)),
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is GetAllDownTownsSuccess) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            cities.clear();
            cities.addAll(state.getAllDownTowns);
            updateFiltered();
          });

          if (filteredCities.isEmpty) {
            return Center(
              child: Text(
                "لا يوجد مدن",
                style: TextStyles.white20Bold.copyWith(fontSize: 20.sp),
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(16.w),
            itemCount: filteredCities.length,
            itemBuilder: (context, index) {
              final city = filteredCities[index];
              return SettingsExpandableCard(
                name: city.name ?? 'لا يوجد اسم',
                location: city.name ?? 'غير متوفر',
                isSupervisor: false,
                isExpanded: isExpandedCities[index],
                usersCount: city.users?.length ?? 0,
                onToggle: () => onToggle(index),
                deleteIcon: MoreOptionsButton(
                  entity: city,
                  onEdit: (e) => EditHandler.openEditPage(context, e),
                  onDelete: showDeleteDialog,
                ),
              );
            },
          );
        } else if (state is GetAllDownTownsLoading) {
          return Center(
            child: CircularProgressIndicator(color: ColorManager.secondColor),
          );
        } else {
          return Center(
            child: Text(
              state is GetAllDownTownsError ? state.message : "حدث خطأ أثناء التحميل",
              style: TextStyles.white20Bold.copyWith(fontSize: 18.sp),
            ),
          );
        }
      },
    );
  }
}
