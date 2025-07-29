import 'package:dartz/dartz.dart';
import 'package:opal_app/features/Admin/Domain/entities/tour.dart';
import 'package:opal_app/features/user/Domain/repositires/select_tour_repo.dart';

import '../../../../core/errors/failure.dart';

class SelectionTourUseCase {
  final SelectionTourRepo selectionTourRepo;

  SelectionTourUseCase(this.selectionTourRepo);
  Future<Either<Failure, Tour>> call(String id) {
    return selectionTourRepo.SelectionTourByUser(id);
  }
}
