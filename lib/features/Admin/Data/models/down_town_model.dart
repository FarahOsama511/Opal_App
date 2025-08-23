import 'package:opal_app/features/Admin/Domain/entities/down_town_entity.dart';
import '../../../user/Data/models/user_model.dart';

class DownTownModel extends DownTownEntity {
  DownTownModel({super.id, super.name, super.users});
  factory DownTownModel.fromJson(Map<String, dynamic> json) {
    final usersJson = json['users'];
    return DownTownModel(
      id: json['id'],
      name: json['name'],
      users:
          (json['users'] as List<dynamic>?)
              ?.map((user) => UserModel.fromJson(user))
              .toList() ??
          [],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      'users': users?.map((user) => (user as UserModel).toJson()).toList(),
    };
  }
}
