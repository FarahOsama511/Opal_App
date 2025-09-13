import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../../user/Domain/entities/user_entity.dart';
import '../reporistires/add_admin_supervisor.dart';

class UpdateAdminSupervisorUseCase {
  AddAdminORSupervisorRepo UpdateAdminORSupervisor;
  UpdateAdminSupervisorUseCase(this.UpdateAdminORSupervisor);
  Future<Either<Failure, Unit>> call(UserEntity user) async {
    return await UpdateAdminORSupervisor.UpdateAdminOrSupervisor(user);
  }
}
