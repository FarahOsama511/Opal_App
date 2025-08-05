import 'package:dartz/dartz.dart';

import 'package:opal_app/core/errors/failure.dart';
import 'package:opal_app/features/Admin/Data/dataSource/add_admin_supervisor_datasource.dart';
import 'package:opal_app/features/Admin/Data/models/add_admin_supervisor_model.dart';

import 'package:opal_app/features/user/Domain/entities/user_entity.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/network_info.dart';
import '../../Domain/reporistires/add_admin_supervisor.dart';

class AddAdminSupervisorRepoImpl extends AddAdminORSupervisorRepo {
  final AddAdminSupervisorDatasource addAdminSupervisorDatasource;
  final NetworkInfo networkInfo;

  AddAdminSupervisorRepoImpl(
    this.addAdminSupervisorDatasource,
    this.networkInfo,
  );
  @override
  Future<Either<Failure, Unit>> AddAdminOrSupervisor(UserEntity user) async {
    final AddAdminSupervisorModel addAdminSupervisorModel =
        AddAdminSupervisorModel(
          id: user.id,
          name: user.name,
          password: user.password,
          phone: user.phone,
          role: user.role,
          email: user.email,
          lineId: user.lineId,
        );
    if (await networkInfo.isConnected) {
      try {
        await addAdminSupervisorDatasource.AddAdminOrSupervisor(
          addAdminSupervisorModel,
        );
        return Right(unit);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NoInternetFailure());
    }
  }
}
