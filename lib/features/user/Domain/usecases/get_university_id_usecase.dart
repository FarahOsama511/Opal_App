import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/university_entity.dart';
import '../repositires/university_repo.dart';

class GetUniversityIdUsecase {
  final UniversityRepo universityRepo;

  GetUniversityIdUsecase(this.universityRepo);
  Future<Either<Failure, UniversityEntity>> call(String universityId) {
    return universityRepo.getUniversityById(universityId);
  }
}
