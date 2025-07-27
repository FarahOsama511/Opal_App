import 'package:opal_app/features/user/Domain/entities/user_entity.dart';

class AddAdminSupervisorModel extends UserEntity {
  AddAdminSupervisorModel({
    super.id,
    super.name,
    super.phone,
    super.password,
    super.email,
    super.role,
  });
  factory AddAdminSupervisorModel.fromJson(Map<String, dynamic> json) {
    return AddAdminSupervisorModel(
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
      'id': id,
      'name': name,
      'phone': phone,
      'password': password,
      'email': email,
      'role': role,
    };
  }
}
