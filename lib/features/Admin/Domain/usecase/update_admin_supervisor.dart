import 'package:dartz/dartz.dart';
import 'package:opal_app/core/errors/failure.dart';
import 'package:opal_app/features/user/Domain/entities/user_entity.dart';
import '../reporistires/add_admin_supervisor.dart';

class UpdateAdminSupervisorUseCase {
  AddAdminORSupervisorRepo UpdateAdminORSupervisor;
  UpdateAdminSupervisorUseCase(this.UpdateAdminORSupervisor);
  Future<Either<Failure, Unit>> call(UserEntity user) async {
    return await UpdateAdminORSupervisor.UpdateAdminOrSupervisor(user);
  }
}
