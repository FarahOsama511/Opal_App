import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:opal_app/core/resources/color_manager.dart';
import 'package:opal_app/features/Admin/presentaion/bloc/delete_down_town/delete_down_town_cubit.dart';
import 'package:opal_app/features/Admin/presentaion/bloc/delete_down_town/delete_down_town_state.dart';
import 'package:opal_app/features/Admin/presentaion/bloc/delete_line/delete_line_cubit.dart';
import 'package:opal_app/features/Admin/presentaion/bloc/delete_line/delete_line_state.dart';
import 'package:opal_app/features/Admin/presentaion/bloc/delete_university/delete_university_cubit.dart';
import 'package:opal_app/features/Admin/presentaion/bloc/delete_university/delete_university_state.dart';
import 'package:opal_app/features/user/presentaion/bloc/get_all_universities/get_all_universities_cubit.dart';

class DeleteListenersWidget extends StatelessWidget {
  final Function(String) onUpdateLines;
  final Function(String) onUpdateCities;

  const DeleteListenersWidget({
    super.key,
    required this.onUpdateLines,
    required this.onUpdateCities,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<DeleteUniversityCubit, DeleteUniversityState>(
          listener: (context, state) {
            if (state is DeleteUniversityError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.message,
                    style: TextStyle(fontSize: 14.sp),
                  ),
                ),
              );
            } else if (state is DeleteUniversitySuccess) {
              BlocProvider.of<GetAllUniversitiesCubit>(context)
                  .fetchAlluniversities();

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.message,
                    style: TextStyle(fontSize: 14.sp),
                  ),
                ),
              );
            }
          },
        ),
        BlocListener<DeleteLineCubit, DeleteLineState>(
          listener: (context, state) {
            if (state is DeleteLineError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.message,
                    style: TextStyle(fontSize: 14.sp),
                  ),
                ),
              );
            } else if (state is DeleteLineLoaded) {
              onUpdateLines(state.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.deleteLine,
                    style: TextStyle(fontSize: 14.sp),
                  ),
                ),
              );
            }
          },
        ),
        BlocListener<DeleteDownTownCubit, DeleteDownTownState>(
          listener: (context, state) {
            if (state is DeleteDownTownError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: ColorManager.greyColor,
                  content: Text(
                    state.message,
                    style: TextStyle(fontSize: 14.sp),
                  ),
                ),
              );
            } else if (state is DeleteDownTownSuccess) {
              onUpdateCities(state.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: ColorManager.greyColor,
                  content: Text(
                    state.message,
                    style: TextStyle(fontSize: 14.sp),
                  ),
                ),
              );
            }
          },
        ),
      ],
      child: Container(), // مجرد placeholder
    );
  }
}
