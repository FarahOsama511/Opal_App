import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:opal_app/core/resources/color_manager.dart';
import 'package:opal_app/features/Admin/Domain/entities/tour.dart';
import 'package:opal_app/features/Admin/presentaion/bloc/add_lines/add_line_cubit.dart';
import 'package:opal_app/features/Admin/presentaion/bloc/add_lines/add_line_state.dart';
import 'package:opal_app/features/Admin/presentaion/widgets/custom_widgets.dart';
import 'package:opal_app/features/Admin/presentaion/widgets/text_field.dart';
import '../../../../core/resources/text_styles.dart';
import '../../Domain/entities/line_entity.dart';

class AddLine extends StatefulWidget {
  const AddLine({super.key});

  @override
  State<AddLine> createState() => _AddLineState();
}

String? validatorMessage(String? value) {
  if (value == null || value.isEmpty) {
    return 'يرجي إدخال اسم الخط';
  }
  return null;
}

class _AddLineState extends State<AddLine> {
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final size = MediaQuery.of(context).size;
    TextEditingController LineController = TextEditingController();
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
                  hint: 'اسم الخط',
                  controller: LineController,
                  validator: validatorMessage,
                ),
                SizedBox(height: 20.h),

                BlocConsumer<AddLineCubit, AddLineState>(
                  listener: (context, state) {
                    if (state is AddLineError) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(state.message)));
                    } else if (state is AddLineSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'تمت الإضافة بنجاح',
                            style: TextStyles.white12Bold,
                          ),
                        ),
                      );
                      Navigator.pushReplacementNamed(context, '/adminScreen');
                    }
                  },
                  builder: (context, state) {
                    print('stateLine is ${state}');
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
                              name: LineController.text,
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
                  text: 'إلغاء ',
                  onPressed: () {
                    setState(() {
                      Navigator.pop(context);
                    });
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
