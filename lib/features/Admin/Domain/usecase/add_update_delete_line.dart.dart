import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/line_entity.dart';
import '../reporistires/line_repo.dart';

class AddLineUseCase {
  final LineRepo lineRepo;

  AddLineUseCase(this.lineRepo);
  Future<Either<Failure, Unit>> call(LineEntity lineEntity) {
    return lineRepo.AddLine(lineEntity);
  }
}

class UpdateLineUseCase {
  final LineRepo lineRepo;

  UpdateLineUseCase(this.lineRepo);
  Future<Either<Failure, Unit>> call(LineEntity lineEntity) {
    return lineRepo.updateLine(lineEntity);
  }
}

class DeleteLineUseCase {
  final LineRepo lineRepo;

  DeleteLineUseCase(this.lineRepo);
  Future<Either<Failure, Unit>> call(String Id) {
    return lineRepo.deleteLine(Id);
  }
}
