import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/user_entity.dart';
import '../repositires/user_repo.dart';

class GetAllUserUseCase {
  final UserRepo userRepo;

  GetAllUserUseCase(this.userRepo);
  Future<Either<Failure, List<UserEntity>>> call() {
    return userRepo.getAllUsers();
  }
}
