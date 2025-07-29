import '../../Domain/entities/tour.dart';
import 'line_model.dart';

class TourModel extends Tour {
  TourModel({
    String? id,
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
    final lineJson = json['line'];
    return TourModel(
      id: json['id'] as String,
      type: json['type'] as String,
      driverName: json['driverName'] as String,
      leavesAt: DateTime.parse(json['leavesAt'] as String),
      line: lineJson != null
          ? LineModel.fromJson(lineJson as Map<String, dynamic>)
          : LineEntity(
              id: json['lineId'] ?? '',
              name: '',
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
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
    'line': tour.line != null ? (tour.line as LineModel).toJson() : null,
  };
}
