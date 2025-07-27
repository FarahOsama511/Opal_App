import 'package:dartz/dartz.dart';
import 'package:opal_app/features/user/Domain/entities/university_entity.dart';

import '../../../../core/errors/failure.dart';
import '../repositires/university_repo.dart';

class GetAllUniveristiesUseCase {
  final UniversityRepo universityRepo;

  GetAllUniveristiesUseCase(this.universityRepo);
  Future<Either<Failure, List<UniversityEntity>>> call() async {
    return await universityRepo.getAllUniversities();
  }
}
