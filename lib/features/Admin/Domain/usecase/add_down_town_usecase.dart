import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/down_town_entity.dart';
import '../reporistires/down_town_repo.dart';

class AddDownTownUsecase {
  DownTownRepo downTownRepo;
  AddDownTownUsecase(this.downTownRepo);
  Future<Either<Failure, Unit>> call(DownTownEntity downTown) {
    return downTownRepo.addDownTown(downTown);
  }
}
