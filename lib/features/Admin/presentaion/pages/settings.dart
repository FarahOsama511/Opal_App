import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:opal_app/features/Admin/Domain/entities/down_town_entity.dart';
import 'package:opal_app/features/Admin/Domain/entities/line_entity.dart';
import 'package:opal_app/features/Admin/presentaion/bloc/delete_down_town/delete_down_town_cubit.dart';
import 'package:opal_app/features/Admin/presentaion/bloc/delete_line/delete_line_cubit.dart';
import 'package:opal_app/features/Admin/presentaion/bloc/delete_university/delete_university_cubit.dart';
import 'package:opal_app/features/user/Domain/entities/university_entity.dart';
import '../../../../core/resources/color_manager.dart';
import '../widgets/DeleteListenersWidget.dart';
import '../widgets/cities_list.dart';
import '../widgets/delete_dialog.dart';
import '../widgets/lines_list.dart';
import '../widgets/search_field.dart';
import '../widgets/settings_buttons.dart';
import '../widgets/universities_list.dart';

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
    DeleteListenersWidget(
      onUpdateLines: (lineId) {
        setState(() {
          _lines.removeWhere((l) => l.id == lineId);
          _filteredLines.removeWhere((l) => l.id == lineId);
          _updateFiltered();
        });
      },
      onUpdateCities: (cityId) {
        setState(() {
          _cities.removeWhere((c) => c.id == cityId);
          _filteredCities.removeWhere((c) => c.id == cityId);
          _updateFiltered();
        });
      },
    );

    return Scaffold(
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
              SwitchButtonsWidget(
                isUniversitySelected: isUniversitySelected,
                isLineSelected: isLineSelected,
                isCitySelected: isCitySelected,
                onUniversityPressed: () {
                  if (!isUniversitySelected) {
                    setState(() {
                      isUniversitySelected = true;
                      isLineSelected = false;
                      isCitySelected = false;
                      _updateFiltered();
                    });
                  }
                },
                onLinePressed: () {
                  if (!isLineSelected) {
                    setState(() {
                      isUniversitySelected = false;
                      isLineSelected = true;
                      isCitySelected = false;
                      _updateFiltered();
                    });
                  }
                },
                onCityPressed: () {
                  if (!isCitySelected) {
                    setState(() {
                      isUniversitySelected = false;
                      isLineSelected = false;
                      isCitySelected = true;
                      _updateFiltered();
                    });
                  }
                },
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(color: Color(0xFFE71A45)),
                  child: isUniversitySelected
                      ? UniversitiesListWidget(
                    universities: _universities,
                    filteredUniversities: _filteredUniversities,
                    isExpandedUniversity: _isExpandedUniversity,
                    onToggle: (index) {
                      setState(() {
                        _isExpandedUniversity[index] =
                        !_isExpandedUniversity[index];
                      });
                    },
                    showDeleteDialog: _showDeleteDialog,
                    updateFiltered: _updateFiltered,
                  )
                      : isLineSelected
                      ? LinesListWidget(
                    lines: _lines,
                    filteredLines: _filteredLines,
                    isExpandedLines: _isExpandedLines,
                    onToggle: (index) {
                      setState(() {
                        _isExpandedLines[index] = !_isExpandedLines[index];
                      });
                    },
                    showDeleteDialog: _showDeleteDialog,
                    updateFiltered: _updateFiltered,
                  )
                      : CitiesListWidget(
                    cities: _cities,
                    filteredCities: _filteredCities,
                    isExpandedCities: _isExpandedCities,
                    onToggle: (index) {
                      setState(() {
                        _isExpandedCities[index] = !_isExpandedCities[index];
                      });
                    },
                    showDeleteDialog: _showDeleteDialog,
                    updateFiltered: _updateFiltered,
                  ),
                ),
              ) ],),),);}
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

