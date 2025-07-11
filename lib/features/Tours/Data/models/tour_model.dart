import '../../Domain/entities/tour.dart';

class TourModel extends Tour {
  TourModel({
    required String id,
    required String type,
    required String driverName,
    required DateTime leavesAt,
    required LineEntity line,
  }) : super(
         id: id,
         type: type,
         driverName: driverName,
         leavesAt: leavesAt,
         line: line,
       );

  factory TourModel.fromJson(Map<String, dynamic> json) {
    return TourModel(
      id: json['id'] as String,
      type: json['type'] as String,
      driverName: json['driverName'] as String,
      leavesAt: DateTime.parse(json['leavesAt'] as String),
      line: LineEntity(
        id: json['line']['id'] as String,
        name: json['line']['name'] as String,
        createdAt: DateTime.parse(json['line']['createdAt'] as String),
        updatedAt: DateTime.parse(json['line']['updatedAt'] as String),
      ),
    );
  }
}

Map<String, dynamic> ToJson(TourModel tour) {
  return {
    'id': tour.id,
    'type': tour.type,
    'driverName': tour.driverName,
    'leavesAt': tour.leavesAt.toIso8601String(),
    'line': {
      'id': tour.line.id,
      'name': tour.line.name,
      'createdAt': tour.line.createdAt.toIso8601String(),
      'updatedAt': tour.line.updatedAt.toIso8601String(),
    },
  };
}
