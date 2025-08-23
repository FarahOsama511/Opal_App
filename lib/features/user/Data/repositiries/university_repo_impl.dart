import 'package:dartz/dartz.dart';
import 'package:opal_app/features/user/Data/datasource/university_data_source.dart';
import 'package:opal_app/features/user/Data/datasource/university_local_data_source.dart';
import 'package:opal_app/features/user/Domain/entities/university_entity.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/network/network_info.dart';
import '../../Domain/repositires/university_repo.dart';
import '../models/university_model.dart';

class UniversityRepoImpl extends UniversityRepo {
  final UniversityDataSource universityDataSource;
  final NetworkInfo networkInfo;
  final UniversityLocalDataSource universityLocalDataSource;

  UniversityRepoImpl({
    required this.universityDataSource,
    required this.networkInfo,
    required this.universityLocalDataSource,
  });

  @override
  Future<Either<Failure, List<UniversityEntity>>> getAllUniversities() async {
    if (await networkInfo.isConnected) {
      try {
        final allUniversities = await universityDataSource.getAllUniversity();
        universityLocalDataSource.saveUniversities(allUniversities);
        return Right(allUniversities);
      } catch (e) {
        try {
          final localUniversities = await universityDataSource
              .getAllUniversity();
          print("========${localUniversities.length}==========");
          return Right(localUniversities);
        } on EmptyCacheException {
          return Left(EmptyCacheFailure());
        }
      }
    } else {
      try {
        final localUniversities = await universityLocalDataSource
            .getUniversities();
        print("========${localUniversities.length}==========");
        return Right(localUniversities);
      } on EmptyCacheException {
        return Left(EmptyCacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, UniversityEntity>> getUniversityById(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final university = await universityDataSource.getUniversityById(id);
        return Right(university);
      } on ServerException {
        throw ServerFailure();
      }
    } else {
      return Left(NoInternetFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> addUniversity(
    UniversityEntity university,
  ) async {
    if (await networkInfo.isConnected) {
      final UniversityModel universityModel = UniversityModel(
        id: university.id,
        name: university.name,
        location: university.location,
      );
      try {
        await universityDataSource.addUniversity(universityModel);
        return Right(unit);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NoInternetFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> DeleteUniversity(String id) async {
    if (await networkInfo.isConnected) {
      try {
        await universityDataSource.deleteUniversity(id);
        return Right(unit);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NoInternetFailure());
    }
  }
}
