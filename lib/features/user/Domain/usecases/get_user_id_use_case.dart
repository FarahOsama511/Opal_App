import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/user_entity.dart';
import '../repositires/user_repo.dart';

class GetUserIdUseCase {
  final UserRepo userRepo;

  GetUserIdUseCase(this.userRepo);
  Future<Either<Failure, UserEntity>> call(String userId) {
    return userRepo.getUserById(userId);
  }
}
