import 'package:opal_app/features/user/Data/models/university_model.dart';
import 'package:opal_app/features/user/Domain/entities/user_entity.dart';
import '../../../Admin/Data/models/line_model.dart';
import '../../../Admin/Domain/entities/tour.dart';
import '../../Domain/entities/university_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    String? id,
    String? name,
    String? phone,
    String? role,
    String? universityId,
    String? universityCardId,
    LineEntity? line,
    bool? isActivated,
    UniversityEntity? university,
    String? email,
    String? password,
  }) : super(
         id: id,
         name: name,
         phone: phone,
         role: role,
         universityId: universityId,
         universityCardId: universityCardId,
         line: line,
         isActivated: isActivated,
         university: university,
         email: email,
         password: password,
       );
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? "",
      name: json['name']?.toString() ?? "",
      phone: json['phone']?.toString() ?? "",
      role: json['role']?.toString() ?? "",
      universityId: json['universityId']?.toString() ?? "",
      universityCardId: json['universityCardId']?.toString() ?? "",
      email: json['email']?.toString() ?? "",
      password: json['password']?.toString() ?? "",
      line: json['line'] != null
          ? LineModel.fromJson(json['line'] as Map<String, dynamic>)
          : null,
      isActivated: json['isActivated'] as bool?,
      university: json['university'] != null
          ? UniversityModel.fromJson(json['university'] as Map<String, dynamic>)
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
      'line': line != null ? (line as LineModel).toJson() : null,
      'isActivated': isActivated,
      'university': university != null
          ? (university as UniversityModel).toJson()
          : null,
    };
  }
}
