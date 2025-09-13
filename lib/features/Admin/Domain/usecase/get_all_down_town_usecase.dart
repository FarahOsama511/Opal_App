import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/down_town_entity.dart';
import '../reporistires/down_town_repo.dart';

class GetAllDownTownUsecase {
  DownTownRepo downTownRepo;
  GetAllDownTownUsecase(this.downTownRepo);
  Future<Either<Failure, List<DownTownEntity>>> call() {
    return downTownRepo.getAllDownTown();
  }
}
