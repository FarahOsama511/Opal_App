import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opal_app/features/Admin/Domain/entities/line_entity.dart';
import 'package:opal_app/features/Admin/presentaion/bloc/delete_line/delete_line_cubit.dart';
import 'package:opal_app/features/Admin/presentaion/bloc/delete_line/delete_line_state.dart';
import 'package:opal_app/features/Admin/presentaion/bloc/delete_university/delete_university_cubit.dart';
import 'package:opal_app/features/Admin/presentaion/bloc/delete_university/delete_university_state.dart';
import 'package:opal_app/features/Admin/presentaion/bloc/get_lines/get_all_lines_cubit.dart';
import 'package:opal_app/features/Admin/presentaion/bloc/get_lines/get_all_lines_state.dart';
import 'package:opal_app/features/user/Domain/entities/university_entity.dart';
import 'package:opal_app/features/user/presentaion/bloc/get_all_universities/get_all_universities_cubit.dart';
import 'package:opal_app/features/user/presentaion/bloc/get_all_universities/get_all_universities_state.dart';
import '../../../../core/resources/color_manager.dart';
import '../../../../core/resources/text_styles.dart';
import '../widgets/SettingsExpandableCard.dart';
import '../widgets/delete_dialog.dart';
import '../widgets/search_field.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isUniversitySelected = true;
  List<bool> _isExpandedUniversity = [];
  List<bool> _isExpandedLines = [];
  List<UniversityEntity> _universities = [];
  List<UniversityEntity> _filteredUniversities = [];
  List<LineEntity> _lines = [];
  List<LineEntity> _filteredLines = [];
  String _searchQuery = '';

  void _updateFiltered() {
    _filteredUniversities = _universities;
    _filteredLines = _lines;
    if (isUniversitySelected) {
      _filteredUniversities = _universities.where((u) {
        return _searchQuery.isEmpty ||
            u.name?.toLowerCase().contains(_searchQuery.toLowerCase()) ==
                true ||
            u.location?.toLowerCase().contains(_searchQuery.toLowerCase()) ==
                true;
      }).toList();

      if (_isExpandedUniversity.length != _filteredUniversities.length) {
        _isExpandedUniversity = List.filled(
          _filteredUniversities.length,
          false,
        );
      }
    } else {
      _filteredLines = _lines.where((l) {
        return _searchQuery.isEmpty ||
            l.name?.toLowerCase().contains(_searchQuery.toLowerCase()) ==
                true ||
            l.notes?.toLowerCase().contains(_searchQuery) == true;
      }).toList();

      if (_isExpandedLines.length != _filteredLines.length) {
        _isExpandedLines = List.filled(_filteredLines.length, false);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<GetAllUniversitiesCubit>(context).fetchAlluniversities();
    BlocProvider.of<LinesCubit>(context).getAllLiness();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<DeleteUniversityCubit, DeleteUniversityState>(
          listener: (context, state) {
            if (state is DeleteUniversityError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            } else if (state is DeleteUniversitySuccess) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
        ),
        BlocListener<DeleteLineCubit, DeleteLineState>(
          listener: (context, state) {
            if (state is DeleteLineError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            } else if (state is DeleteLineLoaded) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.deleteLine)));
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
                hintText: isUniversitySelected ? 'ابحث عن جامعة' : 'ابحث عن خط',
                fillColor: ColorManager.secondColor,
                iconColor: ColorManager.primaryColor,
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                    _updateFiltered();
                  });
                },
              ),
              _buildSwitchButtons(),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(color: Color(0xFFE71A45)),
                  child: isUniversitySelected
                      ? _buildUniversitiesList()
                      : _buildLinesList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUniversitiesList() {
    return BlocConsumer<GetAllUniversitiesCubit, GetAllUniversitiesState>(
      listener: (context, state) {
        if (state is GetAllUniversitiesError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        } else if (state is GetAllUniversitiesSuccess) {
          setState(() {
            _universities = state.GetAllUniversities;
            _updateFiltered();
          });
        }
      },
      builder: (context, state) {
        if (state is GetAllUniversitiesSuccess) {
          if (_filteredUniversities.isEmpty) {
            return Center(
              child: Text("لا يوجد جامعات", style: TextStyles.white20Bold),
            );
          }

          print(
            "عدد المستخدمين في أول جامعة: ${_universities.first.users?.length}",
          );

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _filteredUniversities.length,
            itemBuilder: (context, index) {
              final university = _filteredUniversities[index];
              return SettingsExpandableCard(
                name: university.name ?? 'لا يوجد اسم',
                isSupervisor: false,
                isExpanded: _isExpandedUniversity[index],
                location: university.location ?? 'غير متوفر',
                usersCount: university.users?.length ?? 0,
                onToggle: () {
                  setState(() {
                    _isExpandedUniversity[index] =
                        !_isExpandedUniversity[index];
                  });
                },
                deleteIcon: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _showDeleteDialog(university),
                ),
              );
            },
          );
        } else if (state is GetAllUniversitiesLoading) {
          return const Center(
            child: CircularProgressIndicator(color: ColorManager.secondColor),
          );
        } else {
          return Center(
            child: Text(
              state is GetAllUniversitiesError
                  ? state.message
                  : "حدث خطأ أثناء التحميل",
              style: TextStyles.white20Bold,
            ),
          );
        }
      },
    );
  }

  Widget _buildLinesList() {
    return BlocConsumer<LinesCubit, GetAllLinesState>(
      listener: (context, state) {
        if (state is LinesError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        if (state is LinesLoaded) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              _lines = state.Liness;
              _updateFiltered();
            });
          });

          if (_filteredLines.isEmpty) {
            return Center(
              child: Text("لا يوجد خطوط", style: TextStyles.white20Bold),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _filteredLines.length,
            itemBuilder: (context, index) {
              final line = _filteredLines[index];
              return SettingsExpandableCard(
                name: line.name ?? 'لا يوجد اسم',
                isSupervisor: true,
                isExpanded: _isExpandedLines[index],
                notes: line.notes ?? 'غير متوفر',
                onToggle: () {
                  setState(() {
                    _isExpandedLines[index] = !_isExpandedLines[index];
                  });
                },
                deleteIcon: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _showDeleteDialog(line),
                ),
              );
            },
          );
        } else if (state is LinesLoading) {
          return const Center(
            child: CircularProgressIndicator(color: ColorManager.secondColor),
          );
        } else {
          return Center(
            child: Text(
              state is LinesError ? state.message : "حدث خطأ أثناء التحميل",
              style: TextStyles.white20Bold,
            ),
          );
        }
      },
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
                if (!isUniversitySelected) {
                  setState(() {
                    isUniversitySelected = true;
                    _updateFiltered();
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isUniversitySelected
                    ? const Color(0xFFE71A45)
                    : Colors.grey.shade300,
              ),
              child: Text(
                'الجامعات',
                style: TextStyle(
                  color: isUniversitySelected ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                if (isUniversitySelected) {
                  setState(() {
                    isUniversitySelected = false;
                    _updateFiltered();
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isUniversitySelected
                    ? Colors.grey.shade300
                    : ColorManager.primaryColor,
              ),
              child: Text(
                'الخطوط',
                style: TextStyle(
                  color: isUniversitySelected
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

  void _showDeleteDialog(dynamic entity) {
    String name = entity.name ?? "بدون اسم";
    String id = entity.id ?? 0;

    showDialog(
      context: context,
      builder: (context) => DeleteDialog(
        context: context,
        title: "تأكيد الحذف",
        content: "هل تريد حذف $name؟",
        onConfirm: () {
          if (entity is LineEntity) {
            _handleDeleteLine(id);
          } else if (entity is UniversityEntity) {
            _handleDeleteUniversity(id);
          }
        },
      ),
    );
  }

  void _handleDeleteLine(String lineId) {
    setState(() {
      _lines.removeWhere((u) => u.id == lineId);
      _filteredLines.removeWhere((u) => u.id == lineId);
    });
    BlocProvider.of<DeleteLineCubit>(context).deleteLine(lineId);
    Navigator.pop(context);
  }

  void _handleDeleteUniversity(String universityId) {
    setState(() {
      _universities.removeWhere((u) => u.id == universityId);
      _filteredUniversities.removeWhere((u) => u.id == universityId);
    });
    BlocProvider.of<DeleteUniversityCubit>(context).deleteUser(universityId);
    Navigator.pop(context);
  }
}
