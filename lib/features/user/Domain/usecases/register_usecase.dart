import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/authentity.dart';
import '../repositires/auth_repo.dart';

class RegisterUsecase {
  final AuthRepository authRepository;
  RegisterUsecase(this.authRepository);
  Future<Either<Failure, RegisterEntity>> call(
    RegisterEntity registerEntity,
  ) async {
    return await authRepository.register(registerEntity);
  }
}
