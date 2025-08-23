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
  Future<Either<Failure, List<DownTownEntity>>> getAllDownTown() async {
    if (await networkInfo.isConnected) {
      try {
        final downTowns = await downTownRemoteDataSource.getAllDownTown();
        localDataSource.saveDownTown(downTowns);
        return Right(downTowns);
      } catch (e) {
        try {
          final localDownTown = await localDataSource.getDownTown();
          print("========${localDownTown.length}==========");
          return Right(localDownTown);
        } on EmptyCacheException {
          return Left(EmptyCacheFailure());
        }
      }
    } else {
      final localDownTown = await localDataSource.getDownTown();
      try {
        return Right(localDownTown);
      } on EmptyCacheException {
        return Left(EmptyCacheFailure());
      }
    }
  }

  Future<Either<Failure, Unit>> AddDownTown(DownTownEntity downTown) async {
    final DownTownModel downTownModel = DownTownModel(name: downTown.name);
    if (await networkInfo.isConnected) {
      try {
        await downTownRemoteDataSource.AddDownTown(downTownModel);
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
    // TODO: implement getDownTownById
    throw UnimplementedError();
  }
}
