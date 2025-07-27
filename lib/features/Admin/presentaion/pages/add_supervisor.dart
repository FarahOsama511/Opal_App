import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opal_app/features/Admin/Domain/entities/tour.dart';
import '../../Data/models/add_admin_supervisor_model.dart';
import '../bloc/create_admin_supervisors.dart/add_admin_supervisor_cubit.dart';
import '../bloc/create_admin_supervisors.dart/add_admin_supervisor_state.dart';
import '../bloc/get_lines/get_all_lines_cubit.dart';
import '../bloc/get_lines/get_all_lines_state.dart';
import '../widgets/bus_line_dropdown.dart';
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
  @override
  void initState() {
    super.initState();
    BlocProvider.of<LinesCubit>(context).getAllLiness();
  }

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
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: size.height * 0.05),
                LogoCircle(size: size),
                const SizedBox(height: 37),

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

                BlocBuilder<LinesCubit, GetAllLinesState>(
                  builder: (context, state) {
                    if (state is LinesLoading) {
                      return const CircularProgressIndicator(
                        color: Color(0XFFE71A45),
                      );
                    } else if (state is LinesLoaded) {
                      final allLines = state.Liness; // دي كافية

                      return CustomDropdown(
                        label: 'اختر الخط',
                        items: allLines,
                        value: selectedLine,
                        onChanged: (line) {
                          setState(() {
                            selectedLine = line;
                          });
                        },
                      );
                    } else {
                      return const Text('فشل في تحميل الخطوط');
                    }
                  },
                ),

                const SizedBox(height: 10),

                BlocConsumer<AddAdminSupervisorCubit, AddAdminSupervisorState>(
                  listener: (context, state) {
                    if (state is AddAdminSupervisorError) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(state.message)));
                    } else if (state is AddAdminSupervisorSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('تمت الإضافة بنجاح')),
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
                    print('state is ${state}');
                    if (state is AddAdminSupervisorLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return PrimaryButton(
                      text: 'إضافة مشرف',
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          context
                              .read<AddAdminSupervisorCubit>()
                              .AddAdminORSupervisor(
                                AddAdminSupervisorModel(
                                  name: nameController.text, // ✅ صح
                                  phone: phoneController.text,
                                  password: passwordController.text,
                                  email: emailController.text,
                                  role: "supervisor",
                                ),
                              );
                        }
                      },
                    );
                  },
                ),

                const SizedBox(height: 15),
              ],
            ),
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
}
