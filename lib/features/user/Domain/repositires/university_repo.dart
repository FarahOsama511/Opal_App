import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/university_entity.dart';

abstract class UniversityRepo {
  Future<Either<Failure, List<UniversityEntity>>> getAllUniversities();
  Future<Either<Failure, UniversityEntity>> getUniversityById(String id);
  Future<Either<Failure, Unit>> addUniversity(UniversityEntity university);
  Future<Either<Failure, Unit>> deleteUniversity(String id);
  Future<Either<Failure, Unit>> updateUniversity(UniversityEntity university);
}
