import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/down_town_entity.dart';

abstract class DownTownRepo {
  Future<Either<Failure, List<DownTownEntity>>> getAllDownTown();
  Future<Either<Failure, DownTownEntity>> getDownTownById(String id);
  Future<Either<Failure, Unit>> addDownTown(DownTownEntity downTownEntity);
  Future<Either<Failure, Unit>> updateDownTown(DownTownEntity downTownEntity);
  Future<Either<Failure, Unit>> deleteDownTown(String id);
}
