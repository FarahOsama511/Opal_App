import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/user_entity.dart';

abstract class UserRepo {
  Future<Either<Failure, List<UserEntity>>> getAllUsers();
  Future<Either<Failure, UserEntity>> userIsActivate(
    String id,
    bool isActivated,
  );
  Future<Either<Failure, UserEntity>> userIsDeactivate(
    String id,
    bool isActivated,
  );
}
