import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/resources/color_manager.dart';
import '../../Data/models/add_admin_supervisor_model.dart';
import '../bloc/create_admin_supervisors/add_admin_supervisor_cubit.dart';
import '../bloc/create_admin_supervisors/add_admin_supervisor_state.dart';
import '../widgets/custom_widgets.dart';
import '../widgets/text_field.dart';

class AddAdmin extends StatefulWidget {
  const AddAdmin({super.key});

  @override
  State<AddAdmin> createState() => _AddAdminState();
}

class _AddAdminState extends State<AddAdmin> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? valdiatorMessage(String? value) {
    if (value == null || value.isEmpty) {
      return 'هذا الحقل مطلوب';
    }
    return null;
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
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
                SizedBox(height: 20.h),

                CustomTextField(
                  hint: 'الإسم',
                  controller: nameController,
                  validator: valdiatorMessage,
                ),
                CustomTextField(
                  hint: 'البريد الإكتروني',
                  controller: emailController,
                  validator: valdiatorMessage,
                ),
                CustomTextField(
                  hint: 'رقم الهاتف',
                  controller: phoneController,
                  validator: valdiatorMessage,
                ),
                CustomTextField(
                  hint: 'كلمة السر',
                  controller: passwordController,
                  validator: valdiatorMessage,
                ),

                SizedBox(height: 10.h),
                BlocConsumer<AddAdminSupervisorCubit, AddAdminSupervisorState>(
                  listener: (context, state) {
                    if (state is AddAdminSupervisorError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.message),
                          backgroundColor: ColorManager.greyColor,
                        ),
                      );
                    } else if (state is AddAdminSupervisorSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('تمت الإضافة بنجاح'),
                          backgroundColor: ColorManager.greyColor,
                        ),
                      );
                      context.go('/adminScreen');
                    }
                  },
                  builder: (context, state) {
                    if (state is AddAdminSupervisorLoading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: ColorManager.primaryColor,
                        ),
                      );
                    }
                    return PrimaryButton(
                      backgroundColor: ColorManager.primaryColor,
                      text: 'اضافة مسؤول',
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
                                  role: "admin",
                                ),
                                context,
                              );
                        }
                      },
                    );
                  },
                ),
                SizedBox(height: 20.h),
                PrimaryButton(
                  text: 'إلغاء ',
                  onPressed: () {
                    context.pop();
                  },
                  backgroundColor: ColorManager.greyColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
