import 'package:opal_app/features/Admin/Data/models/down_town_model.dart';
import 'package:opal_app/features/user/Data/models/university_model.dart';
import 'package:opal_app/features/user/Domain/entities/user_entity.dart';
import '../../../Admin/Data/models/line_model.dart';

class UserModel extends UserEntity {
  UserModel({
    super.id,
    super.name,
    super.phone,
    super.role,
    super.universityId,
    super.universityCardId,
    super.email,
    super.status,
    super.university,
    super.password,
    super.line,
    super.downTown,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String?,
      name: json['name'] as String?,
      phone: json['phone'] as String?,
      role: json['role'] as String?,
      universityId: json['universityId'] as String?,
      universityCardId: json['universityCardId'] as String?,
      email: json['email'] as String?,
      status: json['status'] as String?,
      password: json['password'] as String?,
      // 👇 المشكلة هنا: لازم تعمل parsing للـ university object
      university: json['university'] != null
          ? UniversityModel.fromJson(json['university'])
          : null,
      line: json['line'] != null ? LineModel.fromJson(json['line']) : null,
      downTown: json['downTown'] != null
          ? DownTownModel.fromJson(json['downTown'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'downTown': downTown != null
          ? (downTown as DownTownModel).toJson()
          : null,
      'id': id,
      'name': name,
      'phone': phone,
      'role': role,
      'email': email,
      'password': password,
      'universityId': universityId,
      'universityCardId': universityCardId,
      'line': line != null ? (line as LineModel).toJson() : null,
      'status': status,
      'university': university != null
          ? (university as UniversityModel).toJson()
          : null,
    };
  }
}
