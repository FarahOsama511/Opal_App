import 'package:dartz/dartz.dart';
import 'package:opal_app/features/user/Domain/entities/university_entity.dart';

import '../../../../core/errors/failure.dart';

abstract class UniversityRepo {
  Future<Either<Failure, List<UniversityEntity>>> getAllUniversities();
  Future<Either<Failure, UniversityEntity>> getUniversityById(String id);
  Future<Either<Failure, Unit>> addUniversity(UniversityEntity university);
  Future<Either<Failure, Unit>> deleteUniversity(String id);
  Future<Either<Failure, Unit>> updateUniversity(UniversityEntity university);
}
