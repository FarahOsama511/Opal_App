import '../../Domain/entities/login_entity.dart';
import '../../Domain/entities/user_entity.dart';

class LoginModel extends LoginEntity {
  LoginModel({required super.user, required super.token});
  factory LoginModel.fromJson(Map<String, dynamic> json) {
    final userJson = json['user'] ?? {};
    return LoginModel(
      user: UserEntity(
        id: userJson['id'] ?? "",
        name: userJson['name'] ?? "",
        phone: userJson['phone'] ?? "",
        role: userJson['role'] ?? "",
        universityId: userJson['universityId'] ?? "",
        universityCardId: userJson['universityCardId'] ?? "",
      ),
      token: json['token'] ?? "",
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
