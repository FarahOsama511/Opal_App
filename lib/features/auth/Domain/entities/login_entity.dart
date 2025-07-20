import 'package:equatable/equatable.dart';
import 'package:opal_app/features/auth/Domain/entities/user_entity.dart';

class LoginEntity extends Equatable {
  final UserEntity user;
  final String token;

  LoginEntity({required this.user, required this.token});

  @override
  List<Object?> get props => [user, token];
}
