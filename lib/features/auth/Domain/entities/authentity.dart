import 'package:equatable/equatable.dart';
import 'package:opal_app/features/auth/Domain/entities/user_entity.dart';

class RegisterEntity extends Equatable {
  final UserEntity user;

  RegisterEntity({required this.user});

  @override
  List<Object?> get props => [user];
}
