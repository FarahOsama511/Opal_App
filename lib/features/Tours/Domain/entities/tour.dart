import 'package:equatable/equatable.dart';

class Tour extends Equatable {
  final String id;
  final String type;
  final String driverName;
  final DateTime leavesAt;
  final LineEntity line;

  Tour({
    required this.id,
    required this.type,
    required this.driverName,
    required this.leavesAt,
    required this.line,
  });
  @override
  List<Object?> get props => [id, type, driverName, leavesAt, line];
}

class LineEntity extends Equatable {
  final String id;
  final String? name;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  LineEntity({required this.id, this.name, this.createdAt, this.updatedAt});

  @override
  List<Object?> get props => [id, name, createdAt, updatedAt];
}
