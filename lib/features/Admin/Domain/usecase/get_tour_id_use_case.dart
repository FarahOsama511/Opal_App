import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/tour.dart';
import '../reporistires/tour_repo.dart';

class GetTourByIdUseCase {
  final ToursRepository toursRepository;

  GetTourByIdUseCase(this.toursRepository);
  Future<Either<Failure, Tour>> call(String id) {
    return toursRepository.getTourById(id);
  }
}
