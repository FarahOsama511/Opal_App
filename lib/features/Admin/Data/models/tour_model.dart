import 'dart:developer';
import 'package:opal_app/features/Admin/Data/models/supervisor_model.dart';
import 'package:opal_app/features/user/Data/models/user_model.dart';
import 'package:opal_app/features/user/Domain/entities/user_entity.dart';
import '../../Domain/entities/line_entity.dart';
import '../../Domain/entities/tour.dart';
import 'line_model.dart';

class TourModel extends Tour {
  TourModel({
    String? id,
    required String type,
    String? driverName,
    required DateTime leavesAt,
    required LineEntity line,
    List<UserEntity>? users,
    required DateTime startTime,
    required DateTime endTime,
    required SuperVisorEntity supervisor,
  }) : super(
         supervisor: supervisor,
         startTime: startTime,
         endTime: endTime,
         id: id,
         type: type,
         driverName: driverName,
         leavesAt: leavesAt,
         line: line,
         users: users,
       );

  factory TourModel.fromJson(Map<String, dynamic> json) {
    log('TourModel fromJson: $json');

    final lineJson = json['line'];
    final usersJson = json['users'] as List<dynamic>?;

    return TourModel(
      supervisor: json['supervisor'] != null
          ? SuperVisorModel.fromJson(json['supervisor'] as Map<String, dynamic>)
          : SuperVisorEntity(
              id: json['supervisorId'],
              name: '',
              role: "supervisor",
              phone: '',
              email: '',
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            ),
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      id: json['id'] as String?,
      type: json['type'] as String,
      driverName: json['driverName'] as String?,
      leavesAt: DateTime.parse(json['leavesAt'] as String),
      line: lineJson != null
          ? LineModel.fromJson(lineJson as Map<String, dynamic>)
          : LineEntity(
              id: json['lineId'] ?? '',
              name: '',
              notes: json['notes'] ?? "",
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            ),
      users: usersJson?.map((user) => UserModel.fromJson(user)).toList(),
    );
  }

  Map<String, dynamic> ToJson(TourModel tour) {
    return {
      'id': tour.id,
      'type': tour.type,
      'driverName': tour.driverName,
      'leavesAt': tour.leavesAt.toIso8601String(),
      'line': tour.line is LineModel ? (tour.line as LineModel).toJson() : null,
      'users': tour.users?.map((user) => (user as UserModel).toJson()).toList(),
      'startTime': tour.startTime.toIso8601String(),
      'endTime': tour.endTime.toIso8601String(),
      'supervisor': supervisor is SuperVisorModel
          ? (tour.supervisor as SuperVisorModel).toJson()
          : null,
    };
  }
}
