import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:opal_app/core/resources/color_manager.dart';
import 'package:opal_app/features/Admin/Domain/entities/tour.dart';
import 'package:opal_app/features/Admin/presentaion/bloc/add_lines/add_line_cubit.dart';
import 'package:opal_app/features/Admin/presentaion/bloc/add_lines/add_line_state.dart';
import 'package:opal_app/features/Admin/presentaion/widgets/custom_widgets.dart';
import 'package:opal_app/features/Admin/presentaion/widgets/text_field.dart';
import '../../../../core/resources/text_styles.dart';
import 'admin_home_screen.dart';

class AddLine extends StatefulWidget {
  const AddLine({super.key});

  @override
  State<AddLine> createState() => _AddLineState();
}

class _AddLineState extends State<AddLine> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController lineController = TextEditingController();

  @override
  void dispose() {
    lineController.dispose();
    super.dispose();
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

                const LogoCircle(),
                SizedBox(height: 47.h),

                CustomTextField(
                  hint: 'اسم الخط',
                  controller: lineController,
                  validatorMessage: 'يرجي إدخال اسم الخط',
                ),

                SizedBox(height: 20.h),

                BlocConsumer<AddLineCubit, AddLineState>(
                  listener: (context, state) {
                    if (state is AddLineError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.message)),
                      );
                    } else if (state is AddLineSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'تمت الإضافة بنجاح',
                            style: TextStyles.white12Bold,
                          ),
                        ),
                      );
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AdminHomeScreen(),
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is AddLineLoading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: ColorManager.primaryColor,
                        ),
                      );
                    }
                    return PrimaryButton(
                      backgroundColor: ColorManager.primaryColor,
                      text: 'اضافة خط',
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<AddLineCubit>().AddLine(
                            LineEntity(
                              name: lineController.text,
                              createdAt: DateTime.now(),
                              updatedAt: DateTime.now(),
                            ),
                          );
                        }
                      },
                    );
                  },
                ),

                SizedBox(height: 20.h),

                PrimaryButton(
                  text: 'إلفاء',
                  onPressed: () => Navigator.pop(context),
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
