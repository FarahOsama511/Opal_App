import 'package:dartz/dartz.dart';
import 'package:opal_app/core/errors/failure.dart';
import 'package:opal_app/features/user/Domain/entities/user_entity.dart';

abstract class AddAdminORSupervisorRepo {
  Future<Either<Failure, Unit>> AddAdminOrSupervisor(UserEntity user);
}
