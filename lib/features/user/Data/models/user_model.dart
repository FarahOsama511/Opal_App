import '../../../Admin/Data/models/down_town_model.dart';
import '../../../Admin/Data/models/line_model.dart';
import '../../Domain/entities/user_entity.dart';
import 'university_model.dart';

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
    super.universities,
    super.universitiesId,
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

      // object واحد
      university: json['university'] != null
          ? UniversityModel.fromJson(json['university'])
          : null,

      // object واحد
      line: json['line'] != null ? LineModel.fromJson(json['line']) : null,

      // لستة objects
      universities: json['universities'] != null
          ? (json['universities'] as List)
                .map((e) => UniversityModel.fromJson(e as Map<String, dynamic>))
                .toList()
          : [],

      // لستة ids
      universitiesId: json['universitiesId'] != null
          ? List<String>.from(json['universitiesId'])
          : [],

      // object واحد
      downTown: json['downTown'] != null
          ? DownTownModel.fromJson(json['downTown'])
          : null,
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
      'status': status,

      'line': line != null ? (line as LineModel).toJson() : null,
      'university': university != null
          ? (university as UniversityModel).toJson()
          : null,
      'downTown': downTown != null
          ? (downTown as DownTownModel).toJson()
          : null,

      // ✅ مهم: تحويل الجامعات إلى Json
      'universities': universities != null
          ? universities!.map((u) => (u as UniversityModel).toJson()).toList()
          : [],

      // ✅ ids كمان
      'universitiesId': universitiesId ?? [],
    };
  }
}
