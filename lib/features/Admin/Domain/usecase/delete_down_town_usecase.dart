import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../reporistires/down_town_repo.dart';

class DeleteDownTownUsecase {
  DownTownRepo downTownRepo;
  DeleteDownTownUsecase(this.downTownRepo);
  Future<Either<Failure, Unit>> call(String id) {
    return downTownRepo.deleteDownTown(id);
  }
}
