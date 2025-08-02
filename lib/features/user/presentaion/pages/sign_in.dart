import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:opal_app/core/resources/color_manager.dart';
import 'package:opal_app/features/user/presentaion/bloc/auth_cubit.dart';
import 'package:opal_app/features/user/presentaion/bloc/auth_state.dart';
import 'package:opal_app/features/user/presentaion/pages/sign_up.dart';
import 'package:opal_app/features/user/presentaion/pages/user_home_screen.dart';
import '../../../../core/resources/text_styles.dart';
import '../../../Admin/presentaion/pages/admin_home_screen.dart';
import '../../../Admin/presentaion/widgets/custom_widgets.dart';
import '../../../Admin/presentaion/widgets/text_field.dart';
import '../../../supervisor/show_tours.dart';
import '../bloc/user_cubit.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  String? selectedRole;
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController universityCardId = TextEditingController();

  String? phoneError;
  String? IdError;
  @override
  void dispose() {
    super.dispose();
    phoneController.dispose();
    universityCardId.dispose();
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
                if (selectedRole == 'طالب') {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const UserHomeScreen()),
                  );
                } else if (selectedRole == 'مشرف') {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ShowToursBySuperVisor(
                        supervisorId:
                            context.read<GetAllUserCubit>().userId ?? "",
                      ),
                    ),
                  );
                } else if (selectedRole == 'مسؤول') {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const AdminHomeScreen()),
                  );
                }
              } else if (state is AuthFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: ColorManager.greyColor,
                    content: Text(state.error, style: TextStyles.white12Bold),
                  ),
                );
              }
            },
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 80.h),
                  const LogoCircle(),
                  SizedBox(height: 37.h),

                  CustomDropdown(
                    label: 'اختر الدور',
                    value: selectedRole,
                    items: const ['طالب', 'مشرف', 'مسؤول'],
                    onChanged: (value) {
                      setState(() {
                        selectedRole = value;
                      });
                    },
                  ),

                  SizedBox(height: 10.h),

                  CustomTextField(
                    controller: phoneController,
                    hint: selectedRole == 'طالب' ? 'رقم الهاتف' : 'ايميل',
                    validatorMessage: selectedRole == 'طالب'
                        ? 'يرجى إدخال رقم الهاتف'
                        : 'يرجى إدخال الايميل',
                    errorText: phoneError,
                  ),
                  CustomTextField(
                    controller: universityCardId,
                    hint: selectedRole == 'طالب'
                        ? ' الرقم الجامعي'
                        : 'كلمه السر',
                    validatorMessage: selectedRole == 'طالب'
                        ? 'يرجى إدخال الرقم الجامعي'
                        : 'يرجى إدخال كلمه السر',
                    errorText: IdError,
                  ),

                  SizedBox(height: 20.h),
                  PrimaryButton(
                    backgroundColor: ColorManager.primaryColor,
                    text: 'تسجيل الدخول',
                    isLoading: state is AuthLoading,
                    onPressed: (state is AuthLoading)
                        ? null
                        : () {
                            setState(() {
                              phoneError = phoneController.text.isEmpty
                                  ? selectedRole == 'طالب'
                                        ? 'يرجى إدخال رقم الهاتف'
                                        : 'يرجى إدخال الايميل'
                                  : null;
                              IdError = universityCardId.text.isEmpty
                                  ? selectedRole == 'طالب'
                                        ? 'يرجى إدخال الرقم الجامعي'
                                        : 'يرجى إدخال كلمه السر'
                                  : null;
                            });

                            if (selectedRole == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: ColorManager.greyColor,
                                  content: Text(
                                    'يرجى اختيار الدور أولاً',
                                    style: TextStyles.white12Bold,
                                  ),
                                ),
                              );
                              return;
                            }

                            if (phoneError != null || IdError != null) return;

                            context.read<AuthCubit>().login(
                              phoneController.text,
                              universityCardId.text,
                              selectedRole.toString(),
                            );
                          },
                  ),

                  SizedBox(height: 15.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('ليس لديك حساب؟', style: TextStyles.grey14Regular),
                      SizedBox(width: 3.w),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignUpScreen(),
                            ),
                          );
                        },
                        child: Text('قدم طلب', style: TextStyles.red12Bold),
                      ),
                    ],
                  ),

                  SizedBox(height: 100.h),
                  Column(
                    children: [
                      Text(
                        'بتسجيلك فإنك توافق على',
                        style: TextStyles.black10Bold,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'شروط الخدمة وسياسة الخصوصية واستخدام الكوكيز',
                        style: TextStyles.red10Bold,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),

                  SizedBox(height: 20.h),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
