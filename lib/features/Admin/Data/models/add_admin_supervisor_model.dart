import 'package:opal_app/features/Admin/Data/models/line_model.dart';
import 'package:opal_app/features/user/Domain/entities/user_entity.dart';

class AddAdminSupervisorModel extends UserEntity {
  AddAdminSupervisorModel({
    super.id,
    super.name,
    super.phone,
    super.password,
    super.email,
    super.role,
    super.lineId,
    super.line,
  });
  factory AddAdminSupervisorModel.fromJson(Map<String, dynamic> json) {
    return AddAdminSupervisorModel(
      lineId: json['lineId'],
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      password: json['password'],
      email: json['email'],
      role: json['role'],
      line: json['line'] != null ? LineModel.fromJson(json['line']) : null,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'line': line is LineModel ? (line as LineModel).toJson() : null,
      'lineId': lineId,
      'id': id,
      'name': name,
      'phone': phone,
      'password': password,
      'email': email,
      'role': role,
    };
  }
}
