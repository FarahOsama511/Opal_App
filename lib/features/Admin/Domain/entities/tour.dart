import 'package:equatable/equatable.dart';

import '../../../user/Domain/entities/user_entity.dart';
import 'line_entity.dart';

class Tour extends Equatable {
  final String? id;
  final String type;
  final String? driverName; // <-- خليتها nullable
  final DateTime leavesAt;
  final SuperVisorEntity supervisor;
  final DateTime startTime;
  final DateTime endTime;
  final LineEntity line;
  final List<UserEntity>? users;

  Tour({
    required this.supervisor,
    required this.startTime,
    required this.endTime,
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
    startTime,
    endTime,
    supervisor,
  ];
  String get typeDisplay {
    switch (type) {
      case 'go':
        return 'ميعاد الذهاب';
      case 'return':
        return 'ميعاد العودة';
      default:
        return 'نوع غير معروف';
    }
  }
}

class SuperVisorEntity extends Equatable {
  final String? id;
  final String? name;
  final String? phone;
  final String? email;
  final String? role;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  SuperVisorEntity({
    this.id,
    this.name,
    this.phone,
    this.email,
    this.role,
    this.createdAt,
    this.updatedAt,
  });

  @override
  @override
  List<Object?> get props => [id];
}
