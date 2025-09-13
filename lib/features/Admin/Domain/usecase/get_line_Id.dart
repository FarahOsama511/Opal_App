import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/line_entity.dart';
import '../reporistires/line_repo.dart';

class GetLineByIdUseCase {
  final LineRepo lineRepo;

  GetLineByIdUseCase(this.lineRepo);
  Future<Either<Failure, LineEntity>> call(String id) {
    return lineRepo.getLineById(id);
  }
}
