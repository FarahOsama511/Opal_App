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
import '../../../supervisor/presentation/pages/show_tours.dart';

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
    identifierController.dispose();
    credentialController.dispose();
    super.dispose();
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
    final user = context.read<AuthCubit>().user!.user;

    switch (role) {
      case 'student':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const UserHomeScreen()),
        );
        break;
      case 'supervisor':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => ShowToursBySuperVisor(user: user)),
        );
        break;
      case 'admin':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AdminHomeScreen()),
        );
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
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SignUpScreen()),
          ),
          child: Text('قدم طلب', style: TextStyles.red12Bold),
        ),
      ],
    );
  }

  Widget _buildTermsAndConditions() {
    return Column(
      children: [
        Text('بتسجيلك فإنك توافق على', style: TextStyles.black10Bold),
        SizedBox(height: 4.h),
        Text(
          'شروط الخدمة وسياسة الخصوصية واستخدام الكوكيز',
          style: TextStyles.red10Bold,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
