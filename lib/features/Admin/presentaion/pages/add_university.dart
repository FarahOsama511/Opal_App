import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/resources/color_manager.dart';
import '../../../../core/resources/text_styles.dart';
import '../../../user/Domain/entities/university_entity.dart';
import '../../../user/presentaion/bloc/get_all_universities/get_all_universities_cubit.dart';
import '../bloc/add_university/add_university_cubit.dart';
import '../bloc/add_university/add_university_state.dart';
import '../widgets/custom_widgets.dart';
import '../widgets/text_field.dart';

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
  final _formKey = GlobalKey<FormState>();
  TextEditingController universityController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  @override
  void dispose() {
    universityController.dispose();
    countryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.secondColor,
      //  resizeToAvoidBottomInset: true,
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
                        context.go('/adminScreen');
                        BlocProvider.of<GetAllUniversitiesCubit>(
                          context,
                        ).fetchAlluniversities();
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
                                location: countryController.text,
                                name: universityController.text,
                                createdAt: DateTime.now(),
                                updatedAt: DateTime.now(),
                              ),
                              context,
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
                        context.pop();
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
