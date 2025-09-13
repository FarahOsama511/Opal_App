import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/university_entity.dart';
import '../repositires/university_repo.dart';

class AddUniversityUsecase {
  final UniversityRepo universityRepo;

  AddUniversityUsecase(this.universityRepo);
  Future<Either<Failure, Unit>> call(UniversityEntity university) {
    return universityRepo.addUniversity(university);
  }
}
