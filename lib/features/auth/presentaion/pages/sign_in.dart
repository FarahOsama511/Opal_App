import 'package:flutter/material.dart';
import 'package:opal_app/features/auth/presentaion/pages/sign_up.dart';

import '../../../Tours/presentaion/pages/home_screen.dart';
import 'home_screen.dart';


class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _showPassword = false;
  String? selectedRole;
  final List<String> roles = ['طالب', 'مشرف', 'مسؤول'];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: size.height * 0.05),

              // اللوجو
              Center(
                child: Container(
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
              ),

              const SizedBox(height: 20),

              // اختيار الدور
              DropdownButtonFormField<String>(
                value: selectedRole,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  hintText: 'اختر الدور',
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                items: roles
                    .map((role) => DropdownMenuItem<String>(
                  value: role,
                  child: Text(role, textAlign: TextAlign.right),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedRole = value;
                  });
                },
              ),

              const SizedBox(height: 10),

              // رقم الهاتف
              _buildTextField(hint: 'رقم الهاتف'),

              // كلمة السر
              _buildPasswordField(
                hint: 'كلمة السر ',
                visible: _showPassword,
                toggleVisibility: () {
                  setState(() {
                    _showPassword = !_showPassword;
                  });
                },
              ),

              // نسيت كلمة السر؟
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    'نسيت كلمة السر؟',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // زر تسجيل الدخول
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE71A45),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    if (selectedRole == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('يرجى اختيار الدور أولاً')),
                      );
                      return;
                    }

                    if (selectedRole == 'طالب') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AdminHomeScreen()), // صفحة الطالب
                      );
                    } else if (selectedRole == 'مشرف') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SupervisorScreen()), // صفحة المشرف
                      );
                    } else if (selectedRole == 'مسؤول') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AdminHomeScreen()), // صفحة المسؤول
                      );
                    }
                  }

                  ,child: const Text(
                    'تسجيل الدخول',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
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
                        MaterialPageRoute(builder: (context) => const SignUpScreen()),
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
                  Text('بتسجيلك فإنك توافق على', style: TextStyle(color: Colors.black)),
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

  Widget _buildTextField({required String hint, IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        textAlign: TextAlign.right,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(fontSize: 14),
          prefixIcon: icon != null ? Icon(icon, color: Colors.grey) : null,
          filled: true,
          fillColor: Colors.grey.shade200,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required String hint,
    required bool visible,
    required VoidCallback toggleVisibility,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        obscureText: !visible,
        textAlign: TextAlign.right,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(fontSize: 14),
          suffixIcon: IconButton(
            icon: Icon(
              visible ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey,
            ),
            onPressed: toggleVisibility,
          ),
          filled: true,
          fillColor: Colors.grey.shade200,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
