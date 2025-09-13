import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../repositires/university_repo.dart';

class DeleteUniversityUseCase {
  final UniversityRepo universityRepo;

  DeleteUniversityUseCase(this.universityRepo);
  Future<Either<Failure, Unit>> call(String id) {
    return universityRepo.deleteUniversity(id);
  }
}
