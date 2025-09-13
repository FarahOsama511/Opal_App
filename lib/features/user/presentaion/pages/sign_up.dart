import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/resources/color_manager.dart';
import '../../../../core/resources/text_styles.dart';
import '../../../Admin/Domain/entities/down_town_entity.dart';
import '../../../Admin/Domain/entities/line_entity.dart';
import '../../../Admin/presentaion/bloc/get_lines/get_all_lines_cubit.dart';
import '../../../Admin/presentaion/bloc/get_lines/get_all_lines_state.dart';
import '../../../Admin/presentaion/widgets/custom_widgets.dart';
import '../../../Admin/presentaion/widgets/text_field.dart';
import '../../Domain/entities/authentity.dart';
import '../../Domain/entities/university_entity.dart';
import '../../Domain/entities/user_entity.dart';
import '../bloc/auth_cubit.dart';
import '../bloc/auth_state.dart';
import '../bloc/get_all_downtowns/get_all_down_town_cubit.dart';
import '../bloc/get_all_downtowns/get_all_down_town_state.dart';
import '../bloc/get_all_universities/get_all_universities_cubit.dart';
import '../bloc/get_all_universities/get_all_universities_state.dart';
import '../bloc/user_cubit.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  UniversityEntity? selectedUniversity;
  LineEntity? selectedLine;
  DownTownEntity? selectedDownTown;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController universityCardId = TextEditingController();
  final TextEditingController otherUniversityController =
      TextEditingController();

  String? validation(String? value) {
    if (value == null || value.isEmpty) {
      return 'هذا الحقل مطلوب';
    }
    return null;
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    phoneController.dispose();
    universityCardId.dispose();
    otherUniversityController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is AuthSuccess) {
                BlocProvider.of<GetAllUserCubit>(
                  context,
                ).fetchAllUsers(); // جلب كل المستخدمين مرة أخرى
                context.go('/waiting'); // التنقل
              } else if (state is AuthFailure) {
                print("${state.error}");
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.error)));
              }
            },
            builder: (context, state) {
              if (state is AuthLoading) {
                return SizedBox(
                  height: 500.h,
                  child: const Center(child: CircularProgressIndicator()),
                );
              } else {
                return Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(height: 40.h),
                      const LogoCircle(),
                      SizedBox(height: 37.h),

                      // الاسم
                      CustomTextField(
                        hint: 'الاسم',
                        controller: nameController,
                        validator: validation,
                      ),
                      CustomTextField(
                        hint: 'رقم الهاتف',
                        controller: phoneController,
                        validator: validation,
                      ),
                      CustomTextField(
                        hint: 'الرقم الجامعي',
                        controller: universityCardId,
                        validator: validation,
                      ),
                      SizedBox(height: 16.h),
                      BlocBuilder<
                        GetAllUniversitiesCubit,
                        GetAllUniversitiesState
                      >(
                        builder: (context, state) {
                          if (state is GetAllUniversitiesLoading) {
                            return const CircularProgressIndicator(
                              color: ColorManager.primaryColor,
                            );
                          } else if (state is GetAllUniversitiesSuccess) {
                            final allUniversities = state.GetAllUniversities;
                            return CustomDropdown(
                              label: 'الجامعة',
                              value: selectedUniversity,
                              items: allUniversities,
                              onChanged: (value) {
                                setState(() => selectedUniversity = value);
                              },
                              displayString: (u) => u.name!,
                            );
                          } else {
                            return Text(
                              'فشل في تحميل الجامعات',
                              style: TextStyles.black14Bold,
                            );
                          }
                        },
                      ),

                      // إذا كانت الجامعة "غير ذلك"
                      if (selectedUniversity?.name == 'غير ذلك')
                        CustomTextField(
                          hint: 'اكتب اسم الجامعة',
                          controller: otherUniversityController,
                          validator: validation,
                        ),
                      BlocBuilder<LinesCubit, GetAllLinesState>(
                        builder: (context, state) {
                          if (state is LinesLoading) {
                            return const CircularProgressIndicator(
                              color: ColorManager.primaryColor,
                            );
                          } else if (state is LinesLoaded) {
                            final allLines = state.Liness;
                            return CustomDropdown(
                              label: 'الخط',
                              value: selectedLine,
                              items: allLines,
                              onChanged: (value) {
                                setState(() => selectedLine = value);
                              },
                              displayString: (u) => u.name!,
                            );
                          } else {
                            return Text(
                              'فشل في تحميل الخطوط',
                              style: TextStyles.black14Bold,
                            );
                          }
                        },
                      ),
                      // SizedBox(height: 20.h),
                      BlocBuilder<GetAllDownTownCubit, GetAllDownTownState>(
                        builder: (context, state) {
                          if (state is GetAllDownTownsLoading) {
                            return const CircularProgressIndicator(
                              color: ColorManager.primaryColor,
                            );
                          } else if (state is GetAllDownTownsSuccess) {
                            final allDownTowns = state.getAllDownTowns;
                            return CustomDropdown(
                              label: 'المدينة',
                              value: selectedDownTown,
                              items: allDownTowns,
                              onChanged: (value) {
                                setState(() => selectedDownTown = value);
                              },
                              displayString: (u) => u.name!,
                            );
                          } else {
                            return Text(
                              'فشل في تحميل المدن',
                              style: TextStyles.black14Bold,
                            );
                          }
                        },
                      ),
                      SizedBox(height: 20.h),
                      // زر التسجيل
                      PrimaryButton(
                        backgroundColor: ColorManager.primaryColor,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<AuthCubit>().register(
                              RegisterEntity(
                                user: UserEntity(
                                  name: nameController.text,
                                  phone: phoneController.text,
                                  universityCardId: universityCardId.text,
                                  university: selectedUniversity,
                                  line: selectedLine,
                                  universityId: selectedUniversity!.id,
                                  downTown: selectedDownTown,
                                  role: 'student',
                                ),
                              ),
                            );
                          }
                        },
                        text: 'تقديم الطلب',
                      ),

                      SizedBox(height: 15.h),

                      // سجل الدخول
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'لديك حساب بالفعل؟',
                            style: TextStyles.grey14Regular,
                          ),
                          SizedBox(width: 4.w),
                          GestureDetector(
                            onTap: () {
                              context.go('/signin');
                            },
                            child: Text(
                              'سجل الدخول',
                              style: TextStyles.red12Bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30.h),
                    ],
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
