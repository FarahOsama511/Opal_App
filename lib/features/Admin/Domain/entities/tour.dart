import 'package:equatable/equatable.dart';

import '../../../user/Domain/entities/user_entity.dart';

class Tour extends Equatable {
  final String? id;
  final String type;
  final String? driverName; // <-- خليتها nullable
  final DateTime leavesAt;
  //final String? supervisorName;
  final LineEntity line;
  final List<UserEntity>? users;

  Tour({
    //  required this.supervisorName,
    this.users,
    this.id,
    required this.type,
    required this.driverName,
    required this.leavesAt,
    required this.line,
  });

  @override
  List<Object?> get props => [
    id,
    type,
    driverName,
    leavesAt,
    line,
    users,
    // supervisorName,
  ];
}

class LineEntity extends Equatable {
  final String? id;
  final String? name;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  LineEntity({this.id, this.name, this.createdAt, this.updatedAt});

  @override
  List<Object?> get props => [id, name, createdAt, updatedAt];
}
