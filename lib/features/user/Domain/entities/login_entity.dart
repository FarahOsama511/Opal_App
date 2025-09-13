import 'package:equatable/equatable.dart';
import 'user_entity.dart';

class LoginEntity extends Equatable {
  final UserEntity user;
  final String token;

  LoginEntity({required this.user, required this.token});

  @override
  List<Object?> get props => [user, token];
}
