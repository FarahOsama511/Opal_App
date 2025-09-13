import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/network/network_info.dart';
import '../../Domain/entities/down_town_entity.dart';
import '../../Domain/reporistires/down_town_repo.dart';
import '../dataSource/down_town_local_data.dart';
import '../dataSource/down_town_remote_data_source.dart';
import '../models/down_town_model.dart';

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
    try {
      if (await networkInfo.isConnected) {
        final remoteDownTowns = await downTownRemoteDataSource.getAllDownTown();
        await localDataSource.saveDownTown(remoteDownTowns);
        return Right(remoteDownTowns);
      }
      final localDownTowns = await localDataSource.getDownTown();
      if (localDownTowns.isNotEmpty) {
        return Right(localDownTowns);
      } else {
        return Left(EmptyCacheFailure());
      }
    } catch (e) {
      if (e is ServerException) {
        return Left(ServerFailure());
      } else {
        return Left(EmptyCacheFailure());
      }
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
