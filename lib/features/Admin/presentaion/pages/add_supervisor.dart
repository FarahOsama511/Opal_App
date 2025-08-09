import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:opal_app/features/Admin/Domain/entities/tour.dart';
import '../../../../core/resources/color_manager.dart';
import '../../../../core/resources/text_styles.dart';
import '../../Data/models/add_admin_supervisor_model.dart';
import '../bloc/create_admin_supervisors.dart/add_admin_supervisor_cubit.dart';
import '../bloc/create_admin_supervisors.dart/add_admin_supervisor_state.dart';
import '../bloc/get_lines/get_all_lines_cubit.dart';
import '../bloc/get_lines/get_all_lines_state.dart';
import '../widgets/custom_widgets.dart';
import '../widgets/text_field.dart';
import 'admin_home_screen.dart';

class AddSupervisor extends StatefulWidget {
  const AddSupervisor({super.key});

  @override
  State<AddSupervisor> createState() => _AddSupervisorState();
}

class _AddSupervisorState extends State<AddSupervisor> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  LineEntity? selectedLine;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<LinesCubit>(context).getAllLiness();
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.secondColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 50.h),
                const LogoCircle(),
                SizedBox(height: 37.h),

                CustomTextField(
                  hint: 'الإسم',
                  controller: nameController,
                  validatorMessage: 'يرجي إدخال الإسم',
                ),
                CustomTextField(
                  hint: 'البريد الإكتروني',
                  controller: emailController,
                  validatorMessage: 'يرجي إدخال البريد الإلكتروني',
                ),
                CustomTextField(
                  hint: 'رقم الهاتف',
                  controller: phoneController,
                  validatorMessage: 'يرجي إدخال رقم الهاتف',
                ),
                CustomTextField(
                  hint: 'كلمة السر',
                  controller: passwordController,
                  validatorMessage: 'يرجى إدخال كلمة السر',
                ),

                SizedBox(height: 20.h),

                BlocBuilder<LinesCubit, GetAllLinesState>(
                  builder: (context, state) {
                    if (state is LinesLoading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: ColorManager.primaryColor,
                        ),
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
                        displayString: (line) => line.name ?? '',
                      );
                    } else {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        child: const Text(
                          'فشل في تحميل الخطوط',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.red),
                        ),
                      );
                    }
                  },
                ),

                SizedBox(height: 20.h),

                BlocConsumer<AddAdminSupervisorCubit, AddAdminSupervisorState>(
                  listener: (context, state) {
                    if (state is AddAdminSupervisorError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.message)),
                      );
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
                          if (selectedLine == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('يرجى اختيار خط'),
                              ),
                            );
                            return;
                          }

                          context.read<AddAdminSupervisorCubit>().AddAdminORSupervisor(
                            AddAdminSupervisorModel(
                              name: nameController.text,
                              phone: phoneController.text,
                              password: passwordController.text,
                              email: emailController.text,
                              role: "supervisor",
                              lineId: selectedLine!.id,
                            ),
                          );
                        }
                      },
                    );
                  },
                ),

                SizedBox(height: 20.h),

                PrimaryButton(
                  text: 'إلغاء',
                  onPressed: () => Navigator.pop(context),
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
}
