import 'package:flutter/material.dart';
import 'package:opal_app/features/auth/presentaion/pages/sign_up.dart';
import 'package:opal_app/features/auth/presentaion/pages/user_home_screen.dart';
import '../../../Tours/presentaion/pages/home_screen.dart';
import '../../../Tours/presentaion/pages/supervisor_home_screen.dart';
import '../../../Tours/presentaion/widgets/custom_widgets.dart';
import '../../../Tours/presentaion/widgets/password_field.dart';
import '../../../Tours/presentaion/widgets/text_field.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  String? selectedRole;
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? phoneError;
  String? passwordError;
  bool _showPassword = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery
        .of(context)
        .size;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: size.height * 0.05),

              // اللوجو
              LogoCircle(size: size),
              const SizedBox(height: 20),

              // قائمة اختيار الدور
              CustomDropdown(
                label: 'اختر الدور',
                value: selectedRole,
                items: const['طالب', 'مشرف', 'مسؤول'],
                onChanged: (value) {
                  setState(() {
                    selectedRole = value;
                  });
                },
              ),

              const SizedBox(height: 10),

              // رقم الهاتف
              CustomTextField(
                controller: phoneController,
                hint: 'رقم الهاتف',
                validatorMessage: 'يرجى إدخال رقم الهاتف',
                errorText: phoneError,
              ),

              // كلمة المرور
              CustomPasswordField(
                controller: passwordController,
                hint: 'كلمة السر',
                validatorMessage: 'يرجى إدخال كلمة السر',
                visible: _showPassword,
                toggleVisibility: () {
                  setState(() {
                    _showPassword = !_showPassword;
                  });
                },
                errorText: passwordError,
              ),

              const SizedBox(height: 10),

              // زر تسجيل الدخول
              PrimaryButton(
                text: 'تسجيل الدخول',
                onPressed: () {
                  setState(() {
                    phoneError = phoneController.text.isEmpty
                        ? 'يرجى إدخال رقم الهاتف'
                        : null;
                    passwordError = passwordController.text.isEmpty
                        ? 'يرجى إدخال كلمة السر'
                        : null;
                  });

                  if (selectedRole == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('يرجى اختيار الدور أولاً')),
                    );
                    return;
                  }

                  if (phoneError != null || passwordError != null) return;

                  // التنقل حسب الدور
                  if (selectedRole == 'طالب') {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const HomeScreen()));
                  } else if (selectedRole == 'مشرف') {
                    Navigator.push(context, MaterialPageRoute(
                        builder: (_) => const SupervisorScreen()));
                  } else if (selectedRole == 'مسؤول') {
                    Navigator.push(context, MaterialPageRoute(
                        builder: (_) => const AdminHomeScreen()));
                  }
                },
              ),
              const SizedBox(height: 15),

              // ليس لديك حساب؟ قدم طلب
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignUpScreen()),
                      );
                    },
                    child: const Text(
                      'قدم طلب',
                      style: TextStyle(
                        color: Color(0xFFE71A45),
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Text('ليس لديك حساب؟'),
                ],
              ),

              const SizedBox(height: 200),

              // شروط الاستخدام
              Column(
                children: const [
                  Text('بتسجيلك فإنك توافق على',
                      style: TextStyle(color: Colors.black)),
                  SizedBox(height: 4),
                  Text(
                    'شروط الخدمة وسياسة الخصوصية واستخدام الكوكيز',
                    style: TextStyle(
                      color: Color(0xFFE71A45),
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
