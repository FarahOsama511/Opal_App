import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:opal_app/features/Admin/Domain/entities/down_town_entity.dart';
import 'package:opal_app/features/Admin/Domain/entities/line_entity.dart';
import 'package:opal_app/features/Admin/presentaion/bloc/delete_down_town/delete_down_town_cubit.dart';
import 'package:opal_app/features/Admin/presentaion/bloc/delete_line/delete_line_cubit.dart';
import 'package:opal_app/features/Admin/presentaion/bloc/delete_line/delete_line_state.dart';
import 'package:opal_app/features/Admin/presentaion/bloc/delete_university/delete_university_cubit.dart';
import 'package:opal_app/features/Admin/presentaion/bloc/delete_university/delete_university_state.dart';
import 'package:opal_app/features/Admin/presentaion/bloc/get_lines/get_all_lines_cubit.dart';
import 'package:opal_app/features/Admin/presentaion/bloc/get_lines/get_all_lines_state.dart';
import 'package:opal_app/features/Admin/presentaion/bloc/update_line/update_line_cubit.dart';
import 'package:opal_app/features/Admin/presentaion/bloc/update_university/update_university_cubit.dart';
import 'package:opal_app/features/user/Domain/entities/university_entity.dart';
import 'package:opal_app/features/user/presentaion/bloc/get_all_downtowns/get_all_down_town_cubit.dart';
import 'package:opal_app/features/user/presentaion/bloc/get_all_downtowns/get_all_down_town_state.dart';
import 'package:opal_app/features/user/presentaion/bloc/get_all_universities/get_all_universities_cubit.dart';
import 'package:opal_app/features/user/presentaion/bloc/get_all_universities/get_all_universities_state.dart';
import '../../../../core/resources/color_manager.dart';
import '../../../../core/resources/text_styles.dart';
import '../bloc/delete_down_town/delete_down_town_state.dart';
import '../bloc/update_down_town/update_down_town_cubit.dart';
import '../widgets/SettingsExpandableCard.dart';
import '../widgets/delete_dialog.dart';
import '../widgets/more_options_button.dart';
import '../widgets/search_field.dart';
import '../widgets/text_field.dart';
import 'edit_page.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isUniversitySelected = true;
  bool isLineSelected = false;
  bool isCitySelected = false;

  List<bool> _isExpandedUniversity = [];
  List<bool> _isExpandedLines = [];
  List<bool> _isExpandedCities = [];

  List<UniversityEntity> _universities = [];
  List<UniversityEntity> _filteredUniversities = [];

  List<LineEntity> _lines = [];
  List<LineEntity> _filteredLines = [];

  // المدن
  List<DownTownEntity> _cities = [];
  List<DownTownEntity> _filteredCities = [];

  String _searchQuery = '';

  void _updateFiltered() {
    _filteredUniversities = _universities;
    _filteredLines = _lines;
    _filteredCities = _cities;

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
    } else if (isLineSelected) {
      _filteredLines = _lines.where((l) {
        return _searchQuery.isEmpty ||
            l.name?.toLowerCase().contains(_searchQuery.toLowerCase()) ==
                true ||
            l.notes?.toLowerCase().contains(_searchQuery) == true;
      }).toList();

      if (_isExpandedLines.length != _filteredLines.length) {
        _isExpandedLines = List.filled(_filteredLines.length, false);
      }
    } else if (isCitySelected) {
      _filteredCities = _cities.where((c) {
        return _searchQuery.isEmpty ||
            c.name?.toLowerCase().contains(_searchQuery.toLowerCase()) == true;
      }).toList();

      if (_isExpandedCities.length != _filteredCities.length) {
        _isExpandedCities = List.filled(_filteredCities.length, false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<DeleteUniversityCubit, DeleteUniversityState>(
          listener: (context, state) {
            if (state is DeleteUniversityError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.message,
                    style: TextStyle(fontSize: 14.sp),
                  ),
                ),
              );
            } else if (state is DeleteUniversitySuccess) {
              BlocProvider.of<GetAllUniversitiesCubit>(
                context,
              ).fetchAlluniversities();

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.message,
                    style: TextStyle(fontSize: 14.sp),
                  ),
                ),
              );
            }
          },
        ),
        BlocListener<DeleteLineCubit, DeleteLineState>(
          listener: (context, state) {
            if (state is DeleteLineError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.message,
                    style: TextStyle(fontSize: 14.sp),
                  ),
                ),
              );
            } else if (state is DeleteLineLoaded) {
              setState(() {
                _lines.removeWhere((u) => u.id == state.id);
                _filteredLines.removeWhere((u) => u.id == state.id);
                _updateFiltered();
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.deleteLine,
                    style: TextStyle(fontSize: 14.sp),
                  ),
                ),
              );
            }
          },
        ),
        BlocListener<DeleteDownTownCubit, DeleteDownTownState>(
          listener: (context, state) {
            if (state is DeleteDownTownError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: ColorManager.greyColor,
                  content: Text(
                    state.message,
                    style: TextStyle(fontSize: 14.sp),
                  ),
                ),
              );
            } else if (state is DeleteDownTownSuccess) {
              setState(() {
                _cities.removeWhere((u) => u.id == state.id);
                _filteredCities.removeWhere((u) => u.id == state.id);
                _updateFiltered();
              });
              // context.pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: ColorManager.greyColor,
                  content: Text(
                    state.message,
                    style: TextStyle(fontSize: 14.sp),
                  ),
                ),
              );
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
                hintText: isUniversitySelected
                    ? 'ابحث عن جامعة'
                    : isLineSelected
                    ? 'ابحث عن خط'
                    : 'ابحث عن مدينة',
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
                  decoration: BoxDecoration(color: Color(0xFFE71A45)),
                  child: isUniversitySelected
                      ? _buildUniversitiesList()
                      : isLineSelected
                      ? _buildLinesList()
                      : _buildCitiesList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🔹 الجامعات
  Widget _buildUniversitiesList() {
    return BlocConsumer<GetAllUniversitiesCubit, GetAllUniversitiesState>(
      listener: (context, state) {
        if (state is GetAllUniversitiesError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message, style: TextStyle(fontSize: 14.sp)),
            ),
          );
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
              child: Text(
                "لا يوجد جامعات",
                style: TextStyles.white20Bold.copyWith(fontSize: 20.sp),
              ),
            );
          }
          return ListView.builder(
            padding: EdgeInsets.all(16.w),
            itemCount: _filteredUniversities.length,
            itemBuilder: (context, index) {
              final university = _filteredUniversities[index];
              final activeUsers =
                  university.users
                      ?.where((user) => user.status == "active")
                      .toList() ??
                  [];
              return SettingsExpandableCard(
                name: university.name ?? 'لا يوجد اسم',
                isSupervisor: false,
                isExpanded: _isExpandedUniversity[index],
                location: university.location ?? 'غير متوفر',
                usersCount: activeUsers.length,
                onToggle: () {
                  setState(() {
                    _isExpandedUniversity[index] =
                        !_isExpandedUniversity[index];
                  });
                },
                deleteIcon: MoreOptionsButton(
                  entity: university, // أو line أو city
                  onEdit: (e) => _handleEdit(context, e),
                  onDelete: _showDeleteDialog,
                ),
              );
            },
          );
        } else if (state is GetAllUniversitiesLoading) {
          return Center(
            child: CircularProgressIndicator(color: ColorManager.secondColor),
          );
        } else {
          return Center(
            child: Text(
              state is GetAllUniversitiesError
                  ? state.message
                  : "حدث خطأ أثناء التحميل",
              style: TextStyles.white20Bold.copyWith(fontSize: 18.sp),
            ),
          );
        }
      },
    );
  }

  // 🔹 الخطوط
  Widget _buildLinesList() {
    return BlocConsumer<LinesCubit, GetAllLinesState>(
      listener: (context, state) {
        if (state is LinesError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message, style: TextStyle(fontSize: 14.sp)),
            ),
          );
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
              child: Text(
                "لا يوجد خطوط",
                style: TextStyles.white20Bold.copyWith(fontSize: 20.sp),
              ),
            );
          }
          return ListView.builder(
            padding: EdgeInsets.all(16.w),
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
                deleteIcon: MoreOptionsButton(
                  entity: line, // أو line أو city
                  onEdit: (e) => _handleEdit(context, e),
                  onDelete: _showDeleteDialog,
                ),
              );
            },
          );
        } else if (state is LinesLoading) {
          return Center(
            child: CircularProgressIndicator(color: ColorManager.secondColor),
          );
        } else {
          return Center(
            child: Text(
              state is LinesError ? state.message : "حدث خطأ أثناء التحميل",
              style: TextStyles.white20Bold.copyWith(fontSize: 18.sp),
            ),
          );
        }
      },
    );
  }

  // 🔹 المدن
  Widget _buildCitiesList() {
    return BlocConsumer<GetAllDownTownCubit, GetAllDownTownState>(
      listener: (context, state) {
        if (state is GetAllDownTownsError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message, style: TextStyle(fontSize: 14.sp)),
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is GetAllDownTownsSuccess) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              _cities = state.getAllDownTowns;

              _updateFiltered();
            });
          });
          if (_filteredCities.isEmpty) {
            return Center(
              child: Text(
                "لا يوجد مدن",
                style: TextStyles.white20Bold.copyWith(fontSize: 20.sp),
              ),
            );
          }
          return ListView.builder(
            padding: EdgeInsets.all(16.w),
            itemCount: _filteredCities.length,
            itemBuilder: (context, index) {
              final city = _filteredCities[index];
              return SettingsExpandableCard(
                name: city.name ?? 'لا يوجد اسم',
                location: city.name ?? 'غير متوفر',
                isSupervisor: false,
                isExpanded: _isExpandedCities[index],
                usersCount: city.users?.length ?? 0,

                onToggle: () {
                  setState(() {
                    _isExpandedCities[index] = !_isExpandedCities[index];
                  });
                },
                deleteIcon: MoreOptionsButton(
                  entity: city, // أو line أو city
                  onEdit: (e) => _handleEdit(context, e),
                  onDelete: _showDeleteDialog,
                ),
              );
            },
          );
        } else if (state is GetAllDownTownsLoading) {
          return Center(
            child: CircularProgressIndicator(color: ColorManager.secondColor),
          );
        } else {
          return Center(
            child: Text(
              state is GetAllDownTownsError
                  ? state.message
                  : "حدث خطأ أثناء التحميل",
              style: TextStyles.white20Bold.copyWith(fontSize: 18.sp),
            ),
          );
        }
      },
    );
  }

  // 🔹 زرار التبديل
  Widget _buildSwitchButtons() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                if (!isUniversitySelected) {
                  setState(() {
                    isUniversitySelected = true;
                    isLineSelected = false;
                    isCitySelected = false;
                    _updateFiltered();
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isUniversitySelected
                    ? ColorManager.primaryColor
                    : Colors.grey.shade300,
                minimumSize: Size(0, 45.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.r),
                ),
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown, // النص يتغير حجمه تلقائيًا
                child: Text(
                  'الجامعات',
                  style: isUniversitySelected
                      ? TextStyles.white14Bold
                      : TextStyles.black14Bold,
                ),
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                if (!isLineSelected) {
                  setState(() {
                    isUniversitySelected = false;
                    isLineSelected = true;
                    isCitySelected = false;
                    _updateFiltered();
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isLineSelected
                    ? ColorManager.primaryColor
                    : Colors.grey.shade300,
                minimumSize: Size(0, 45.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.r),
                ),
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'الخطوط',
                  style: isLineSelected
                      ? TextStyles.white14Bold
                      : TextStyles.black14Bold,
                ),
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                if (!isCitySelected) {
                  setState(() {
                    isUniversitySelected = false;
                    isLineSelected = false;
                    isCitySelected = true;
                    _updateFiltered();
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isCitySelected
                    ? ColorManager.primaryColor
                    : Colors.grey.shade300,
                minimumSize: Size(0, 45.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.r),
                ),
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'المدن',
                  style: isCitySelected
                      ? TextStyles.white14Bold
                      : TextStyles.black14Bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 الديليت
  void _showDeleteDialog(dynamic entity) {
    String name = entity.name ?? "بدون اسم";
    String id = entity.id ?? "0";

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
          } else if (entity is DownTownEntity) {
            _handleDeleteCity(id);
          }
        },
      ),
    );
  }

  void _handleDeleteLine(String lineId) {
    BlocProvider.of<DeleteLineCubit>(context).deleteLine(lineId);
    context.pop();
  }

  void _handleDeleteUniversity(String universityId) {
    BlocProvider.of<DeleteUniversityCubit>(
      context,
    ).deleteUniversity(universityId);
    context.pop();
  }

  void _handleDeleteCity(String cityId) {
    BlocProvider.of<DeleteDownTownCubit>(context).deleteDownTown(cityId);
    context.pop();
  }
}

void _handleEdit(BuildContext context, dynamic entity) {
  if (entity is UniversityEntity) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditPage(
          title: "تعديل الجامعة",
          buttonText: "تعديل الجامعة",
          initialValues: {"name": entity.name ?? "", "notes": ""},
          extraFields: [
            CustomTextField(
              hint: 'الموقع',
              controller: TextEditingController(text: entity.location ?? ""),
            ),
          ],
          onSave: (values) async {
            final updateEntity = entity.copyWith(name: values["name"]);
            await context.read<UpdateUniversityCubit>().updateUniversity(
              updateEntity,
            );
            print("تم تعديل الجامعة: ${values['name']} - ${values['notes']}");
          },
        ),
      ),
    );
  } else if (entity is LineEntity) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditPage(
          title: "تعديل الخط",
          buttonText: "تعديل الخط",
          initialValues: {
            "name": entity.name ?? "",
            "notes": entity.notes ?? "",
          },
          extraFields: [
            CustomTextField(
              hint: 'ملاحظات',
              controller: TextEditingController(text: entity.notes ?? ""),
            ),
          ],
          onSave: (values) async {
            final updateEntity = entity.copyWith(
              name: values["name"],
              notes: values["notes"],
            );
            await context.read<UpdateLineCubit>().updateLine(updateEntity);
            print("تم تعديل الخط: ${values['name']} - ${values['notes']}");
          },
        ),
      ),
    );
  } else if (entity is DownTownEntity) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditPage(
          title: "تعديل المدينة",
          buttonText: "تعديل المدينة",
          initialValues: {"name": entity.name ?? "", "notes": ""},
          onSave: (values) async {
            final updateEntity = entity.copyWith(name: values["name"]);
            await context.read<UpdateDownTownCubit>().updateDownTown(
              updateEntity,
            );
            print("تم تعديل المدينة: ${values['name']}");
          },
        ),
      ),
    );
  }
}
