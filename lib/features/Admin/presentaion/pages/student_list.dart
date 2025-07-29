import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opal_app/core/resources/color_manager.dart';
import 'package:opal_app/features/Admin/presentaion/pages/trips.dart';
import 'package:opal_app/features/user/Domain/entities/user_entity.dart';
import 'package:opal_app/features/user/presentaion/bloc/user_cubit.dart';
import 'package:opal_app/features/user/presentaion/bloc/user_state.dart';

import '../../../../core/resources/text_styles.dart';

class StudentList extends StatefulWidget {
  const StudentList({super.key});

  @override
  State<StudentList> createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {
  bool showAddMenu = false;
  int currentIndex = 0;
  bool isStudentsSelected = true;

  List<bool> _isExpandedList = [];

  @override
  void initState() {
    super.initState();
    BlocProvider.of<GetAllUserCubit>(context).fetchAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            children: [
              _buildSwitchButtons(),
              Expanded(
                child: Stack(
                  children: [
                    IndexedStack(
                      index: currentIndex,
                      children: [
                        _buildHomeContent(),
                        const TripsScreen(),
                        Center(
                          child: Text(
                            isStudentsSelected
                                ? 'قائمة الطلاب'
                                : 'قائمة المشرفين',
                          ),
                        ),
                      ],
                    ),
                    _buildBottomNav(),
                  ],
                ),
              ),
            ],
          ),
          if (showAddMenu) _buildAddMenu(),
        ],
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
                  isStudentsSelected = false;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: !isStudentsSelected
                    ? ColorManager.primaryColor
                    : ColorManager.greyColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                'المشرفين',
                style: TextStyle(
                  color: !isStudentsSelected
                      ? ColorManager.secondColor
                      : ColorManager.blackColor,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  isStudentsSelected = true;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isStudentsSelected
                    ? ColorManager.primaryColor
                    : ColorManager.greyColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                'الطلاب',
                style: TextStyle(
                  color: isStudentsSelected
                      ? ColorManager.secondColor
                      : ColorManager.blackColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHomeContent() {
    return Container(
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
            print("عدد المستخدمين المستلمين من السيرفر: ${state.user.length}");

            if (_isExpandedList.length != filteredUsers.length) {
              _isExpandedList = List.generate(
                filteredUsers.length,
                (_) => false,
              );
            }

            if (filteredUsers.isEmpty) {
              return Center(
                child: Text("لا يوجد مستخدمون", style: TextStyles.white20Bold),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 90),
              itemCount: filteredUsers.length,
              itemBuilder: (context, index) {
                final user = filteredUsers[index];
                return _buildCard(index, user);
              },
            );
          } else if (state is UserLoading) {
            return const Center(
              child: CircularProgressIndicator(color: ColorManager.secondColor),
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
    );
  }

  Widget _buildCard(int index, UserEntity user) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 3, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  user.name ?? '',
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  _isExpandedList[index]
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down_rounded,
                  color: Colors.black,
                ),
                onPressed: () {
                  setState(() {
                    _isExpandedList[index] = !_isExpandedList[index];
                  });
                },
              ),
            ],
          ),
          if (_isExpandedList[index])
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('رقم الهاتف: ${user.phone ?? ""}'),
                  Text('الخط:  ${user.line?.name ?? ""}'),
                  if (isStudentsSelected) ...[
                    Text('الجامعة: ${user.university?.name ?? ""}'),
                  ] else ...[
                    // Text('الرقم التعريفي: ${user.universityCardId ?? ""}'),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Positioned(
      left: 16,
      right: 16,
      bottom: 16,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFE71A45),
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BottomNavigationBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            currentIndex: currentIndex,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white70,
            onTap: (index) {
              setState(() => currentIndex = index);
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'الرئيسية',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.alt_route),
                label: 'الرحلات',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.list_outlined),
                label: 'قائمة الطلاب',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddMenu() {
    return Positioned(
      top: 80,
      right: 16,
      left: 16,
      child: Material(
        elevation: 6,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildAddOption('إضافة مسؤول جديد'),
              _buildAddOption('إضافة مشرف جديد'),
              _buildAddOption('إضافة ميعاد جديد'),
              _buildAddOption('إضافة خط جديد'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddOption(String title) {
    return TextButton(
      onPressed: () {},
      style: TextButton.styleFrom(
        foregroundColor: const Color(0xFFE71A45),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
      child: Text(
        title,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      ),
    );
  }
}
