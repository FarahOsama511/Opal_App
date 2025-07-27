import 'package:equatable/equatable.dart';
import 'package:opal_app/features/Admin/Domain/entities/tour.dart';

import 'university_entity.dart';

class UserEntity extends Equatable {
  final String? id;
  final String? name;
  final String? phone;
  final String? role;
  final String? universityId;
  final String? universityCardId;
  final LineEntity? line;
  final bool? isActivated;
  final UniversityEntity? university;
  final String? email;
  final String? password;

  UserEntity({
    this.university,
    this.isActivated,
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
    id,
    name,
    phone,
    role,
    universityId,
    universityCardId,
    line,
    isActivated,
    university,
    email,
    password,
  ];
}
