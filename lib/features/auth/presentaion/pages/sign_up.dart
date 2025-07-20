import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opal_app/features/Tours/Domain/entities/tour.dart';
import 'package:opal_app/features/auth/Data/models/register_model.dart';
import 'package:opal_app/features/auth/presentaion/bloc/auth_state.dart';
import 'package:opal_app/features/auth/presentaion/pages/sign_in.dart';
import '../../Domain/entities/user_entity.dart';
import '../bloc/auth_cubit.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _showPassword = false;
  bool _showConfirmPassword = false;

  String? selectedUniversity;
  String? selectedCollege;

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
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController universityCardIdController =
      TextEditingController();
  final TextEditingController universityIdController = TextEditingController();
  final TextEditingController lineIdController = TextEditingController();
  final TextEditingController otherUniversityController =
      TextEditingController();
  final TextEditingController otherCollegeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is AuthFailure) {
                print("Error: ${state.error}");
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.error)));
              } else if (state is AuthSuccess) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const SignInScreen()),
                );
              }
            },
            builder: (context, state) {
              if (state is AuthLoading) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return Column(
                  children: [
                    SizedBox(height: size.height * 0.02),

                    // اللوجو داخل دائرة
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
                    _buildTextField(hint: 'الاسم', controller: nameController),
                    // رقم الهاتف
                    _buildTextField(
                      hint: 'رقم الهاتف',
                      controller: phoneController,
                    ),
                    _buildPasswordField(
                      hint: 'كلمة السر',
                      controller: universityCardIdController,
                      visible: _showPassword,
                      toggleVisibility: () {
                        setState(() => _showPassword = !_showPassword);
                      },
                    ),
                    // // تأكيد كلمة السر
                    // _buildPasswordField(
                    //   controller: universityCardIdController,
                    //   hint: 'تأكيد كلمة السر',
                    //   visible: _showConfirmPassword,
                    //   toggleVisibility: () {
                    //     setState(() => _showConfirmPassword = !_showConfirmPassword);
                    //   },
                    // ),

                    // الجامعة
                    _buildDropdown(
                      label: 'الجامعة',
                      value: selectedUniversity,
                      items: universities,
                      onChanged: (value) {
                        setState(() => selectedUniversity = value);
                      },
                    ),

                    if (selectedUniversity == 'غير ذلك')
                      _buildTextField(
                        hint: 'اكتب اسم الجامعة',
                        controller: otherUniversityController,
                      ),

                    // الكلية
                    _buildDropdown(
                      label: 'الكلية',
                      value: selectedCollege,
                      items: colleges,
                      onChanged: (value) {
                        setState(() => selectedCollege = value);
                      },
                    ),

                    if (selectedCollege == 'غير ذلك')
                      _buildTextField(
                        hint: 'اكتب اسم الكلية',
                        controller: otherCollegeController,
                      ),

                    const SizedBox(height: 25),

                    // زر تقديم الطلب
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<AuthCubit>().register(
                            RegisterModel(
                              user: UserEntity(
                                name: nameController.text,
                                phone: phoneController.text,
                                universityCardId:
                                    universityCardIdController.text,
                                universityId: "manu",
                                line: LineEntity(
                                  id: "cmd1np26i0000uwjo1i800xn1",
                                ),
                              ),
                            ),
                          );
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

                    // سجل الدخول
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignInScreen(),
                              ),
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
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String hint,
    IconData? icon,
    TextEditingController? controller,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: controller,
        textAlign: TextAlign.right,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(fontSize: 14),
          suffixIcon: icon != null ? Icon(icon, color: Colors.grey) : null,
          filled: true,
          fillColor: Colors.grey.shade200,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 18,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hint,
    required bool visible,
    required VoidCallback toggleVisibility,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: controller,
        obscureText: !visible,
        textAlign: TextAlign.right,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(fontSize: 14),
          suffixIcon: IconButton(
            icon: Icon(visible ? Icons.visibility : Icons.visibility_off),
            onPressed: toggleVisibility,
          ),
          filled: true,
          fillColor: Colors.grey.shade200,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 18,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            isExpanded: true,
            value: value,
            hint: Text(label),
            items: items
                .map(
                  (item) =>
                      DropdownMenuItem<String>(value: item, child: Text(item)),
                )
                .toList(),
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }
}
