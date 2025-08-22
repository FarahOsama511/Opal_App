import 'package:equatable/equatable.dart';

import '../../../Admin/Domain/entities/line_entity.dart';
import 'university_entity.dart';

class UserEntity extends Equatable {
  final String? id;
  final String? name;
  final String? phone;
  final String? role;
  final String? universityId;
  final String? universityCardId;
  final LineEntity? line;
  final String? lineId;
  final String? status;
  final UniversityEntity? university;
  final String? email;
  final String? password;

  UserEntity({
    this.lineId,
    this.university,
    this.status,
    this.id,
    this.name,
    this.phone,
    this.role,
    this.universityId,
    this.universityCardId,
    this.line,
    this.email,
    this.password,
  });

  @override
  List<Object?> get props => [
    lineId,
    id,
    name,
    phone,
    role,
    universityId,
    universityCardId,
    line,
    status,
    university,
    email,
    password,
  ];
}
