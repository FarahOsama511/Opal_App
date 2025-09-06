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
import '../bloc/create_admin_supervisors/add_admin_supervisor_cubit.dart';
import '../bloc/create_admin_supervisors/add_admin_supervisor_state.dart';
import '../bloc/delete_user/delete_user_state.dart';
import '../widgets/expandable_card.dart';
import '../widgets/search_field.dart';

class StudentList extends StatefulWidget {
  const StudentList({super.key});

  @override
  State<StudentList> createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {
  bool isStudentsSelected = true;
  List<bool> _isExpandedStudents = [];
  List<bool> _isExpandedSupervisors = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GetAllUserCubit>().fetchAllUsers();
    });
  }

  void _handleDeleteUser(String userId) {
    context.read<DeleteUserCubit>().deleteUser(userId);
    context.pop();
  }

  void _showDeleteDialog(UserEntity user) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("تأكيد الحذف"),
        content: Text("هل أنت متأكد من حذف ${user.name}?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("إلغاء"),
          ),
          TextButton(
            onPressed: () => _handleDeleteUser(user.id!),
            child: const Text("حذف"),
          ),
        ],
      ),
    );
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
              context.read<GetAllUserCubit>().fetchAllUsers();
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.deleteUser)));
            }
          },
        ),
        BlocListener<AddAdminSupervisorCubit, AddAdminSupervisorState>(
          listener: (context, state) {
            if (state is AddAdminSupervisorSuccess) {
              context.read<GetAllUserCubit>().fetchAllUsers();
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
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
                    });
                  },
                ),
              ),
              _buildSwitchButtons(),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(color: Color(0xFFE71A45)),
                  child: BlocBuilder<GetAllUserCubit, UserState>(
                    builder: (context, state) {
                      if (state is UserLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is UserError) {
                        return Center(child: Text(state.message));
                      } else if (state is UserSuccess) {
                        final activeUsers = state.user
                            .where((u) => u.status == 'active')
                            .toList();

                        final filteredUsers = activeUsers.where((user) {
                          final matchesRole = isStudentsSelected
                              ? user.role == "student"
                              : user.role == "supervisor";

                          final matchesSearch =
                              _searchQuery.isEmpty ||
                              user.name!.toLowerCase().contains(
                                _searchQuery.toLowerCase(),
                              ) ||
                              user.id!.contains(_searchQuery) ||
                              user.phone!.contains(_searchQuery) ||
                              (user.university?.name?.toLowerCase().contains(
                                    _searchQuery,
                                  ) ??
                                  false);

                          return matchesRole && matchesSearch;
                        }).toList();

                        final isExpandedList = isStudentsSelected
                            ? _isExpandedStudents
                            : _isExpandedSupervisors;

                        if (isExpandedList.length != filteredUsers.length) {
                          final newExpansionList = List.generate(
                            filteredUsers.length,
                            (_) => false,
                          );
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            setState(() {
                              if (isStudentsSelected) {
                                _isExpandedStudents = newExpansionList;
                              } else {
                                _isExpandedSupervisors = newExpansionList;
                              }
                            });
                          });
                        }

                        if (filteredUsers.isEmpty) {
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
                          itemCount: filteredUsers.length,
                          itemBuilder: (context, index) {
                            final user = filteredUsers[index];
                            final isExpanded = isStudentsSelected
                                ? _isExpandedStudents[index]
                                : _isExpandedSupervisors[index];

                            return ExpandableCard(
                              name: user.name!,
                              phone: user.phone!,
                              universityId: user.universityId,
                              line: user.line?.name ?? '',
                              isSupervisor: user.role == "supervisor",
                              isExpanded: isExpanded,
                              onToggle: () {
                                setState(() {
                                  if (isStudentsSelected) {
                                    _isExpandedStudents[index] =
                                        !_isExpandedStudents[index];
                                  } else {
                                    _isExpandedSupervisors[index] =
                                        !_isExpandedSupervisors[index];
                                  }
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
                          },
                        );
                      }

                      return const SizedBox();
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

  Widget _buildSwitchButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ChoiceChip(
          label: const Text("طلاب"),
          selected: isStudentsSelected,
          onSelected: (selected) {
            setState(() {
              isStudentsSelected = true;
            });
          },
        ),
        const SizedBox(width: 10),
        ChoiceChip(
          label: const Text("مشرفين"),
          selected: !isStudentsSelected,
          onSelected: (selected) {
            setState(() {
              isStudentsSelected = false;
            });
          },
        ),
      ],
    );
  }
}
