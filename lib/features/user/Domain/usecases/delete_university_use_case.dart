import 'package:dartz/dartz.dart';
import 'package:opal_app/features/user/Domain/repositires/university_repo.dart';
import '../../../../core/errors/failure.dart';

class DeleteUniversityUseCase {
  final UniversityRepo universityRepo;

  DeleteUniversityUseCase(this.universityRepo);
  Future<Either<Failure, Unit>> call(String id) {
    return universityRepo.DeleteUniversity(id);
  }
}
