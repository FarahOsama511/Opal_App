import 'package:dartz/dartz.dart';
import 'package:opal_app/features/Admin/Domain/entities/tour.dart';
import 'package:opal_app/features/Admin/Domain/reporistires/line_repo.dart';

import '../../../../core/errors/failure.dart';

class GetAllLinesUseCase {
  final LineRepo repository;

  GetAllLinesUseCase(this.repository);

  Future<Either<Failure, List<LineEntity>>> call() async {
    return await repository.getAllLines();
  }
}
