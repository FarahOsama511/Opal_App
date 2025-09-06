import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:opal_app/core/resources/color_manager.dart';
import 'package:opal_app/features/Admin/Domain/entities/down_town_entity.dart';
import 'package:opal_app/features/Admin/presentaion/widgets/custom_widgets.dart';
import 'package:opal_app/features/Admin/presentaion/widgets/text_field.dart';
import '../../../../core/resources/text_styles.dart';
import '../bloc/add_down_town/add_down_town_cubit.dart';
import '../bloc/add_down_town/add_down_town_state.dart';

class AddDownTown extends StatefulWidget {
  const AddDownTown({super.key});

  @override
  State<AddDownTown> createState() => _AddDownTownState();
}

String? validatorMessage(String? value) {
  if (value == null || value.isEmpty) {
    return 'يرجي إدخال اسم المدينة';
  }
  return null;
}

class _AddDownTownState extends State<AddDownTown> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController downTownController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    downTownController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.secondColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 50.h),
                LogoCircle(),
                SizedBox(height: 47.h),
                CustomTextField(
                  hint: 'اسم المدينة',
                  controller: downTownController,
                  validator: validatorMessage,
                ),
                SizedBox(height: 20.h),

                BlocConsumer<AddDownTownCubit, AddDownTownState>(
                  listener: (context, state) {
                    if (state is AddDownTownFailure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.errorMessage)),
                      );
                    } else if (state is AddDownTownSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            state.successMessage,
                            style: TextStyles.white12Bold,
                          ),
                        ),
                      );
                      context.go('/adminScreen');
                    }
                  },
                  builder: (context, state) {
                    if (state is AddDownTownLoading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: ColorManager.primaryColor,
                        ),
                      );
                    }
                    return PrimaryButton(
                      backgroundColor: ColorManager.primaryColor,
                      text: 'اضافة مدينة',
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<AddDownTownCubit>().addDownTown(
                            DownTownEntity(name: downTownController.text),
                            context,
                          );
                        }
                      },
                    );
                  },
                ),
                SizedBox(height: 20.h),
                PrimaryButton(
                  text: 'إلغاء ',
                  onPressed: () {
                    context.pop();
                  },
                  backgroundColor: ColorManager.greyColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
