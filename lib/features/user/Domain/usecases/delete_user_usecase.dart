import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../repositires/user_repo.dart';

class DeleteUserUsecase {
  final UserRepo userRepo;

  DeleteUserUsecase(this.userRepo);
  Future<Either<Failure, Unit>> call(String id) {
    return userRepo.deleteUser(id);
  }
}
