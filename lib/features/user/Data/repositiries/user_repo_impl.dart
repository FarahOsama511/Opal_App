import 'package:dartz/dartz.dart';
import 'package:opal_app/core/errors/exceptions.dart';
import 'package:opal_app/core/errors/failure.dart';
import 'package:opal_app/core/network/network_info.dart';
import 'package:opal_app/features/user/Data/datasource/user_local_data_source.dart';
import 'package:opal_app/features/user/Data/datasource/user_remote_data_source.dart';
import 'package:opal_app/features/user/Domain/entities/user_entity.dart';
import 'package:opal_app/features/user/Domain/repositires/user_repo.dart';

class UserRepoImpl extends UserRepo {
  final UserRemoteDataSource userRemoteDataSource;
  final NetworkInfo networkInfo;
  final UserLocalDataSource userLocalDataSource;

  UserRepoImpl({
    required this.userRemoteDataSource,
    required this.networkInfo,
    required this.userLocalDataSource,
  });

  @override
  Future<Either<Failure, List<UserEntity>>> getAllUsers() async {
    try {
      // 1️⃣ حاول تجيب المستخدمين من الكاش الأول
      final localUsers = await userLocalDataSource.getUsers();
      if (localUsers.isNotEmpty) {
        // ✨ رجع الكاش بسرعة
        Future.microtask(() async {
          if (await networkInfo.isConnected) {
            try {
              // جدد الداتا من الـ API واحفظها
              final remoteUsers = await userRemoteDataSource.getAllUser();
              userLocalDataSource.saveUsers(remoteUsers);
            } catch (_) {}
          }
        });
        return Right(localUsers);
      }
    } catch (_) {
      // لو الكاش فاضي أو حصل خطأ → نكمل تحت
    }

    // 2️⃣ لو مفيش كاش → fallback على الـ API
    if (await networkInfo.isConnected) {
      try {
        final remoteUsers = await userRemoteDataSource.getAllUser();
        userLocalDataSource.saveUsers(remoteUsers);
        return Right(remoteUsers);
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      return Left(EmptyCacheFailure());
    }
  }

  @override
  Future<Either<Failure, UserEntity>> userIsActivate(
    String id,
    String status,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final userIsActivate = await userRemoteDataSource.userIsActivate(
          id,
          status,
        );
        // userLocalDataSource.saveUsers(userIsActivate);
        return Right(userIsActivate);
      } on ServerException {
        throw ServerFailure();
      }
    } else {
      return Left(NoInternetFailure());
    }
  }

  @override
  Future<Either<Failure, UserEntity>> userIsDeactivate(
    String id,
    String status,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final userIsDeactivate = await userRemoteDataSource.userIsDeactivate(
          id,
          status,
        );
        // userLocalDataSource.saveUsers(userIsActivate);
        return Right(userIsDeactivate);
      } on ServerException {
        throw ServerFailure();
      }
    } else {
      return Left(NoInternetFailure());
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getUserById(String userId) async {
    if (await networkInfo.isConnected) {
      try {
        final user = await userRemoteDataSource.getUserById(userId);
        // userLocalDataSource.saveUsers(userIsActivate);
        return Right(user);
      } on ServerException {
        throw ServerFailure();
      }
    } else {
      return Left(NoInternetFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteUser(String userId) async {
    if (await networkInfo.isConnected) {
      try {
        await userRemoteDataSource.deleteUser(userId);
        return Right(unit);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NoInternetFailure());
    }
  }
}
