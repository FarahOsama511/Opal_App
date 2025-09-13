import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/line_entity.dart';
import '../reporistires/line_repo.dart';

class GetAllLinesUseCase {
  final LineRepo repository;

  GetAllLinesUseCase(this.repository);

  Future<Either<Failure, List<LineEntity>>> call() async {
    return await repository.getAllLines();
  }
}
