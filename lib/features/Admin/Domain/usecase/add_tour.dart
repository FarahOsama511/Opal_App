import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/tour.dart';
import '../reporistires/tour_repo.dart';

class AddTourUseCase {
  final ToursRepository repository;

  AddTourUseCase(this.repository);

  Future<Either<Failure, Unit>> call(Tour tour) async {
    return await repository.addTour(tour);
  }
}
