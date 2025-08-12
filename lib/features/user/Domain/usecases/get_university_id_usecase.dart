import 'package:dartz/dartz.dart';
import 'package:opal_app/features/user/Domain/entities/university_entity.dart';
import 'package:opal_app/features/user/Domain/repositires/university_repo.dart';

import '../../../../core/errors/failure.dart';

class GetUniversityIdUsecase {
  final UniversityRepo universityRepo;

  GetUniversityIdUsecase(this.universityRepo);
  Future<Either<Failure, UniversityEntity>> call(String universityId) {
    return universityRepo.getUniversityById(universityId);
  }
}
