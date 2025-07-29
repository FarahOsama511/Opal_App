import 'package:dartz/dartz.dart';
import 'package:opal_app/features/Admin/Domain/reporistires/tour_repo.dart';

import '../../../../core/errors/failure.dart';
import '../entities/tour.dart';

class GetTourByIdUseCase {
  final ToursRepository toursRepository;

  GetTourByIdUseCase(this.toursRepository);
  Future<Either<Failure, Tour>> call(String id) {
    return toursRepository.getTourById(id);
  }
}
