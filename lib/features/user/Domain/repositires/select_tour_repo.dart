import 'package:dartz/dartz.dart';
import 'package:opal_app/features/Admin/Domain/entities/tour.dart';

import '../../../../core/errors/failure.dart';

abstract class SelectionTourRepo {
  Future<Either<Failure, Tour>> SelectionTourByUser(String tourId);
  Future<Either<Failure, Unit>> UnConfirmTourByUser(String tourId);
}
