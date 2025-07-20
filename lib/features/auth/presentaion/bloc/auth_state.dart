import 'package:opal_app/features/auth/Domain/entities/login_entity.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {}

class AuthFailure extends AuthState {
  final String error;
  AuthFailure(this.error);
}
