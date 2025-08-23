import 'package:dartz/dartz.dart';
import 'package:opal_app/core/errors/failure.dart';
import 'package:opal_app/features/Admin/Domain/entities/down_town_entity.dart';
import 'package:opal_app/features/Admin/Domain/reporistires/down_town_repo.dart';

class GetAllDownTownUsecase {
  DownTownRepo downTownRepo;
  GetAllDownTownUsecase(this.downTownRepo);
  Future<Either<Failure, List<DownTownEntity>>> call() {
    return downTownRepo.getAllDownTown();
  }
}
