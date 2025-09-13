import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../../Admin/Domain/entities/tour.dart';

abstract class SelectionTourRepo {
  Future<Either<Failure, Tour>> SelectionTourByUser(String tourId);
  Future<Either<Failure, Unit>> UnConfirmTourByUser(String tourId);
}
