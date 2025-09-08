import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:opal_app/features/Admin/presentaion/bloc/delete_user/delete_user_cubit.dart';
import 'package:opal_app/features/Admin/presentaion/widgets/delete_dialog.dart';
import '../../../../core/resources/color_manager.dart';
import '../../../../core/resources/text_styles.dart';
import '../../../user/Domain/entities/user_entity.dart';
import '../../../user/presentaion/bloc/user_cubit.dart' show GetAllUserCubit;
import '../../../user/presentaion/bloc/user_state.dart';
import '../bloc/delete_user/delete_user_state.dart';
import '../widgets/expandable_card.dart';
import '../widgets/search_field.dart';
import '../widgets/switch_button.dart';

class StudentList extends StatefulWidget {
  const StudentList({super.key});
  @override
  State<StudentList> createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {
  bool isStudentsSelected = true;
  List<bool> _isExpandedStudents = [];
  List<bool> _isExpandedSupervisors = [];
  List<UserEntity> _users = [];
  List<UserEntity> _filteredUsers = [];
  String _searchQuery = '';

  void _updateFilteredUsers() {
    _filteredUsers = _users.where((user) {
      return isStudentsSelected
          ? user.role == "student"
          : user.role == "supervisor";
    }).toList();

    if (_searchQuery.isNotEmpty) {
      _filteredUsers = _users.where((user) {
        return user.name!.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            user.id!.contains(_searchQuery) ||
            user.phone!.contains(_searchQuery) ||
            (user.university?.name?.toLowerCase().contains(_searchQuery) ??
                false);
      }).toList();
    }
    if (isStudentsSelected) {
      if (_isExpandedStudents.length != _filteredUsers.length) {
        _isExpandedStudents = List.generate(
          _filteredUsers.length,
              (_) => false,
        );
      }
    } else {
      if (_isExpandedSupervisors.length != _filteredUsers.length) {
        _isExpandedSupervisors = List.generate(
          _filteredUsers.length,
              (_) => false,
        );
      }
    }
  }
  void _handleDeleteUser(String userId) {
    BlocProvider.of<DeleteUserCubit>(context).deleteUser(userId);
  }
  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<DeleteUserCubit, DeleteUserState>(
          listener: (context, state) {
            if (state is DeleteUserError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            } else if (state is DeleteUserLoaded) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.deleteUser)));

              setState(() {
                _users.removeWhere(
                      (u) => u.id == state.userId,
                );
                _updateFilteredUsers();
              });

              context.pop();
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: ColorManager.secondColor,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 0.h),
                child: SearchField(
                  hintText: 'ابحث عن مستخدم',
                  fillColor: Colors.white,
                  iconColor: Colors.red,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                      _updateFilteredUsers();
                    });
                  },
                ),
              ),
        CustomSwitchButtons(
          labels: ['الطلاب', 'المشرفين'],
          selectedIndex: isStudentsSelected ? 0 : 1,
          onTap: (index) {
            setState(() {
              isStudentsSelected = index == 0;
              _updateFilteredUsers();
            });
          },)
           , Expanded(
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
                      if (state is UserSuccess) {
                        setState(() {
                          _users = state.user
                              .where((u) => u.status == 'active')
                              .toList();

                          _updateFilteredUsers();
                        });
                      }
                      print("Filtered after update: ${_filteredUsers.length}");
                    },
                    builder: (context, state) {
                      print("Builder triggered with state: $state");
                      if (state is UserSuccess) {
                        if (_filteredUsers.isEmpty) {
                          return Center(
                            child: Text(
                              "لا يوجد مستخدمون",
                              style: TextStyles.white20Bold.copyWith(
                                fontSize: 20.sp,
                              ),
                            ),
                          );
                        }
                        return ListView.builder(
                          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 90.h),
                          itemCount: _filteredUsers.length,
                          itemBuilder: (context, index) {
                            final user = _filteredUsers[index];
                            if (isStudentsSelected) {
                              return ExpandableCard(
                                name: user.name!,
                                phone: user.phone!,
                                university: user.university ?? null,
                                isSupervisor: false,
                                isExpanded: _isExpandedStudents[index],
                                onToggle: () {
                                  setState(() {
                                    _isExpandedStudents[index] =
                                    !_isExpandedStudents[index];
                                  });
                                },
                                deleteIcon: IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                    size: 24.sp,
                                  ),
                                  onPressed: () => _showDeleteDialog(user),
                                ),
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
                                deleteIcon: IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                    size: 24.sp,
                                  ),
                                  onPressed: () => _showDeleteDialog(user),
                                ),
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
                            style: TextStyles.white20Bold.copyWith(
                              fontSize: 20.sp,
                            ),
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
      ),
    );
  }
  void _showDeleteDialog(UserEntity user) {
    showDialog(
      context: context,
      builder: (context) =>
          DeleteDialog(
            context: context,
            title: "تأكيد الحذف",
            content: "هل تريد حذف ${user.name}؟",
            onConfirm: () => _handleDeleteUser(user.id!),
          ),
    );
  }
}