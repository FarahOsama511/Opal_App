import 'package:dartz/dartz.dart';
import 'package:opal_app/core/errors/failure.dart';
import 'package:opal_app/features/Admin/Domain/reporistires/down_town_repo.dart';

class DeleteDownTownUsecase {
  DownTownRepo downTownRepo;
  DeleteDownTownUsecase(this.downTownRepo);
  Future<Either<Failure, Unit>> call(String id) {
    return downTownRepo.deleteDownTown(id);
  }
}
