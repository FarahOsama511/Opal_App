import 'package:dartz/dartz.dart';
import 'package:opal_app/features/user/Domain/repositires/user_repo.dart';

import '../../../../core/errors/failure.dart';
import '../entities/user_entity.dart';

class GetUserIdUseCase {
  final UserRepo userRepo;

  GetUserIdUseCase(this.userRepo);
  Future<Either<Failure, UserEntity>> call(String userId) {
    return userRepo.getUserById(userId);
  }
}
