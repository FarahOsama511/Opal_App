import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/tour.dart';
import '../reporistires/tour_repo.dart';

class UpdateTourUseCase {
  final ToursRepository repository;

  UpdateTourUseCase(this.repository);

  Future<Either<Failure, Unit>> call(Tour tour) async {
    return await repository.updateTour(tour);
  }
}
