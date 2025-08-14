import 'package:equatable/equatable.dart';

class UniversityEntity extends Equatable {
  final String? id;
  final String? name;
  final String? location;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UniversityEntity({
    this.id,
    this.name,
    this.location,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [id, name, location, createdAt, updatedAt];
}
