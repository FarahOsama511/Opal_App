import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/user_entity.dart';

abstract class UserRepo {
  Future<Either<Failure, List<UserEntity>>> getAllUsers();
  Future<Either<Failure, UserEntity>> userIsActivate(String id, String status);
  Future<Either<Failure, UserEntity>> userIsDeactivate(
    String id,
    String status,
  );
  Future<Either<Failure, UserEntity>> getUserById(String userId);
  Future<Either<Failure, Unit>> deleteUser(String userId);
}
