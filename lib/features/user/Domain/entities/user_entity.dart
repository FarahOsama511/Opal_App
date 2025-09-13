import 'package:equatable/equatable.dart';
import '../../../Admin/Domain/entities/down_town_entity.dart';
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
  final String? downTownId;
  final DownTownEntity? downTown;
  final List<String>? universitiesId;
  final List<UniversityEntity>? universities;

  UserEntity({
    this.universities,
    this.downTown,
    this.downTownId,
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
    this.universitiesId,
  });

  @override
  List<Object?> get props => [
    downTown,
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
    downTownId,
    universitiesId,
    universities,
  ];
}

extension UserEntityCopyWith on UserEntity {
  UserEntity copyWith({
    String? id,
    String? name,
    String? phone,
    String? role,
    String? universityId,
    String? universityCardId,
    LineEntity? line,
    String? lineId,
    String? status,
    UniversityEntity? university,
    String? email,
    String? password,
    String? downTownId,
    DownTownEntity? downTown,
    List<String>? universitiesId,
    List<UniversityEntity>? universities,
  }) {
    return UserEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      universityId: universityId ?? this.universityId,
      universityCardId: universityCardId ?? this.universityCardId,
      line: line ?? this.line,
      lineId: lineId ?? this.lineId,
      status: status ?? this.status,
      university: university ?? this.university,
      email: email ?? this.email,
      password: password ?? this.password,
      downTownId: downTownId ?? this.downTownId,
      downTown: downTown ?? this.downTown,
      universitiesId: universitiesId ?? this.universitiesId,
      universities: universities ?? this.universities,
    );
  }
}
