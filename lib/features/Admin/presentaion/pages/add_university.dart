import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:opal_app/core/resources/color_manager.dart';
import 'package:opal_app/features/Admin/presentaion/widgets/custom_widgets.dart';
import 'package:opal_app/features/Admin/presentaion/widgets/text_field.dart';
import 'package:opal_app/features/user/Domain/entities/university_entity.dart';
import '../../../../core/resources/text_styles.dart';
import '../bloc/add_university/add_university_cubit.dart';
import '../bloc/add_university/add_university_state.dart';

class AddUniversity extends StatefulWidget {
  const AddUniversity({super.key});

  @override
  State<AddUniversity> createState() => _AddUniversityState();
}

String? validation(String? value) {
  if (value == null || value.isEmpty) {
    return 'هذا الحقل مطلوب';
  }
  return null;
}

class _AddUniversityState extends State<AddUniversity> {
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    TextEditingController universityController = TextEditingController();
    TextEditingController countryController = TextEditingController();

    return Scaffold(
      backgroundColor: ColorManager.secondColor,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
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
                    hint: 'اسم الجامعة',
                    controller: universityController,
                    validator: validation,
                  ),
                  CustomTextField(
                    hint: 'اسم المدينة',
                    controller: countryController,
                    validator: validation,
                  ),
                  SizedBox(height: 20.h),

                  BlocConsumer<AddUniversityCubit, AddUniversityState>(
                    listener: (context, state) {
                      if (state is AddUniversityFailure) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(state.error)));
                      } else if (state is AddUniversitySuccess) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              state.message,
                              style: TextStyles.white12Bold,
                            ),
                          ),
                        );
                        Navigator.pushReplacementNamed(context, '/adminScreen');
                      }
                    },
                    builder: (context, state) {
                      print('stateUniversity is ${state}');
                      if (state is AddUniversityLoading) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: ColorManager.primaryColor,
                          ),
                        );
                      }
                      return PrimaryButton(
                        backgroundColor: ColorManager.primaryColor,
                        text: 'اضافة جامعة',
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<AddUniversityCubit>().AddUniversity(
                              UniversityEntity(
                                id: "555555555555",
                                location: countryController.text,
                                name: universityController.text,
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
                    text: 'إلفاء ',
                    onPressed: () {
                      setState(() {
                        Navigator.pop(context);
                      });
                    },
                    backgroundColor: ColorManager.greyColor,
                  ),
                  SizedBox(height: 30.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
