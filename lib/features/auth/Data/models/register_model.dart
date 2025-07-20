import 'package:opal_app/features/auth/Domain/entities/authentity.dart';
import '../../Domain/entities/user_entity.dart';

class RegisterModel extends RegisterEntity {
  RegisterModel({required super.user});
  factory RegisterModel.fromJson(Map<String, dynamic> json) {
    return RegisterModel(
      user: UserEntity(
        name: json['user']['name'] ?? "",
        phone: json['user']['phone'] ?? "",
      ),
    );
  }
  Map<String, dynamic> toJson() {
    return {'name': user.name, 'phone': user.phone};
  }
}
