import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    // Filter by role first
    _filteredUsers = _users.where((user) {
      return isStudentsSelected
          ? user.role == "student"
          : user.role == "supervisor";
    }).toList();

    // Then apply search filter if query is not empty
    if (_searchQuery.isNotEmpty) {
      _filteredUsers = _filteredUsers.where((user) {
        return user.name!.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            user.id!.contains(_searchQuery) ||
            user.phone!.contains(_searchQuery);
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

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  void _loadUsers() {
    BlocProvider.of<GetAllUserCubit>(context).fetchAllUsers();
  }

  void _handleDeleteUser(String userId) {
    setState(() {
      _users.removeWhere((u) => u.id == userId);
      _filteredUsers.removeWhere((u) => u.id == userId);
    });
    BlocProvider.of<DeleteUserCubit>(context).deleteUser(userId);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<DeleteUserCubit, DeleteUserState>(
          listener: (context, state) {
            if (state is DeleteUserError) {
              _loadUsers();
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            } else if (state is DeleteUserLoaded) {
              _loadUsers();
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.deleteUser)));
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: ColorManager.secondColor,
        body: SafeArea(
          child: Column(
            children: [
              SearchField(
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
                        _users = state.user
                            .where((u) => u.status == 'active')
                            .toList();
                        _updateFilteredUsers();

                        if (_filteredUsers.isEmpty) {
                          return Center(
                            child: Text(
                              "لا يوجد مستخدمون",
                              style: TextStyles.white20Bold,
                            ),
                          );
                        }

                        return ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 90),
                          itemCount: _filteredUsers.length,
                          itemBuilder: (context, index) {
                            final user = _filteredUsers[index];
                            print("_filteredUsers${_filteredUsers.length}");
                            if (isStudentsSelected) {
                              return ExpandableCard(
                                name: user.name!,
                                phone: user.phone!,
                                // university: user.university?.name ?? '',
                                universityId: user.universityId,
                                isSupervisor: false,
                                isExpanded: _isExpandedStudents[index],
                                onToggle: () {
                                  setState(() {
                                    _isExpandedStudents[index] =
                                        !_isExpandedStudents[index];
                                  });
                                },

                                deleteIcon: IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () => _showDeleteDialog(user),
                                ),
                              );
                            } else {
                              return ExpandableCard(
                                name: user.name!,
                                phone: user.phone!,
                                line: user.line?.name ?? '',
                                //  universityId: user.universityId,
                                isSupervisor: true,
                                isExpanded: _isExpandedSupervisors[index],
                                onToggle: () {
                                  setState(() {
                                    _isExpandedSupervisors[index] =
                                        !_isExpandedSupervisors[index];
                                  });
                                },

                                deleteIcon: IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
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
      ),
    );
  }

  void _showDeleteDialog(UserEntity user) {
    showDialog(
      context: context,
      builder: (context) => DeleteDialog(
        context: context,
        title: "تأكيد الحذف",
        content: "هل تريد حذف ${user.name}؟",
        onConfirm: () => _handleDeleteUser(user.id!),
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
                if (!isStudentsSelected) {
                  setState(() {
                    isStudentsSelected = true;
                    _updateFilteredUsers();
                  });
                }
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
                if (isStudentsSelected) {
                  setState(() {
                    isStudentsSelected = false;
                    _updateFilteredUsers();
                  });
                }
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
