import 'package:equatable/equatable.dart';

class LineEntity extends Equatable {
  final String? id;
  final String? name;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? notes;

  const LineEntity({
    this.id,
    this.name,
    this.createdAt,
    this.updatedAt,
    this.notes,
  });

  LineEntity copyWith({
    String? id,
    String? name,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? notes,
  }) {
    return LineEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      notes: notes ?? this.notes,
    );
  }

  @override
  List<Object?> get props => [id, name, createdAt, updatedAt, notes];
}
