import 'package:dartz/dartz.dart';
import 'package:opal_app/core/errors/failure.dart';
import 'package:opal_app/features/user/Domain/entities/login_entity.dart';

import 'package:opal_app/features/user/Domain/repositires/auth_repo.dart';

class LoginUsecase {
  final AuthRepository authRepository;

  LoginUsecase(this.authRepository);

  Future<Either<Failure, LoginEntity>> call(
    String identifier,
    String credential,
    String role,
  ) {
    if (role == 'student') {
      return authRepository.loginStudent(
        identifier,
        credential,
      ); // phone, cardId
    } else {
      return authRepository.loginAdmin(
        identifier,
        credential,
        role,
      ); // email, password
    }
  }
}
