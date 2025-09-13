import '../../Domain/entities/user_entity.dart';

abstract class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserSuccess extends UserState {
  List<UserEntity> user;
  UserSuccess(this.user);
}

class ActivateUser extends UserState {
  UserEntity activateUser;
  ActivateUser(this.activateUser);
}

class DeactivateUser extends UserState {
  UserEntity deactivateUser;
  DeactivateUser(this.deactivateUser);
}

class UserByIdSuccess extends UserState {
  UserEntity userById;
  UserByIdSuccess(this.userById);
}

class UserError extends UserState {
  final String message;
  UserError(this.message);
}
