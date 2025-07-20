import 'package:flutter/material.dart';
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

                // اللوجو
                LogoCircle(size: size),
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

                const SizedBox(height: 10),

                // زر الإضافة
                PrimaryButton(
                  text: 'اضافة مسؤول',
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // هنا تقدرِ تضيفي المسؤول الجديد بعد التحقق من صحة البيانات
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('تمت الإضافة بنجاح')),
                      );
                    }
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
}
