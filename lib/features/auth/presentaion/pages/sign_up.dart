import 'package:flutter/material.dart';
import 'package:opal_app/features/auth/presentaion/pages/sign_in.dart';
import 'package:opal_app/features/auth/presentaion/pages/waiting_screen.dart';
import '../../../Tours/presentaion/widgets/custom_widgets.dart';
import '../../../Tours/presentaion/widgets/password_field.dart';
import '../../../Tours/presentaion/widgets/text_field.dart';


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  bool _showPassword = false;
  bool _showConfirmPassword = false;

  String? selectedUniversity;
  String? selectedCollege;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController otherUniversityController = TextEditingController();
  final TextEditingController otherCollegeController = TextEditingController();

  final List<String> universities = [
    'جامعة الدلتا للعلوم والتكنولوجيا',
    'جامعة المنصورة الأهلية',
    'جامعة المنصورة الجديدة',
    'غير ذلك',
  ];

  final List<String> colleges = [
    'كلية الذكاء الاصطناعي',
    'كلية الهندسة',
    'كلية الطب',
    'غير ذلك',
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: size.height * 0.02),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFE71A45),
                  ),
                  child: Image.asset(
                    'assets/logo.png',
                    width: size.width * 0.22,
                  ),
                ),
                const SizedBox(height: 20),
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
                  keyboardType: TextInputType.phone,
                ),
                // كلمة السر
                CustomPasswordField(
                  hint: 'كلمة السر',
                  controller: passwordController,
                  visible: _showPassword,
                  toggleVisibility: () {
                    setState(() => _showPassword = !_showPassword);
                  },
                  validatorMessage: 'يرجى إدخال كلمة السر',
                ),
                // تأكيد كلمة السر
                CustomPasswordField(
                  hint: 'تأكيد كلمة السر',
                  controller: confirmPasswordController,
                  visible: _showConfirmPassword,
                  toggleVisibility: () {
                    setState(() => _showConfirmPassword = !_showConfirmPassword);
                  },
                  validatorMessage: 'يرجى تأكيد كلمة السر',
                  matchController: passwordController,
                ),

                // الجامعة
                CustomDropdown(
                  label: 'الجامعة',
                  value: selectedUniversity,
                  items: universities,
                  onChanged: (value) {
                    setState(() => selectedUniversity = value);
                  },
                ),

                if (selectedUniversity == 'غير ذلك')
                  CustomTextField(
                    hint: 'اكتب اسم الجامعة',
                    controller: otherUniversityController,
                    validatorMessage: 'يرجى إدخال اسم الجامعة',
                  ),

                // الكلية
                CustomDropdown(
                  label: 'الكلية',
                  value: selectedCollege,
                  items: colleges,
                  onChanged: (value) {
                    setState(() => selectedCollege = value);
                  },
                ),

                if (selectedCollege == 'غير ذلك')
                  CustomTextField(
                    hint: 'اكتب اسم الكلية',
                    controller: otherCollegeController,
                    validatorMessage: 'يرجى إدخال اسم الكلية',
                  ),

                const SizedBox(height: 25),

                // زر تقديم الطلب
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const WaitingScreen()),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE71A45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'تقديم الطلب',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const SignInScreen()),
                        );
                      },
                      child: const Text(
                        'سجل الدخول',
                        style: TextStyle(
                          color: Color(0xFFE71A45),
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Text('لديك حساب بالفعل؟'),
                  ],
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
