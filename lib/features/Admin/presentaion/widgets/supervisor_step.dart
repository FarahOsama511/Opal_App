import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/resources/color_manager.dart';
import '../../../../core/resources/text_styles.dart';
import '../../../user/presentaion/bloc/user_cubit.dart';
import '../../../user/presentaion/bloc/user_state.dart';
import '../../Domain/entities/tour.dart';
import 'custom_widgets.dart';

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
      crossAxisAlignment: CrossAxisAlignment.center,
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
              return const CircularProgressIndicator(
                color: ColorManager.primaryColor,
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

              print("Selected supervisor: ${widget.selectedSupervisor?.id}");
              print(
                "All supervisor IDs: ${allSupervisors.map((s) => s.id).toList()}",
              );

              return CustomDropdown<SuperVisorEntity>(
                label: 'اختر مشرف',
                value: null,
                items: allSupervisors,
                onChanged: widget.onSupervisorChanged,
                displayString: (u) => u.name ?? '',
              );
            } else {
              return Text(
                'فشل في تحميل المشرفين',
                style: TextStyles.black14Bold.copyWith(fontSize: 14.sp),
              );
            }
          },
        ),
      ],
    );
  }
}
