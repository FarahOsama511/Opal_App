import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/user_entity.dart';
import '../repositires/user_repo.dart';

class UserIsactivatUseCase {
  final UserRepo userRepo;

  UserIsactivatUseCase(this.userRepo);
  Future<Either<Failure, UserEntity>> call(String id, bool isActivated) {
    return userRepo.userIsActivate(id, isActivated);
  }
}
