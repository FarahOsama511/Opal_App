import 'package:opal_app/features/Admin/Domain/entities/tour.dart';

class LineModel extends LineEntity {
  LineModel({super.id, super.name});
  factory LineModel.fromJson(Map<String, dynamic> json) {
    return LineModel(id: json['id'], name: json['name']);
  }
  Map<String, dynamic> toJson() {
    return {"id": id, "name": name};
  }
}
