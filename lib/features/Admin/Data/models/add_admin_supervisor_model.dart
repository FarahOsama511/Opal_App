import 'package:opal_app/features/user/Domain/entities/user_entity.dart';

import 'line_model.dart';

class AddAdminSupervisorModel extends UserEntity {
  AddAdminSupervisorModel({
    super.id,
    super.name,
    super.phone,
    super.password,
    super.email,
    super.role,
    super.line,
  });
  factory AddAdminSupervisorModel.fromJson(Map<String, dynamic> json) {
    return AddAdminSupervisorModel(
      line: json['line'] != null
          ? LineModel.fromJson(json['line'] as Map<String, dynamic>)
          : null,
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      password: json['password'],
      email: json['email'],
      role: json['role'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'line': line != null ? (line as LineModel).toJson() : null,
      'id': id,
      'name': name,
      'phone': phone,
      'password': password,
      'email': email,
      'role': role,
    };
  }
}
