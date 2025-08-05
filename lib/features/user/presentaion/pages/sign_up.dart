import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:opal_app/core/resources/color_manager.dart';
import 'package:opal_app/features/Admin/Domain/entities/tour.dart';
import 'package:opal_app/features/user/Domain/entities/user_entity.dart';
import 'package:opal_app/features/user/presentaion/bloc/auth_cubit.dart';
import 'package:opal_app/features/user/presentaion/bloc/auth_state.dart';
import 'package:opal_app/features/user/presentaion/bloc/get_all_universities/get_all_universities_cubit.dart';
import 'package:opal_app/features/user/presentaion/bloc/get_all_universities/get_all_universities_state.dart';
import 'package:opal_app/features/user/presentaion/pages/sign_in.dart';
import 'package:opal_app/features/user/presentaion/pages/waiting_screen.dart';
import '../../../../core/resources/text_styles.dart';
import '../../../Admin/presentaion/widgets/custom_widgets.dart';
import '../../../Admin/presentaion/widgets/text_field.dart';
import '../../Domain/entities/authentity.dart';
import '../../Domain/entities/university_entity.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  UniversityEntity? selectedUniversity;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController universityCardId = TextEditingController();
  final TextEditingController otherUniversityController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<GetAllUniversitiesCubit>(context).fetchAlluniversities();
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
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WaitingScreen(),
                  ),
                );
              } else if (state is AuthFailure) {
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
                        validatorMessage: 'يرجى إدخال الاسم',
                      ),

                      // رقم الهاتف
                      CustomTextField(
                        hint: 'رقم الهاتف',
                        controller: phoneController,
                        validatorMessage: 'يرجى إدخال رقم الهاتف',
                      ),

                      // الرقم الجامعي
                      CustomTextField(
                        hint: 'الرقم الجامعي',
                        controller: universityCardId,
                        validatorMessage: 'يرجى إدخال الرقم الجامعي',
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
                          validatorMessage: 'يرجى إدخال اسم الجامعة',
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
                                  university: UniversityEntity(
                                    name: selectedUniversity!.name,
                                  ),
                                  line: LineEntity(
                                    id: "cmdxmfl6x0000otnp5m20ejbl",
                                  ),
                                  universityId: selectedUniversity!.id,
                                  role: 'طالب',
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
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignInScreen(),
                                ),
                              );
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
