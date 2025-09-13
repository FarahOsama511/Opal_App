import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/university_entity.dart';
import '../repositires/university_repo.dart';

class UpdateUniversityUsecase {
  final UniversityRepo universityRepo;

  UpdateUniversityUsecase(this.universityRepo);
  Future<Either<Failure, Unit>> call(UniversityEntity university) {
    return universityRepo.updateUniversity(university);
  }
}
