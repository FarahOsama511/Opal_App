import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/resources/color_manager.dart';
import '../../../../core/resources/text_styles.dart';
import '../../../user/presentaion/bloc/user_cubit.dart' show GetAllUserCubit;
import '../../../user/presentaion/bloc/user_state.dart';

import '../widgets/expandable_card.dart';

class StudentList extends StatefulWidget {
  const StudentList({super.key});
  @override
  State<StudentList> createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {
  bool isStudentsSelected = true;
  List<bool> _isExpandedStudents = [];
  List<bool> _isExpandedSupervisors = [];

  @override
  void initState() {
    super.initState();
    BlocProvider.of<GetAllUserCubit>(context).fetchAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildSwitchButtons(),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(color: Color(0xFFE71A45)),
                child: BlocConsumer<GetAllUserCubit, UserState>(
                  listener: (context, state) {
                    if (state is UserError) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(state.message)));
                    }
                  },
                  builder: (context, state) {
                    if (state is UserSuccess) {
                      final filteredUsers = state.user.where((u) {
                        return (u.status == 'active' && isStudentsSelected
                            ? u.role == "student"
                            : u.role == "supervisor");
                      }).toList();

                      print(
                        "عدد المستخدمين المستلمين من السيرفر: ${state.user.length}",
                      );

                      if (isStudentsSelected) {
                        if (_isExpandedStudents.length !=
                            filteredUsers.length) {
                          _isExpandedStudents = List.generate(
                            filteredUsers.length,
                            (_) => false,
                          );
                        }
                      } else {
                        if (_isExpandedSupervisors.length !=
                            filteredUsers.length) {
                          _isExpandedSupervisors = List.generate(
                            filteredUsers.length,
                            (_) => false,
                          );
                        }
                      }

                      if (filteredUsers.isEmpty) {
                        return Center(
                          child: Text(
                            "لا يوجد مستخدمون",
                            style: TextStyles.white20Bold,
                          ),
                        );
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 90),
                        itemCount: filteredUsers.length,
                        itemBuilder: (context, index) {
                          final user = filteredUsers[index];
                          print(user);
                          if (isStudentsSelected) {
                            return ExpandableCard(
                              name: user.name!,
                              phone: user.phone!,
                              university: user.university?.name ?? '',
                              isSupervisor: false,
                              isExpanded: _isExpandedStudents[index],
                              onToggle: () {
                                setState(() {
                                  _isExpandedStudents[index] =
                                      !_isExpandedStudents[index];
                                });
                              },
                            );
                          } else {
                            return ExpandableCard(
                              name: user.name!,
                              phone: user.phone!,
                              line: user.line?.name ?? '',
                              isSupervisor: true,
                              isExpanded: _isExpandedSupervisors[index],
                              onToggle: () {
                                setState(() {
                                  _isExpandedSupervisors[index] =
                                      !_isExpandedSupervisors[index];
                                });
                              },
                            );
                          }
                        },
                      );
                    } else if (state is UserLoading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: ColorManager.secondColor,
                        ),
                      );
                    } else {
                      return Center(
                        child: Text(
                          "حدث خطأ أثناء تحميل البيانات.",
                          style: TextStyles.white20Bold,
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  isStudentsSelected = true;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isStudentsSelected
                    ? const Color(0xFFE71A45)
                    : Colors.grey.shade300,
              ),
              child: Text(
                'الطلاب',
                style: TextStyle(
                  color: isStudentsSelected ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  isStudentsSelected = false;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isStudentsSelected
                    ? Colors.grey.shade300
                    : ColorManager.primaryColor,
              ),
              child: Text(
                'المشرفين',
                style: TextStyle(
                  color: isStudentsSelected
                      ? ColorManager.blackColor
                      : ColorManager.secondColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
