import 'package:equatable/equatable.dart';

import 'user_entity.dart';

class UniversityEntity extends Equatable {
  final String? id;
  final String? name;
  final String? location;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<UserEntity>? users;

  UniversityEntity({
    this.users,
    this.id,
    this.name,
    this.location,
    this.createdAt,
    this.updatedAt,
  });
  UniversityEntity copyWith({
    String? id,
    String? name,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UniversityEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [id, name, location, createdAt, updatedAt, users];
}
