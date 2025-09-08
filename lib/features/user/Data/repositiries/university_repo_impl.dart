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
  @override
  Future<Either<Failure, List<UniversityEntity>>> getAllUniversities() async {
    try {
      // 1️⃣ جرّب تعرض الكاش الأول لو موجود
      final localUniversities = await universityLocalDataSource
          .getUniversities();
      if (localUniversities.isNotEmpty) {
        // رجّعهم بسرعة للمستخدم
        Future.microtask(() async {
          if (await networkInfo.isConnected) {
            try {
              final remoteUniversities = await universityDataSource
                  .getAllUniversity();
              universityLocalDataSource.saveUniversities(remoteUniversities);
            } catch (_) {}
          }
        });
        return Right(localUniversities);
      }
    } catch (_) {
      // مفيش كاش
    }

    // 2️⃣ fallback: API
    if (await networkInfo.isConnected) {
      try {
        final remoteUniversities = await universityDataSource
            .getAllUniversity();
        universityLocalDataSource.saveUniversities(remoteUniversities);
        return Right(remoteUniversities);
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      return Left(EmptyCacheFailure());
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
  Future<Either<Failure, Unit>> deleteUniversity(String id) async {
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

  @override
  Future<Either<Failure, Unit>> updateUniversity(
    UniversityEntity university,
  ) async {
    if (await networkInfo.isConnected) {
      final UniversityModel universityModel = UniversityModel(
        id: university.id,
        name: university.name,
        location: university.location,
      );
      try {
        await universityDataSource.updateUniversity(universityModel);
        return Right(unit);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NoInternetFailure());
    }
  }
}
