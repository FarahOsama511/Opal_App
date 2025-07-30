import '../../Domain/entities/university_entity.dart';

class UniversityModel extends UniversityEntity {
  UniversityModel({super.id, super.name, super.location});
  factory UniversityModel.fromJson(Map<String, dynamic> json) {
    print("UNIVERSIT:$json");
    return UniversityModel(
      id: json['id'],
      name: json['name'],
      location: json['location'],
    );
  }
  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'location': location};
  }
}
