import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/network/network_info.dart';
import '../../../Admin/Domain/entities/down_town_entity.dart';
import '../../../Admin/Domain/entities/line_entity.dart';
import '../../Domain/entities/authentity.dart';
import '../../Domain/entities/login_entity.dart';
import '../../Domain/entities/user_entity.dart';
import '../../Domain/repositires/auth_repo.dart';
import '../datasource/remote_data_source.dart';
import '../models/register_model.dart';

class AuthRepoImpl extends AuthRepository {
  final AuthRemoteDataSource authremoteDataSource;
  final NetworkInfo networkInfo;
  AuthRepoImpl({required this.authremoteDataSource, required this.networkInfo});
  @override
  Future<Either<Failure, LoginEntity>> loginStudent(
    String phone,
    String universityCardId,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final user = await authremoteDataSource.loginStudent(
          phone,
          universityCardId,
        );
        return Right(user);
      } on WrongDataException {
        return Left(WrongDataFailure());
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      return Left(NoInternetFailure());
    }
  }

  @override
  Future<Either<Failure, RegisterEntity>> register(
    RegisterEntity authEntity,
  ) async {
    final registerModel = RegisterModel(
      user: UserEntity(
        downTown: authEntity.user.downTown != null
            ? DownTownEntity(id: authEntity.user.downTown!.id)
            : null,
        name: authEntity.user.name,
        phone: authEntity.user.phone,
        universityCardId: authEntity.user.universityCardId,
        universityId: authEntity.user.universityId,
        line: authEntity.user.line != null
            ? LineEntity(id: authEntity.user.line!.id)
            : null,
      ),
    );
    if (await networkInfo.isConnected) {
      try {
        final user = await authremoteDataSource.register(registerModel);
        return Right(user);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NoInternetFailure());
    }
  }

  @override
  Future<Either<Failure, LoginEntity>> loginAdmin(
    String email,
    String password,
    String role,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final adminOrSupervisors = await authremoteDataSource
            .loginAdminOrSuperVisor(email, password, role);
        return Right(adminOrSupervisors);
      } on WrongDataException {
        return Left(WrongDataFailure());
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      return Left(NoInternetFailure());
    }
  }
}
