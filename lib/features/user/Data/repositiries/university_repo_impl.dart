import 'package:dartz/dartz.dart';
import 'package:opal_app/features/user/Data/datasource/university_data_source.dart';
import 'package:opal_app/features/user/Data/datasource/university_local_data_source.dart';
import 'package:opal_app/features/user/Domain/entities/university_entity.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/network/network_info.dart';
import '../../Domain/repositires/university_repo.dart';

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
}
