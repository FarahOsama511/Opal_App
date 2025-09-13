import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../../Admin/Domain/entities/tour.dart';
import '../repositires/select_tour_repo.dart';

class SelectionTourUseCase {
  final SelectionTourRepo selectionTourRepo;

  SelectionTourUseCase(this.selectionTourRepo);
  Future<Either<Failure, Tour>> call(String id) {
    return selectionTourRepo.SelectionTourByUser(id);
  }
}
