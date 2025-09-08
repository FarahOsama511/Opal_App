import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:opal_app/features/Admin/presentaion/widgets/text_field.dart';
import '../../../../core/resources/color_manager.dart';
import '../../../../core/resources/text_styles.dart';
import '../widgets/custom_widgets.dart';

class EditPage extends StatefulWidget {
  final String title;
  final String buttonText;
  final Function(Map<String, String>)? onSave;
  final Map<String, String>? initialValues;
  final List<Widget>? extraFields;

  const EditPage({
    super.key,
    required this.title,
    required this.buttonText,
    this.onSave,
    this.initialValues,
    this.extraFields,
  });

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController notesController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(
      text: widget.initialValues?['name'] ?? "",
    );
    notesController = TextEditingController(
      text: widget.initialValues?['notes'] ?? "",
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.secondColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 60.h),
                  LogoCircle(),
                  SizedBox(height: 40.h),

                  Text(
                    widget.title,
                    style: TextStyles.white12Bold.copyWith(fontSize: 20.sp),
                  ),
                  SizedBox(height: 40.h),
                  CustomTextField(
                    hint: 'الاسم',
                    controller: nameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'يرجي إدخال الاسم';
                      }
                      return null;
                    },
                  ),
                  //  CustomTextField(hint: 'ملاحظات', controller: notesController),
                  if (widget.extraFields != null) ...widget.extraFields!,

                  SizedBox(height: 40.h),

                  PrimaryButton(
                    backgroundColor: ColorManager.primaryColor,
                    text: widget.buttonText,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        widget.onSave?.call({
                          'name': nameController.text,
                          'notes': notesController.text,
                        });

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: ColorManager.greyColor,
                            content: Text(
                              'تم ${widget.buttonText} بنجاح',
                              style: TextStyles.white12Bold,
                            ),
                          ),
                        );
                        context.pop();
                      }
                    },
                  ),

                  SizedBox(height: 20.h),

                  PrimaryButton(
                    text: 'إلغاء',
                    onPressed: () => context.pop(),
                    backgroundColor: ColorManager.greyColor,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
