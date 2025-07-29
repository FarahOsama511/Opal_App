import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opal_app/features/Admin/presentaion/widgets/custom_widgets.dart';
import 'package:opal_app/features/user/Domain/entities/user_entity.dart';
import 'package:opal_app/features/user/presentaion/bloc/user_cubit.dart';
import 'package:opal_app/features/user/presentaion/bloc/user_state.dart';

import '../../../../core/resources/color_manager.dart';

class SupervisorStep extends StatefulWidget {
  final UserEntity? selectedSupervisor;
  final ValueChanged<UserEntity?> onSupervisorChanged;

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
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Text(
          'اختيار المشرف',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        const SizedBox(height: 10),
        BlocBuilder<GetAllUserCubit, UserState>(
          builder: (context, state) {
            print("state is${state}");
            if (state is UserLoading) {
              return const CircularProgressIndicator(
                color: ColorManager.primaryColor,
              );
            } else if (state is UserSuccess) {
              final allSupervisors = state.user
                  .where((u) => u.role == "supervisor")
                  .toList();

              print("${state.user.length}");
              return CustomDropdown(
                label: 'اختر مشرف',
                value: widget.selectedSupervisor,
                items: allSupervisors,
                onChanged: widget.onSupervisorChanged,

                displayString: (u) => u.name!,
              );
            } else {
              return const Text('فشل في تحميل المشرفين');
            }
          },
        ),
      ],
    );
  }
}
