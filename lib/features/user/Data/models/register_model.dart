import '../../../Admin/Data/models/down_town_model.dart';
import '../../../Admin/Data/models/line_model.dart';
import '../../Domain/entities/authentity.dart';
import '../../Domain/entities/user_entity.dart';
import 'university_model.dart';

class RegisterModel extends RegisterEntity {
  RegisterModel({required super.user});
  factory RegisterModel.fromJson(Map<String, dynamic> json) {
    return RegisterModel(
      user: UserEntity(
        name: json['name'] ?? "",
        phone: json['phone'] ?? "",
        universityCardId: json['universityCardId'] ?? "",
        universityId: json['universityId'] ?? "",
        role: json['role'] ?? "",
        downTown: json['downTown'] != null
            ? DownTownModel.fromJson(json['downTown'])
            : null,
        line: json['line'] != null ? LineModel.fromJson(json['line']) : null,
        university: json['university'] != null
            ? UniversityModel.fromJson(json['university'])
            : null,
      ),
    );
  }
  @override
  Map<String, dynamic> toJson() {
    return {
      'name': user.name,
      'phone': user.phone,
      'universityCardId': user.universityCardId,
      'universityId': user.universityId,
      'role': user.role,
      'downTownId': user.downTown?.id,
      'lineId': user.line?.id,
    };
  }
}
