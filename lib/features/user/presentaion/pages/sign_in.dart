import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/resources/color_manager.dart';
import '../../../../core/resources/text_styles.dart';
import '../../../Admin/presentaion/widgets/custom_widgets.dart';
import '../../../Admin/presentaion/widgets/text_field.dart';
import '../bloc/auth_cubit.dart';
import '../bloc/auth_state.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  String? selectedRole;
  final TextEditingController identifierController = TextEditingController();
  final TextEditingController credentialController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    identifierController.dispose();
    credentialController.dispose();
  }

  String? _validateIdentifier(String? value) {
    if (value == null || value.isEmpty) {
      return selectedRole == 'طالب'
          ? 'يرجى إدخال رقم الهاتف'
          : 'يرجى إدخال الايميل';
    }
    return null;
  }

  String? _validateCredential(String? value) {
    if (value == null || value.isEmpty) {
      return selectedRole == 'طالب'
          ? 'يرجى إدخال الرقم الجامعي'
          : 'يرجى إدخال كلمة السر';
    }
    return null;
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (selectedRole == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(_buildSnackBar('يرجى اختيار الدور أولاً'));
      return;
    }

    await context.read<AuthCubit>().login(
      identifierController.text,
      credentialController.text,
      selectedRole!,
    );
    identifierController.clear();
    credentialController.clear();
  }

  SnackBar _buildSnackBar(String message) {
    return SnackBar(
      backgroundColor: ColorManager.greyColor,
      content: Text(message, style: TextStyles.white12Bold),
    );
  }

  void _handleAuthState(BuildContext context, AuthState state) {
    if (state is AuthFailure) {
      ScaffoldMessenger.of(context).showSnackBar(_buildSnackBar(state.error));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: BlocConsumer<AuthCubit, AuthState>(
              listener: (context, state) {
                if (state is AuthSuccess) {
                  _navigateBasedOnRole(
                    context.read<AuthCubit>().user?.user.role,
                  );
                }
                _handleAuthState(context, state);
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
                      onChanged: (value) =>
                          setState(() => selectedRole = value),
                    ),

                    SizedBox(height: 20.h),

                    CustomTextField(
                      controller: identifierController,
                      hint: selectedRole == 'طالب' ? 'رقم الهاتف' : 'ايميل',
                      validator: _validateIdentifier,
                      keyboardType: selectedRole == 'طالب'
                          ? TextInputType.phone
                          : TextInputType.emailAddress,
                    ),

                    SizedBox(height: 15.h),

                    CustomTextField(
                      controller: credentialController,
                      hint: selectedRole == 'طالب'
                          ? 'الرقم الجامعي'
                          : 'كلمة السر',
                      validator: _validateCredential,
                      obscureText: selectedRole != 'طالب',
                    ),

                    SizedBox(height: 25.h),

                    PrimaryButton(
                      backgroundColor: ColorManager.primaryColor,
                      text: 'تسجيل الدخول',
                      isLoading: state is AuthLoading,
                      onPressed: state is AuthLoading ? null : _submitForm,
                    ),

                    SizedBox(height: 15.h),

                    _buildSignUpLink(),
                    SizedBox(height: 40.h),
                    _buildTermsAndConditions(),
                    SizedBox(height: 20.h),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void _navigateBasedOnRole(String? role) {
    // final user = context.read<AuthCubit>().user!.user;

    switch (role) {
      case 'student':
        context.go('/home');

        break;
      case 'supervisor':
        //  print("user is $user");
        context.go('/supervisorScreen');

        break;
      case 'admin':
        context.go('/adminScreen');
        break;
    }
  }

  Widget _buildSignUpLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('ليس لديك حساب؟', style: TextStyles.grey14Regular),
        SizedBox(width: 3.w),
        GestureDetector(
          onTap: () => context.go('/signup'),
          child: Text('قدم طلب', style: TextStyles.red12Bold),
        ),
      ],
    );
  }

  Widget _buildTermsAndConditions() {
    final Uri solvestaUrl = Uri.parse(
      'https://www.facebook.com/share/1CGQ35xSun/?mibextid=wwXIfr',
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Powered By ', style: TextStyles.black10Bold),
        GestureDetector(
          onTap: () async {
            if (await canLaunchUrl(solvestaUrl)) {
              await launchUrl(
                solvestaUrl,
                mode: LaunchMode.externalApplication,
              );
            }
          },
          child: Text(
            'Solvesta',
            style: TextStyles.red10Bold.copyWith(
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}
