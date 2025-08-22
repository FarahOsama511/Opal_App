import 'package:equatable/equatable.dart';

class LineEntity extends Equatable {
  final String? id;
  final String? name;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? notes;

  LineEntity({this.id, this.name, this.createdAt, this.updatedAt, this.notes});

  @override
  List<Object?> get props => [id, name, createdAt, updatedAt, notes];
}
