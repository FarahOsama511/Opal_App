import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/resources/color_manager.dart';
import '../../../../core/resources/text_styles.dart';
import '../../../user/Domain/entities/user_entity.dart';
import '../../Domain/entities/line_entity.dart';
import '../bloc/get_lines/get_all_lines_cubit.dart';
import '../bloc/get_lines/get_all_lines_state.dart';
import '../bloc/update_admin_supervisor/update_admin_supervisor_cubit.dart';
import '../bloc/update_admin_supervisor/update_admin_supervisor_state.dart';
import '../widgets/Universities_Multi_Dropdown .dart';
import '../widgets/custom_widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditSupervisorPage extends StatefulWidget {
  UserEntity user;
  EditSupervisorPage({super.key, required this.user});

  @override
  State<EditSupervisorPage> createState() => _EditSupervisorPageState();
}

class _EditSupervisorPageState extends State<EditSupervisorPage> {
  LineEntity? selectedItem;
  List<String> selectedUniversities = [];

  @override
  void initState() {
    super.initState();
    final selectedUser = widget.user;
    selectedUniversities =
        selectedUser.universities?.map((u) => u.id ?? '').toList() ?? [];
    print(
      'EditSupervisorPage: initial user university ids = $selectedUniversities',
    );
    selectedItem = selectedUser.line;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<
      UpdateAdminOrSupervisorCubit,
      UpdateAdminOrSupervisorState
    >(
      listener: (context, state) {
        if (state is UpdateAdminOrSupervisorError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message, style: TextStyle(fontSize: 14.sp)),
            ),
          );
        }
        if (state is UpdateAdminOrSupervisorSuccess) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "تم التعديل بنجاح",
                style: TextStyle(fontSize: 14.sp),
              ),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: ColorManager.secondColor,
        appBar: AppBar(
          elevation: 0,
          title: Text("تعديل البيانات", style: TextStyles.black20Bold),
          centerTitle: true,
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black, size: 30),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<LinesCubit, GetAllLinesState>(
                builder: (context, state) {
                  if (state is LinesLoading) {
                    return const CircularProgressIndicator(
                      color: ColorManager.primaryColor,
                    );
                  } else if (state is LinesLoaded) {
                    final allLines = state.Liness;
                    return CustomDropdown<String>(
                      label: 'اختر الخط الخاص بك',
                      value: selectedItem?.id,
                      items: allLines.map((line) => line.id!).toList(),
                      onChanged: (id) {
                        setState(() {
                          selectedItem = allLines.firstWhere(
                            (line) => line.id == id,
                          );
                        });
                      },
                      displayString: (id) =>
                          allLines.firstWhere((line) => line.id == id).name!,
                    );
                  } else {
                    return Text(
                      'فشل في تحميل الخطوط',
                      style: TextStyles.black14Bold,
                    );
                  }
                },
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: UniversitiesMultiDropdown(
                  initialSelectedIds: selectedUniversities,
                  onSelectionChanged: (values) {
                    setState(() {
                      selectedUniversities = values.map((u) => u.id!).toList();
                    });
                  },
                ),
              ),
              SizedBox(height: 30.h),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorManager.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                  ),
                  onPressed: () {
                    final updatedUser = widget.user.copyWith(
                      lineId: selectedItem!.id,
                      universitiesId: selectedUniversities,
                    );
                    BlocProvider.of<UpdateAdminOrSupervisorCubit>(
                      context,
                    ).updateAdminOrSupervisor(updatedUser);
                  },
                  child: Text("حفظ التعديلات", style: TextStyles.white14Bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
