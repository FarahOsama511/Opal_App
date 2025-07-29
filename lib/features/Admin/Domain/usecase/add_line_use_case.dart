import 'package:dartz/dartz.dart';
import 'package:opal_app/features/Admin/Domain/entities/tour.dart';
import 'package:opal_app/features/Admin/Domain/reporistires/line_repo.dart';

import '../../../../core/errors/failure.dart';

class AddLineUseCase {
  final LineRepo lineRepo;

  AddLineUseCase(this.lineRepo);

  Future<Either<Failure, Unit>> call(LineEntity line) async {
    return await lineRepo.AddLine(line);
  }
}
