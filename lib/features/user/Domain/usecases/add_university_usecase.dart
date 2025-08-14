import 'package:dartz/dartz.dart';
import 'package:opal_app/features/user/Domain/entities/university_entity.dart';
import 'package:opal_app/features/user/Domain/repositires/university_repo.dart';

import '../../../../core/errors/failure.dart';

class AddUniversityUsecase {
  final UniversityRepo universityRepo;

  AddUniversityUsecase(this.universityRepo);
  Future<Either<Failure, Unit>> call(UniversityEntity university) {
    return universityRepo.addUniversity(university);
  }
}
