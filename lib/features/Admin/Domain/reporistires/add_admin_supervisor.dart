import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../../user/Domain/entities/user_entity.dart';

abstract class AddAdminORSupervisorRepo {
  Future<Either<Failure, Unit>> AddAdminOrSupervisor(UserEntity user);
  Future<Either<Failure, Unit>> UpdateAdminOrSupervisor(UserEntity user);
}
