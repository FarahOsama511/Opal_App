import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/tour.dart';

abstract class ToursRepository {
  Future<Either<Failure, List<Tour>>> getAllTours();
  Future<Either<Failure, Unit>> addTour(Tour tour);
  Future<Either<Failure, Unit>> updateTour(Tour tour);
  Future<Either<Failure, Unit>> deleteTour(String id);
}
