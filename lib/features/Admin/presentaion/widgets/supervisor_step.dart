import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:opal_app/features/Admin/Domain/entities/tour.dart';
import 'package:opal_app/features/Admin/presentaion/widgets/custom_widgets.dart';
import 'package:opal_app/features/user/presentaion/bloc/user_cubit.dart';
import 'package:opal_app/features/user/presentaion/bloc/user_state.dart';
import '../../../../core/resources/color_manager.dart';
import '../../../../core/resources/text_styles.dart';

class SupervisorStep extends StatefulWidget {
  final SuperVisorEntity? selectedSupervisor;
  final ValueChanged<SuperVisorEntity?> onSupervisorChanged;

  const SupervisorStep({
    super.key,
    required this.selectedSupervisor,
    required this.onSupervisorChanged,
  });

  @override
  State<SupervisorStep> createState() => _SupervisorStepState();
}

class _SupervisorStepState extends State<SupervisorStep> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<GetAllUserCubit>(context).fetchAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'اختيار المشرف',
          style: TextStyles.black20Bold.copyWith(fontSize: 20.sp),
          textAlign: TextAlign.right,
        ),
        SizedBox(height: 10.h),
        BlocBuilder<GetAllUserCubit, UserState>(
          builder: (context, state) {
            if (state is UserLoading) {
              return Center(
                child: CircularProgressIndicator(
                  color: ColorManager.primaryColor,
                ),
              );
            } else if (state is UserSuccess) {
              final allSupervisors = state.user
                  .where((u) => u.role == "supervisor")
                  .map(
                    (u) => SuperVisorEntity(
                      id: u.id,
                      name: u.name,
                      email: u.email,
                      phone: u.phone,
                      role: u.role,
                    ),
                  )
                  .toList();
              final SuperVisorEntity? selected = allSupervisors.firstWhere(
                (s) => s.id == widget.selectedSupervisor?.id,
                orElse: () => allSupervisors.isNotEmpty
                    ? allSupervisors.first
                    : SuperVisorEntity(
                        id: '',
                        name: '',
                        email: '',
                        phone: '',
                        role: '',
                      ),
              );

              return CustomDropdown<SuperVisorEntity>(
                label: 'اختر مشرف',
                value: selected,
                items: allSupervisors,
                onChanged: widget.onSupervisorChanged,
                displayString: (u) => u.name!,
              );
            } else {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: Text(
                  'فشل في تحميل المشرفين',
                  style: TextStyles.black14Bold.copyWith(fontSize: 14.sp),
                  textAlign: TextAlign.center,
                ),
              );
            }
          },
        ),
      ],
    );
  }
}
