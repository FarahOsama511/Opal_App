import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:opal_app/features/user/Domain/entities/university_entity.dart';
import '../../../../core/resources/color_manager.dart';
import '../../../../core/resources/text_styles.dart';
import '../../Data/models/add_admin_supervisor_model.dart';
import '../../Domain/entities/line_entity.dart';
import '../bloc/create_admin_supervisors.dart/add_admin_supervisor_cubit.dart';
import '../bloc/create_admin_supervisors.dart/add_admin_supervisor_state.dart';
import '../bloc/get_lines/get_all_lines_cubit.dart';
import '../bloc/get_lines/get_all_lines_state.dart';
import '../widgets/Universities_Multi_Dropdown .dart';
import '../widgets/custom_widgets.dart';
import '../widgets/text_field.dart';
import 'admin_home_screen.dart';

class AddSupervisor extends StatefulWidget {
  const AddSupervisor({super.key});

  @override
  State<AddSupervisor> createState() => _AddSupervisorState();
}

class _AddSupervisorState extends State<AddSupervisor> {
  LineEntity? selectedLine;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final List<String> AllLines = [];
  List<UniversityEntity> selectedUniversities = [];
  List<String> universitiesIds = [];

  String? validation(String? value) {
    if (value == null || value.isEmpty) {
      return 'هذا الحقل مطلوب';
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<LinesCubit>(context).getAllLiness();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 50.h),
                LogoCircle(),
                SizedBox(height: 37.h),

                CustomTextField(
                  hint: 'الإسم',
                  controller: nameController,
                  validator: validation,
                ),
                CustomTextField(
                  hint: 'البريد الإكتروني',
                  controller: emailController,
                  validator: validation,
                ),
                CustomTextField(
                  hint: 'رقم الهاتف',
                  controller: phoneController,
                  validator: validation,
                ),
                CustomTextField(
                  hint: 'كلمة السر',
                  controller: passwordController,
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
                      return CustomDropdown<LineEntity>(
                        label: 'اختر الخط',
                        value: selectedLine,
                        items: allLines,
                        onChanged: (line) {
                          setState(() {
                            selectedLine = line;
                          });
                        },
                        displayString: (line) =>
                            ' ${line.name ?? ''}', // هنا بيعرض الاسم
                      );
                    } else {
                      return const Text('فشل في تحميل الخطوط');
                    }
                  },
                ),

                SizedBox(height: 10.h),
                UniversitiesMultiDropdown(
                  onSelectionChanged: (selected) {
                    setState(() {
                      selectedUniversities = selected;
                      universitiesIds = selected
                          .map((u) => u.id ?? '')
                          .toList();
                    });
                  },
                ),
                SizedBox(height: 10.h),

                BlocConsumer<AddAdminSupervisorCubit, AddAdminSupervisorState>(
                  listener: (context, state) {
                    if (state is AddAdminSupervisorError) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(state.message)));
                    } else if (state is AddAdminSupervisorSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            state.message,
                            style: TextStyles.white12Bold,
                          ),
                        ),
                      );
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AdminHomeScreen(),
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is AddAdminSupervisorLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return PrimaryButton(
                      backgroundColor: ColorManager.primaryColor,
                      text: 'إضافة مشرف',
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          context
                              .read<AddAdminSupervisorCubit>()
                              .AddAdminORSupervisor(
                                AddAdminSupervisorModel(
                                  name: nameController.text,
                                  phone: phoneController.text,
                                  password: passwordController.text,
                                  email: emailController.text,
                                  role: "supervisor",
                                  lineId: selectedLine!.id,
                                  line: selectedLine,
                                  universitiesId: universitiesIds,
                                ),
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
                    Navigator.pop(context);
                  },
                  backgroundColor: ColorManager.greyColor,
                ),
                SizedBox(height: 15.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({required String hint, IconData? icon}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: TextField(
        textAlign: TextAlign.right,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(fontSize: 14.sp),
          prefixIcon: icon != null ? Icon(icon, color: Colors.grey) : null,
          filled: true,
          fillColor: Colors.grey.shade200,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 18.h,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
