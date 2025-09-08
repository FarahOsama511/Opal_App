import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../user/Domain/entities/university_entity.dart';
import '../../Domain/entities/down_town_entity.dart';
import '../../Domain/entities/line_entity.dart';
import '../bloc/update_down_town/update_down_town_cubit.dart';
import '../bloc/update_line/update_line_cubit.dart';
import '../bloc/update_university/update_university_cubit.dart';
import '../pages/edit_page.dart';
import 'text_field.dart';

class EditHandler {
  static void openEditPage(BuildContext context, dynamic entity) {
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
}
