import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../../user/Domain/entities/user_entity.dart';
import '../reporistires/add_admin_supervisor.dart';

class AddAdminSupervisorUseCase {
  AddAdminORSupervisorRepo addAdminORSupervisor;
  AddAdminSupervisorUseCase(this.addAdminORSupervisor);
  Future<Either<Failure, Unit>> call(UserEntity user) async {
    return await addAdminORSupervisor.AddAdminOrSupervisor(user);
  }
}
