import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opal_app/core/theming/color_manager.dart';
import 'package:opal_app/features/Admin/presentaion/pages/trips.dart';
import 'package:opal_app/features/user/Domain/entities/user_entity.dart';
import 'package:opal_app/features/user/presentaion/bloc/user_cubit.dart';
import 'package:opal_app/features/user/presentaion/bloc/user_state.dart';

class StudentList extends StatefulWidget {
  const StudentList({super.key});

  @override
  State<StudentList> createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {
  bool showAddMenu = false;
  int currentIndex = 0;
  bool isStudentsSelected = true;
  bool isSupervisorSelected = true;

  List<bool> _isExpandedList = List.generate(1, (index) => false);

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
                  isStudentsSelected = true;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isStudentsSelected
                    ? ColorManager.primaryColor
                    : ColorManager.greyColor,
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
                    : const Color(0xFFE71A45),
              ),
              child: Text(
                'المشرفين',
                style: TextStyle(
                  color: isStudentsSelected ? Colors.black : Colors.white,
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
            print("ERROR:${state.message}");
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is UserSuccess) {
            final activatedUsers = state.user
                .where((u) => u.isActivated == true)
                .toList();
            // تأكد إن القائمة ممتلئة
            if (_isExpandedList.length != activatedUsers.length) {
              _isExpandedList = List.generate(
                activatedUsers.length,
                (_) => false,
              );
            }

            if (activatedUsers.isEmpty) {
              return Center(child: Text("لا يوجد مستخدمون."));
            }

            return ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 90),
              itemCount: activatedUsers.length,
              itemBuilder: (context, index) {
                final user = activatedUsers[index];
                return _buildCard(index, user);
              },
            );
          } else if (state is UserLoading) {
            return Center(child: CircularProgressIndicator());
          } else {
            return Text("ERROR");
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
                  isStudentsSelected ? user.name! : ' محمد احمد ',
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
                  Text('رقم الهاتف:  ${user.phone}'),
                  Text(
                    'الجامعة: ${isStudentsSelected ? user.university!.name : ""}',
                  ),
                  Text(
                    'الكلية: ${isStudentsSelected ? user.university!.name : ""}',
                  ),
                  Text(isSupervisorSelected ? 'الخط:      خط 1  ' : ''),
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
                label: 'القائمة',
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
