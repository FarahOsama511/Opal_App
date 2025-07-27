import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/tour.dart';
import '../reporistires/tour_repo.dart';

class GetAllToursUseCase {
  final ToursRepository repository;

  GetAllToursUseCase(this.repository);

  Future<Either<Failure, List<Tour>>> call() async {
    return await repository.getAllTours();
  }
}
