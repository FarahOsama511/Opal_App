import 'package:dartz/dartz.dart';
import 'package:opal_app/core/errors/failure.dart';
import 'package:opal_app/features/auth/Domain/entities/authentity.dart';
import 'package:opal_app/features/auth/Domain/repositires/auth_repo.dart';

class RegisterUsecase {
  final AuthRepository authRepository;
  RegisterUsecase(this.authRepository);
  Future<Either<Failure, RegisterEntity>> call(
    RegisterEntity registerEntity,
  ) async {
    return await authRepository.register(registerEntity);
  }
}
