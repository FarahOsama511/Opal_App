import 'package:dartz/dartz.dart';
import 'package:opal_app/core/errors/failure.dart';
import 'package:opal_app/features/auth/Domain/entities/login_entity.dart';

import 'package:opal_app/features/auth/Domain/repositires/auth_repo.dart';

class LoginUsecase {
  final AuthRepository authRepository;

  LoginUsecase(this.authRepository);

  Future<Either<Failure, LoginEntity>> call(
    String phone,
    String universityCardId,
  ) {
    return authRepository.login(phone, universityCardId);
  }
}
