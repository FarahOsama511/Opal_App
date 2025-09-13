import 'dart:developer';
import '../../Domain/entities/university_entity.dart';
import 'user_model.dart';

class UniversityModel extends UniversityEntity {
  UniversityModel({super.id, super.name, super.location, super.users});
  factory UniversityModel.fromJson(Map<String, dynamic> json) {
    final usersJson = json['users'] as List<dynamic>?;
    print("UNIVERSIT:$json");
    log("universities are ${json}");
    return UniversityModel(
      id: json['id'],
      name: json['name'],
      location: json['location'],
      users: usersJson?.map((user) => UserModel.fromJson(user)).toList(),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'users': users?.map((user) => (user as UserModel).toJson()).toList(),
    };
  }
}
