import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../reporistires/tour_repo.dart';

class DeleteTourUseCase {
  final ToursRepository repository;

  DeleteTourUseCase(this.repository);

  Future<Either<Failure, Unit>> call(String tourId) async {
    return await repository.deleteTour(tourId);
  }
}
