import 'package:equatable/equatable.dart';

class UniversityEntity extends Equatable {
  final String? id;
  final String? name;
  final String? location;

  UniversityEntity({this.id, this.name, this.location});

  @override
  List<Object?> get props => [id, name, location];
}
