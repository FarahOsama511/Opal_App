import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../repositires/select_tour_repo.dart';

class UnconfirmTourUseCase {
  final SelectionTourRepo selectionTourRepo;

  UnconfirmTourUseCase(this.selectionTourRepo);
  Future<Either<Failure, Unit>> call(String id) {
    return selectionTourRepo.UnConfirmTourByUser(id);
  }
}
