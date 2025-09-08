import 'package:dartz/dartz.dart';
import 'package:opal_app/features/Admin/Data/dataSource/down_town_local_data.dart';
import 'package:opal_app/features/Admin/Data/dataSource/down_town_remote_data_source.dart';
import 'package:opal_app/features/Admin/Data/models/down_town_model.dart';
import 'package:opal_app/features/Admin/Domain/entities/down_town_entity.dart';
import 'package:opal_app/features/Admin/Domain/reporistires/down_town_repo.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/network/network_info.dart';

class DownTownRepoImpl extends DownTownRepo {
  final DownTownRemoteDataSource downTownRemoteDataSource;
  final DownTownLocalDataSource localDataSource;
  final NetworkInfo networkInfo;
  DownTownRepoImpl(
    this.networkInfo, {
    required this.downTownRemoteDataSource,
    required this.localDataSource,
  });
  @override
  @override
  Future<Either<Failure, List<DownTownEntity>>> getAllDownTown() async {
    try {
      // 1️⃣ جرّب تعرض الكاش الأول لو موجود
      final localDownTowns = await localDataSource.getDownTown();
      if (localDownTowns.isNotEmpty) {
        // رجّعهم بسرعة للمستخدم
        Future.microtask(() async {
          if (await networkInfo.isConnected) {
            try {
              final remoteDownTowns = await downTownRemoteDataSource
                  .getAllDownTown();
              localDataSource.saveDownTown(remoteDownTowns);
            } catch (_) {}
          }
        });
        return Right(localDownTowns);
      }
    } catch (_) {}

    if (await networkInfo.isConnected) {
      try {
        final remoteDownTowns = await downTownRemoteDataSource.getAllDownTown();
        localDataSource.saveDownTown(remoteDownTowns);
        return Right(remoteDownTowns);
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      return Left(EmptyCacheFailure());
    }
  }

  Future<Either<Failure, Unit>> addDownTown(DownTownEntity downTown) async {
    final DownTownModel downTownModel = DownTownModel(name: downTown.name);
    if (await networkInfo.isConnected) {
      try {
        await downTownRemoteDataSource.addDownTown(downTownModel);
        return Right(unit);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NoInternetFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteDownTown(String id) async {
    if (await networkInfo.isConnected) {
      try {
        await downTownRemoteDataSource.deleteDownTown(id);
        return Right(unit);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NoInternetFailure());
    }
  }

  @override
  Future<Either<Failure, DownTownEntity>> getDownTownById(String id) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Unit>> updateDownTown(DownTownEntity downTown) async {
    final DownTownModel downTownModel = DownTownModel(
      name: downTown.name,
      id: downTown.id,
    );
    if (await networkInfo.isConnected) {
      try {
        await downTownRemoteDataSource.updateDownTown(downTownModel);
        return Right(unit);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NoInternetFailure());
    }
  }
}
