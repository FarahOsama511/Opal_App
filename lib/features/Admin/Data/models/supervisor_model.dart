import '../../Domain/entities/tour.dart';

class SuperVisorModel extends SuperVisorEntity {
  SuperVisorModel({super.id, super.name, super.phone});
  factory SuperVisorModel.fromJson(Map<String, dynamic> json) {
    return SuperVisorModel(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
    );
  }
  Map<String, dynamic> toJson() {
    return {"id": id, "name": name, "phone": phone};
  }
}
