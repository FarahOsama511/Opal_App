import 'package:dartz/dartz.dart';
import 'package:opal_app/core/errors/failure.dart';
import 'package:opal_app/core/network/network_info.dart';
import 'package:opal_app/features/Tours/Domain/entities/tour.dart';
import 'package:opal_app/features/auth/Data/datasource/remote_data_source.dart';
import 'package:opal_app/features/auth/Domain/entities/authentity.dart';
import 'package:opal_app/features/auth/Domain/entities/login_entity.dart';
import 'package:opal_app/features/auth/Domain/entities/user_entity.dart';
import 'package:opal_app/features/auth/Domain/repositires/auth_repo.dart';

import '../../../../core/errors/exceptions.dart';
import '../models/register_model.dart';

class AuthRepoImpl extends AuthRepository {
  final AuthRemoteDataSource authremoteDataSource;
  final NetworkInfo networkInfo;
  AuthRepoImpl({required this.authremoteDataSource, required this.networkInfo});
  @override
  Future<Either<Failure, LoginEntity>> login(
    String phone,
    String universityCardId,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final user = await authremoteDataSource.login(phone, universityCardId);
        return Right(user);
      } on WrongDataException {
        return Left(WrongDataFailure());
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
}
