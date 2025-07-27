import 'package:dartz/dartz.dart';
import 'package:opal_app/features/user/Data/datasource/university_data_source.dart';
import 'package:opal_app/features/user/Domain/entities/university_entity.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/network/network_info.dart';
import '../../Domain/repositires/university_repo.dart';

class UniversityRepoImpl extends UniversityRepo {
  final UniversityDataSource universityDataSource;
  final NetworkInfo networkInfo;

  UniversityRepoImpl({
    required this.universityDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<UniversityEntity>>> getAllUniversities() async {
    if (await networkInfo.isConnected) {
      try {
        final allUniversities = await universityDataSource.getAllUniversity();

        return Right(allUniversities);
      } on ServerException {
        throw ServerFailure();
      }
    } else {
      return Left(NoInternetFailure());
    }
  }
}
