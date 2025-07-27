import 'package:equatable/equatable.dart';
import 'package:opal_app/features/user/Domain/entities/user_entity.dart';

class RegisterEntity extends Equatable {
  final UserEntity user;

  const RegisterEntity({required this.user});

  @override
  List<Object?> get props => [user];
}
