import 'package:dartz/dartz.dart';
import 'package:opal_app/core/errors/failure.dart';
import 'package:opal_app/features/Admin/Domain/entities/tour.dart';
import 'package:opal_app/features/Admin/Domain/reporistires/line_repo.dart';

class GetLineByIdUseCase {
  final LineRepo lineRepo;

  GetLineByIdUseCase(this.lineRepo);
  Future<Either<Failure, LineEntity>> call(String id) {
    return lineRepo.getLineById(id);
  }
}
