import 'package:opal_app/features/user/Data/models/university_model.dart';
import 'package:opal_app/features/user/Domain/entities/user_entity.dart';
import '../../../Admin/Data/models/line_model.dart';
import '../../../Admin/Domain/entities/tour.dart';
import '../../Domain/entities/university_entity.dart';

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
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      role: json['role'],
      universityId: json['universityId'],
      universityCardId: json['universityCardId'],
      email: json['email'],
      status: json['status'],
      password: json['password'],
      // 👇 المشكلة هنا: لازم تعمل parsing للـ university object
      university: json['university'] != null
          ? UniversityModel.fromJson(json['university'])
          : null,
      line: json['line'] != null ? LineModel.fromJson(json['line']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
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
