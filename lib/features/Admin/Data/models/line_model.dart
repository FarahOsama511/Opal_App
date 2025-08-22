import '../../Domain/entities/line_entity.dart';

class LineModel extends LineEntity {
  LineModel({super.id, super.name, super.notes});
  factory LineModel.fromJson(Map<String, dynamic> json) {
    return LineModel(id: json['id'], name: json['name'], notes: json['notes']);
  }
  Map<String, dynamic> toJson() {
    return {"id": id, "name": name, "notes": notes};
  }
}
