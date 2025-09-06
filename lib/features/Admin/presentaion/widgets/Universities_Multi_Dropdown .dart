import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/resources/color_manager.dart';
import '../../../../core/resources/text_styles.dart';
import '../../../user/Domain/entities/university_entity.dart';
import '../../../user/presentaion/bloc/get_all_universities/get_all_universities_cubit.dart';
import '../../../user/presentaion/bloc/get_all_universities/get_all_universities_state.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class UniversitiesMultiDropdown extends StatefulWidget {
  final Function(List<UniversityEntity>) onSelectionChanged;
  UniversitiesMultiDropdown({super.key, required this.onSelectionChanged});

  @override
  State<UniversitiesMultiDropdown> createState() =>
      _UniversitiesMultiDropdownState();
}

class _UniversitiesMultiDropdownState extends State<UniversitiesMultiDropdown> {
  List<UniversityEntity> _selectedUniversities = [];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetAllUniversitiesCubit, GetAllUniversitiesState>(
      builder: (context, state) {
        if (state is GetAllUniversitiesLoading) {
          return const Center(
            child: CircularProgressIndicator(color: ColorManager.primaryColor),
          );
        } else if (state is GetAllUniversitiesError) {
          return Center(child: Text("Error: ${state.message}"));
        } else if (state is GetAllUniversitiesSuccess) {
          final universities = state.GetAllUniversities;

          return MultiSelectDialogField<UniversityEntity>(
            items: universities
                .map((u) => MultiSelectItem<UniversityEntity>(u, u.name ?? ""))
                .toList(),
            buttonIcon: Icon(
              Icons.arrow_drop_down,
              color: ColorManager.greyColor,
              size: 24.sp,
            ),
            checkColor: ColorManager.secondColor,
            selectedColor: ColorManager.primaryColor,
            dialogHeight: 300.h,
            title: Text(
              "اختر الجامعات",
              style: TextStyles.grey14Regular.copyWith(fontSize: 14.sp),
            ),
            buttonText: Text(
              "اختر الجامعات",
              style: TextStyles.grey14Regular.copyWith(fontSize: 14.sp),
            ),
            decoration: BoxDecoration(
              color: ColorManager.secondColor,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: ColorManager.greyColor, width: 1.w),
            ),
            listType: MultiSelectListType.LIST,
            initialValue: _selectedUniversities,
            onConfirm: (values) {
              setState(() {
                _selectedUniversities = values;
              });
              widget.onSelectionChanged(values);
            },
          );
        }
        return const SizedBox();
      },
    );
  }
}
