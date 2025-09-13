import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/login_entity.dart';
import '../repositires/auth_repo.dart';

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
