import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/network/network_info.dart';
import '../../Domain/entities/tour.dart';
import '../../Domain/reporistires/tour_repo.dart';
import '../dataSource/tour_local_data_source.dart';
import '../dataSource/tour_remote_data_source.dart';
import '../models/tour_model.dart';

class TourRepoImpl extends ToursRepository {
  final LocalDataSource localDataSource;
  final TourRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  TourRepoImpl(
    this.networkInfo, {
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<Tour>>> getAllTours() async {
    if (await networkInfo.isConnected) {
      try {
        final rempotsTour = await remoteDataSource.getAllTours();
        localDataSource.saveTours(rempotsTour);
        return Right(rempotsTour);
      } catch (e) {
        try {
          final localTours = await localDataSource.getTours();
          print("========${localTours.length}==========");
          return Right(localTours);
        } on EmptyCacheException {
          return Left(EmptyCacheFailure());
        }
      }
      //  on ServerException {
      //   return Left(ServerFailure());
      // }
    } else {
      try {
        final localTours = await localDataSource.getTours();
        print("========${localTours.length}==========");
        return Right(localTours);
      } on EmptyCacheException {
        return Left(EmptyCacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, Unit>> addTour(Tour tour) async {
    final TourModel tourModel = TourModel(
      supervisor: tour.supervisor,
      startTime: tour.startTime,
      endTime: tour.endTime,
      type: tour.type,
      leavesAt: tour.leavesAt,
      line: tour.line,
    );
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.addTour(tourModel);
        return Right(unit);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NoInternetFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteTour(String id) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteTour(id);
        return Right(unit);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NoInternetFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> updateTour(Tour tour) async {
    final TourModel tourModel = TourModel(
      id: tour.id,
      supervisor: tour.supervisor,
      startTime: tour.startTime,
      endTime: tour.endTime,
      type: tour.type,
      leavesAt: tour.leavesAt,
      line: tour.line,
    );
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.updateTour(tourModel);
        return Right(unit);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NoInternetFailure());
    }
  }

  @override
  Future<Either<Failure, Tour>> getTourById(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final tour = await remoteDataSource.getTourById(id);
        return Right(tour);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NoInternetFailure());
    }
  }
}
