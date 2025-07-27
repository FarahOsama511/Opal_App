import 'package:dartz/dartz.dart';
import 'package:opal_app/features/user/Domain/repositires/user_repo.dart';

import '../../../../core/errors/failure.dart';
import '../entities/user_entity.dart';

class GetAllUserUseCase {
  final UserRepo userRepo;

  GetAllUserUseCase(this.userRepo);
  Future<Either<Failure, List<UserEntity>>> call() {
    return userRepo.getAllUsers();
  }
}
