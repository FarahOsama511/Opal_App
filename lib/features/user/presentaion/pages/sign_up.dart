import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:opal_app/core/resources/color_manager.dart';
import 'package:opal_app/features/Admin/Domain/entities/tour.dart';
import 'package:opal_app/features/user/Domain/entities/user_entity.dart';
import 'package:opal_app/features/user/presentaion/bloc/auth_cubit.dart';
import 'package:opal_app/features/user/presentaion/bloc/auth_state.dart';
import 'package:opal_app/features/user/presentaion/bloc/get_all_universities/get_all_universities_cubit.dart';
import 'package:opal_app/features/user/presentaion/bloc/get_all_universities/get_all_universities_state.dart';
import 'package:opal_app/features/user/presentaion/pages/sign_in.dart';
import 'package:opal_app/features/user/presentaion/pages/waiting_screen.dart';
import '../../../../core/resources/text_styles.dart';
import '../../../Admin/presentaion/widgets/custom_widgets.dart';
import '../../../Admin/presentaion/widgets/text_field.dart';
import '../../Domain/entities/authentity.dart';
import '../../Domain/entities/university_entity.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  // bool _showPassword = false;
  UniversityEntity? selectedUniversity;
  String? selectedCollege;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController universityCardId = TextEditingController();
  final TextEditingController otherUniversityController =
      TextEditingController();
  final TextEditingController otherCollegeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<GetAllUniversitiesCubit>(context).fetchAlluniversities();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.h),
          child: BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is AuthSuccess) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WaitingScreen(),
                  ),
                );
              } else if (state is AuthFailure) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.error)));
              }
            },
            builder: (context, state) {
              if (state is AuthLoading) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(height: size.height * 0.05),
                      LogoCircle(size: size),
                      SizedBox(height: 37.h),
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
                        //  keyboardType: TextInputType.phone,
                      ),
                      // كلمة السر
                      CustomTextField(
                        hint: ' الرقم الجامعي',
                        controller: universityCardId,

                        validatorMessage: 'يرجى إدخال الرقم الجامعي',
                      ),

                      // الجامعة
                      BlocBuilder<
                        GetAllUniversitiesCubit,
                        GetAllUniversitiesState
                      >(
                        builder: (context, state) {
                          print("state is${state}");
                          if (state is GetAllUniversitiesLoading) {
                            return const CircularProgressIndicator(
                              color: ColorManager.primaryColor,
                            );
                          } else if (state is GetAllUniversitiesSuccess) {
                            final allUniversities = state.GetAllUniversities;
                            print("${state.GetAllUniversities.length}");
                            return CustomDropdown(
                              label: 'الجامعة',
                              value: selectedUniversity,
                              items: allUniversities,
                              onChanged: (value) {
                                setState(() => selectedUniversity = value);
                              },
                              displayString: (u) => u.name!,
                            );
                          } else {
                            return Text(
                              'فشل في تحميل الجامعات',
                              style: TextStyles.black14Bold,
                            );
                          }
                        },
                      ),

                      if (selectedUniversity == 'غير ذلك')
                        CustomTextField(
                          hint: 'اكتب اسم الجامعة',
                          controller: otherUniversityController,
                          validatorMessage: 'يرجى إدخال اسم الجامعة',
                        ),

                      SizedBox(height: 25.h),

                      SizedBox(
                        width: double.infinity,
                        height: 38.h,
                        child: PrimaryButton(
                          backgroundColor: ColorManager.primaryColor,
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              context.read<AuthCubit>().register(
                                RegisterEntity(
                                  user: UserEntity(
                                    university: UniversityEntity(
                                      name: selectedUniversity!.name,
                                    ),
                                    name: nameController.text,
                                    phone: phoneController.text,
                                    universityCardId: universityCardId.text,
                                    universityId: selectedUniversity!.id,
                                    line: LineEntity(
                                      id: "cmd1np26i0000uwjo1i800xn1",
                                    ),

                                    role: 'طالب', // إذا بتسجلي الطالب فقط الآن
                                  ),
                                ),
                              );
                            }
                          },

                          text: 'تقديم الطلب',
                        ),
                      ),

                      SizedBox(height: 15.h),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(width: 4.w),
                          Text(
                            'لديك حساب بالفعل؟',
                            style: TextStyles.grey14Regular,
                          ),
                          SizedBox(width: 4.w),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignInScreen(),
                                ),
                              );
                            },
                            child: Text(
                              'سجل الدخول',
                              style: TextStyle(
                                color: ColorManager.primaryColor,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30.h),
                    ],
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
