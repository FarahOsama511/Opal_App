import '../../Domain/entities/login_entity.dart';
import '../../Domain/entities/user_entity.dart';

class LoginModel extends LoginEntity {
  LoginModel({required super.user, required super.token});
  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      user: UserEntity(
        id: json['user']['id'] as String ?? "",
        name: json['user']['name'] as String ?? "",
        phone: json['user']['phone'] as String ?? "",
        role: json['user']['role'] as String ?? "",
        //  universityId: json['user']['universityId'] as String ?? "",
        // universityCardId: json['user']['universityCardId'] as String ?? "",
      ),
      token: json['token'] as String,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'user': {
        'id': user.id,
        'name': user.name,
        'phone': user.phone,
        'role': user.role,
        'universityId': user.universityId,
        'universityCardId': user.universityCardId,
      },
      'token': token,
    };
  }
}
